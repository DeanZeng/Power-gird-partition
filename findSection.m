function SctL = findSection (adj,disL)
%##################################################################
% Search section brances
% 
% INPUTS: adjacency matrix nxn, n - number of nodes
%         disconnect lines lx2 
% OUTPUTS:section lines mx2
%
%##################################################################
comp_mat = findConnComp(adj);
sctk=0;
SctL=[0,0];
for c=1:length(disL); 
    if(any(comp_mat{1}==disL(c,1))&&any(comp_mat{2}==disL(c,2)))
        sctk=sctk+1;
        SctL(sctk,:)=disL(c,:);
        continue;
    end
    if(any(comp_mat{2}==disL(c,1))&&any(comp_mat{1}==disL(c,2)))
        sctk=sctk+1;
        SctL(sctk,:)=disL(c,:);
        continue;
    end
end