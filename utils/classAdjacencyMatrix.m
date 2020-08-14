function class_adj = classAdjacencyMatrix(...
    landmark_adj, landmark_classes, dictionary)
%CLASSADJACENCYMATRIX Class adjacency matrix from landmark graph.
%   Computes the class adjacency matrix from a landmark graph. Requires the
%   graph's adjacency matrix, the list of landmarks labels and the class
%   dictionary.
%   See Section II-C of the main paper (reference below) and Algorithm 1 in 
%   the supplemental material. 


%% Ground-to-Aerial Viewpoint Localization via Landmark Graphs Matching

%   Authors:    S. Verde, T. Resek, S. Milani, A. Rocha
%   Contacts:   anderson.rocha@ic.unicamp.br

%   Published on IEEE Signal Processing Letters, 2020


%%

% Initialize classes adjacency matrix and normalization factor
class_adj = zeros(max(dictionary) - min(dictionary) + 1);

% Loop over landmark adjacency matrix
for i = 1:size(landmark_adj, 1)
    for j = 1:i - 1       
        % If landmarks i and j are adjacent... 
        if landmark_adj(i, j)       
            % Add 1 to the adjacency count of class(i) and class(j)
            row = max(landmark_classes(i), landmark_classes(j)) + 1;
            col = min(landmark_classes(i), landmark_classes(j)) + 1;
            class_adj(row, col) = class_adj(row, col) + 1;
        end
    end
end

% Remove rows/columns related to unselected classes
class_adj = class_adj(dictionary + 1, dictionary + 1);

% Normalize and symmetrify
class_adj = (class_adj + tril(class_adj, -1)') / sum(class_adj(:));

end
