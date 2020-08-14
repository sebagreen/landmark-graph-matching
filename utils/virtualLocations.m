function virtual_locations = virtualLocations(relevant_cliques, cliques, covpar)
%VIRTUALLOCATIONS Virtual locations from relevant cliques.
%   Extends relevant cliques to form virtual locations according to the
%   covisibility parameter 'covpar'.
%   See Section II-B of the main paper (reference below).


%% Ground-to-Aerial Viewpoint Localization via Landmark Graphs Matching

%   Authors:    S. Verde, T. Resek, S. Milani, A. Rocha
%   Contacts:   anderson.rocha@ic.unicamp.br

%   Published on IEEE Signal Processing Letters, 2020


%%

% Default covisibility parameter
if nargin < 3
    covpar = 0.5;
end

% Initialize virtual locations
virtual_locations = cell(length(relevant_cliques), 1);

% Loop over relevant cliques
for n = 1:length(relevant_cliques)
    
    % Current clique index
    k = relevant_cliques(n);
    
    % Initialize current virtual location
    expanded_clique = cliques(k, :);
    
    % Look for cliques sharing enough covisible points
    for p = 1:size(cliques, 1)
        if p ~= k && ...
                sum(cliques(p, :) & cliques(k, :)) / sum(cliques(k, :)) >= covpar
            expanded_clique = [expanded_clique; cliques(p, :)];  %#ok<AGROW>
        end
    end
    
    % Convert expanded clique to adjacency matrix
    virtual_locations{n} = sparse(expanded_clique' * expanded_clique > 0); 
    
end

end
