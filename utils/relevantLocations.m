function relevant_cliques = relevantLocations(inv_ind_aer, inv_ind_grd)
%RELEVANTCLIQUES Select subset of relevant cliques.
%   Selects a subset of relevant cliques using the inverted index
%   representations of aerial and ground cliques.
%   See Section II-B of the main paper (reference below).


%% Ground-to-Aerial Viewpoint Localization via Landmark Graphs Matching

%   Authors:    S. Verde, T. Resek, S. Milani, A. Rocha
%   Contacts:   anderson.rocha@ic.unicamp.br

%   Published on IEEE Signal Processing Letters, 2020


%%

% Find all classes visible in ground image
classes_in_grd = find(~cellfun(@isempty, inv_ind_grd))';

% Initialize relevant cliques
relevant_cliques = inv_ind_aer{classes_in_grd(1)};

% Intersection of cliques containing the classes in ground image
for n = 2:length(classes_in_grd)
    relevant_cliques = intersect(...
        relevant_cliques, inv_ind_aer{classes_in_grd(n)});
end

end
