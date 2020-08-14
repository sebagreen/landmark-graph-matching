function [adj, cliques, locations] = ...
    covgraph(landmarks, img_size, window_size, circular)
%COVGRAPH Covisibility graph of a set of landmark points.
%   Builds the covisibility graph of a set of landmark points (landmark
%   graph). 
%   Requires the list of landmark coordinates, the size of the image to 
%   which those points belong and the covisibility window size.
%   See Section II-A of the main paper (reference below).


%% Ground-to-Aerial Viewpoint Localization via Landmark Graphs Matching

%   Authors:    S. Verde, T. Resek, S. Milani, A. Rocha
%   Contacts:   anderson.rocha@ic.unicamp.br

%   Published on IEEE Signal Processing Letters, 2020


%%

if nargin < 4
    circular = false;
end

% Pre-processing for 360-images
if circular
    
    % Copy left-most landmarks and append to the right
    landmarks_to_repeat = find(landmarks(:, 1) < window_size(2));
    landmarks = [landmarks; ...
        landmarks(landmarks_to_repeat, 1) + img_size(2), ...
        landmarks(landmarks_to_repeat, 2:end)];
    
    % New image size
    img_size(2) = img_size(2) + window_size(2) - 1;
end

% Position vectors (upper-left window's corner)
x_positions = 1:img_size(2) - window_size(2) + 1;
y_positions = 1:img_size(1) - window_size(1) + 1;

% Initialize clique matrix and cursor
cliques = zeros(length(x_positions) * length(y_positions), size(landmarks, 1));
clique_cursor = 1;

% Initialize vector with cliques coordinates (upper-left corner)
locations = zeros(size(cliques, 1), 2);

% Sliding window loop
for y = y_positions
    for x = x_positions
        
        % Find new clique of covisible points
        new_clique = (...
            landmarks(:, 1) >= x & ...
            landmarks(:, 1) <= x + window_size(2) & ...
            landmarks(:, 2) >= y & ...
            landmarks(:, 2) <= y + window_size(1))';
        
        % Append new clique
        cliques(clique_cursor, :) = new_clique;
        locations(clique_cursor, :) = [x y];
        clique_cursor = clique_cursor + 1;
    end
end

% Post-processing for 360-images
if circular
    
    % Merge columns of repeated landmarks
    cliques(:, landmarks_to_repeat) = ...
        cliques(:, landmarks_to_repeat) + ...
        cliques(:, end - length(landmarks_to_repeat) + 1 : end);
    cliques = double(cliques(:, 1 : end - length(landmarks_to_repeat)) > 0);
end

% If no clique retrieved, make all landmarks covisible (one location)
if isempty(cliques)
    cliques = true(1, size(landmarks, 1)); 
    locations = [1 1];
else
    % Remove duplicate and empty cliques
    [cliques, cliques_idx] = unique(cliques, 'rows');
    if sum(cliques(1, :)) == 0
        cliques = cliques(2:end, :);
        cliques_idx = cliques_idx(2:end);
    end
    locations = locations(cliques_idx, :);
end

% Compute adjacency matrix from clique matrix
adj = cliques' * cliques > 0;

end



