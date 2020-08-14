function invind = invindex(cliques, labels, dictionary)
%INVINDEX Inverted index representation for cliques and class labels.
%   Builds an inverted index representation for efficient search of cliques
%   through the presence of given class labels. 
%   invind{i} contains all cliques in which class 'i' appears.
%   See Section II-B of the main paper (reference below).


%% Ground-to-Aerial Viewpoint Localization via Landmark Graphs Matching

%   Authors:    S. Verde, T. Resek, S. Milani, A. Rocha
%   Contacts:   anderson.rocha@ic.unicamp.br

%   Published on IEEE Signal Processing Letters, 2020


%%

% Initialize inverted index
invind = cell(length(dictionary), 1);

% Loop over clique-matrix rows
for k = 1:size(cliques, 1)
    
    % Get list of classes in current clique
    classes_in_clique = unique(labels(logical(cliques(k, :))))';
    
    % Add current clique to the inverted indices of each retrieved class
    for current_class = classes_in_clique
        class_ind = find(dictionary == current_class);
        invind{class_ind} = [invind{class_ind}; k];
    end
end

end
