function  TC = fastTC(PTDF,Pnet,g,d)
%##################################################################
% Get the transmission capacity based on;
% 
% INPUTS: PTDF: mxn, m---number of branches, n---number of nodes
%         Pnet: branch active power; mx1 m---number of branches
%         g: index of generator
%         d: index of the demanded load
% OUTPUTS: line betweenness: 1x1
%
%##################################################################
if g==d
    TC=0;
else
    branchNum=length(PTDF(:,1));
    TC=inf;
    for i=1:branchNum
        if Pnet(i)==0
            continue;
        end
        TC_temp =Pnet(i)/abs(PTDF(i,g)-PTDF(i,d));
        if TC>TC_temp;
            TC=TC_temp;
        end
    end
end