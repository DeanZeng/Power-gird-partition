function adj=makeAdj(branch)
%##################################################################
% Build node adjacancy matrix
% 
% INPUTS: branch list: mx2, m - number of branches
% OUTPUTS: adjacency matrix nxn, n - number of nodes
%
%##################################################################

nodes=sort(unique([branch(:,1) branch(:,2)])); % get all nodes, sorted
adj=zeros(numel(nodes));         % initialize adjacency matrix

% across all edges
for i=1:size(branch,1); 
    adj(find(nodes==branch(i,1)),find(nodes==branch(i,2)))=1;
    adj(find(nodes==branch(i,2)),find(nodes==branch(i,1)))=1;
end
