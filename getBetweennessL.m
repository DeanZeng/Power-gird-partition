function Bl=getBetweennessL(PTDF,Pnet,gen,loads,l)
%##################################################################
% Get the Betwneenness of the Line l;
% 
% INPUTS: PTDF: mxn, m---number of branches, n---number of nodes
%         Pnet: branch active power; mx1 m---number of branches
%         gen:  mpc.generator;
%         loads: mpc.loads;
%         l:     index of the branch
% OUTPUTS: line betweenness: 1x1
%
%##################################################################

branchNum=length(PTDF(:,1));
busNum=length(PTDF(1,:));
genNum=length(gen(:,1));
loadNum=length(loads(:,1));
Bl=0;
for i=1:genNum
    for j=1:loadNum
    %  Bl=Bl+abs(gen(i,2))*abs(loads(j,2))*abs(PTDF(l,gen(i,1))-PTDF(l,loads(j,1)));
       TCij=fastTC(PTDF,Pnet,gen(i,1),loads(j,1));
       Bl=Bl+TCij*abs(PTDF(l,gen(i,1))-PTDF(l,loads(j,1)));
    end
    if isnan(Bl)
        i
        j
    end
end