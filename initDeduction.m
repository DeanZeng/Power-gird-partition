function brsv=initDeduction(mpc,Vth)
%##################################################################
% deduction the network for initialization
% Expectation:
% 1. eliminate transformer branches. 
% 2. eliminate zero weight node.    - -o---o---o- -   =>  - -o-------o- -
% 3. merge hanging node.            - -o---o---o- -   
%                                          |          =>  - -o---o---o- -
%                                          o
% 4. reserve high voltage level lines.
%
% INPUTs: matpower case: 1x1 struct
%         reserve voltage threshold: 1x1
% OUTPUTs: bool 1-reserve 0-eliminated, mx1 m---number of branches 
%
% Other routines used: edgeBetweenness.m, isConnected.m,
%                findConnComp.m, subgraph.m, numEdges.m
%##################################################################
bn=size(mpc.branch,1);
brsv=ones(bn,1);

%% eliminate transformer branches and low voltage level lines
for i=1:bn
    %if transformer branch  |  Vn < Vth
    if mpc.branch(i,9)
        brsv(i)=0;
    end
    if mpc.bus(mpc.branch(i,1),10)< Vth
        brsv(i)=0;
    end
    if mpc.bus(mpc.branch(i,2),10)< Vth
        brsv(i)=0;
    end
end

%% eliminate zero weight node
nodeN=size(mpc.bus,1);
adj=makeAdj(mpc.branch(:,1:2));
deg=sum(adj);
for i=1:nodeN
    if deg(i)==2
        if(mpc.bus(i,3)==0)
        %zero weight node
            node1=find(adj(i,:),1);
            brsv(find((mpc.branch(:,1)==node1)&(mpc.branch(:,2)==i)))=0;
            brsv(find((mpc.branch(:,2)==node1)&(mpc.branch(:,1)==i)))=0;
        end
    end
    if deg(i)==1
        %hanging node
        brsv(find((mpc.branch(:,1)==i)|(mpc.branch(:,2)==i)))=0;
    end
end



