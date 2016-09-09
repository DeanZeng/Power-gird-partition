%##################################################################
% Newman-Girvan community finding algorithm
% Source: Newman, Girvan, "Finding and evaluating 
%                          community structure in networks"
% Algorithm idea:
% 1. Calculate betweenness scores for all edges in the network.
% 2. Find the edge with the highest score and remove it from the network.
% 3. Recalculate betweenness for all remaining edges.
% 4. Repeat from step 2.
%
% INPUTs: matpower case, 1x1 struct
%         number of modules, 1x1
%         voltage threshold, 1x1
% OUTPUTs: modules (components) and modules history - 
%          each "current" module,
%
% Other routines used: edgeBetweenness.m, isConnected.m,
%                findConnComp.m, subgraph.m, numEdges.m
% GB: last updated, Oct 11 2012
%##################################################################


function [modules,module_hist] = newmanGirvanPartion(mpc,k,Vth)

%% 潮流
pfresult=runpf(mpc);
PL=pfresult.branch(:,[1,2,14]);
slack=find(mpc.bus(:,2)==3);
PTDF=makePTDF(mpc.baseMVA, mpc.bus, mpc.branch, slack);
LODF=makeLODF(mpc.branch,PTDF);

%%
adj=makeAdj(mpc.branch(:,1:2));
n=size(adj,1);
module_hist{1} = [1:n]; % current component
modules{1}=[1:n];
curr_mod=1;

Brsv=initDeduction(mpc,Vth);
Btn=makeBetweenness(mpc,Brsv);

adj_temp=adj;
outB=[0,0];
outk=0;
while length(modules)<k
    
    [Btmax,indmax]=max(Btn(:,3));
    preOutB=Btn(indmax,1:2);
    pre_adj=adj_temp;
    pre_adj(Btn(indmax,1),Btn(indmax,2))=0;
    pre_adj(Btn(indmax,2),Btn(indmax,1))=0;
    pre_modules = findConnComp(pre_adj);
    if(length(pre_modules)>length(modules))         
    %产生新分区   
       %% 搜素新分割断面SctL
        for c=1:length(pre_modules); 
            if any(pre_modules{c}==preOutB(1));
                modind1=c;
            elseif any(pre_modules{c}==preOutB(2));
                modind2=c;
            end 
        end
        SctL=preOutB;
        for c=1:size(outB,1); 
            if(any(pre_modules{modind1}==outB(c,1))&&any(pre_modules{modind2}==outB(c,2)))
                SctL(size(SctL,1)+1,:)=outB(c,:);
            elseif (any(pre_modules{modind2}==outB(c,1))&&any(pre_modules{modind1}==outB(c,2)))
                SctL(size(SctL,1)+1,:)=outB(c,:);
            end
        end
       %% 判断有功潮流方向是否一致
        if isConsistent(LODF,PL,SctL);
            for c=1:length(modules);
                if any(modules{c}==preOutB(1))&&any(modules{c}==preOutB(2));
                    module_hist{length(module_hist)+1}=modules{c};
                end
            end
            outB(outk+1,:)=preOutB;
            outk=outk+1;
            adj_temp(Btn(indmax,1),Btn(indmax,2))=0;
            adj_temp(Btn(indmax,2),Btn(indmax,1))=0;
            Btn(indmax,:)=[];
        
            modules=findConnComp(adj_temp);
         else
            Btn(indmax,3)=0;
            continue;
        end
    else
    %没有产生新分区
        outB(outk+1,:)=preOutB;
        outk=outk+1;
        adj_temp(Btn(indmax,1),Btn(indmax,2))=0;
        adj_temp(Btn(indmax,2),Btn(indmax,1))=0;
        Btn(indmax,:)=[];
        continue;
    end
end % end of while loop
module_hist=module_hist(2:length(module_hist));
% % computing the modularity for the final module break-down
% % Defined as: Q=sum_over_modules_i (eii-ai^2) (eq 5) in Newman and Girvan.
% % eij = fraction of edges that connect community i to community j
% % ai=sum_j (eij)
% 
% nedges=numEdges(adj); % compute the total number of edges
% 
% Q = 0;
% for m=1:length(modules)
%   module=modules{m};
%   adj_m=subgraph(adj,module);
%   
%   e_mm=numEdges(adj_m)/nedges;
%   a_m=sum(sum(adj(module,:)))/nedges-e_mm;
%   
%   Q = Q + (e_mm - a_m^2);
% end