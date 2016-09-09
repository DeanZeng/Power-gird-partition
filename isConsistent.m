function S=isConsistent(LODF,PL,branch)
%##################################################################
% Determine if branches' power directory is consistent
% 
% INPUTS: LODF matrix mxm,  m - number of branches
%         PL: branch power mx3, m - number of branches
%         branch list: lx2, l - number of branches
%
% OUTPUTS: Boolean variable, 0 or 1
%
%##################################################################

bn=size(branch,1);
S=1;
for i=1:bn
    for j=i+1:bn
        ind1=find((PL(:,1)==branch(i,1))&(PL(:,2)==branch(i,2)),1);
        ind2=find((PL(:,1)==branch(j,1))&(PL(:,2)==branch(j,2)),1);
        if(LODF(ind1,ind2)*PL(ind2,3)*PL(ind1,3)<0)
            S=0;
            break;
        end   
    end
    if S==0
        break;
    end
end