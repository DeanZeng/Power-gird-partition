function Btness = makeBetweenness(mpc,bflag)
%##################################################################
% Build lines betweenness vector
% 
% INPUTS: matpower case: 1x1 struct
% OUTPUTS: lines betweenness vector: mx3,  m----number of branches
%          Boolean variable:mx1, m---number of brancher
%##################################################################
pfresult=runpf(mpc);
PL=abs(pfresult.branch(:,14));
slack=find(mpc.bus(:,2)==3);
PTDF=makePTDF(mpc.baseMVA, mpc.bus, mpc.branch, slack);
branchNum=length(PTDF(:,1));
busNum=length(PTDF(1,:));
Btness=zeros(branchNum,3);
for l=1:branchNum
        Btness(l,1)=mpc.branch(l,1);
        Btness(l,2)=mpc.branch(l,2);
    if bflag(l)
     %  Btness(l,3)=getBetweennessL(PTDF,mpc.gen,mpc.loads,l);
        Btness(l,3)=getBetweennessL(PTDF,PL,mpc.gen,mpc.loads,l);
    end
end