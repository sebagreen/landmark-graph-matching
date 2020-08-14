%% Ground-to-Aerial Viewpoint Localization via Landmark Graphs Matching

%   Authors:    S. Verde, T. Resek, S. Milani, A. Rocha
%   Contacts:   anderson.rocha@ic.unicamp.br

%   Published on IEEE Signal Processing Letters, 2020


clear 
close all
addpath('utils')


%% Set-up

% Select example image from dataset
%   Urban dense:    0000105, 0000170, 0000194, 0001263, 0003004
%   Urban sparse:   0001223, 0001239, 0001253, 0011341, 0011351
%   Non-urban:      0000107, 0000195, 0001216, 0010000, 0011361 
image_name = '0003004'; 

% Class dictionary: 0=Building, 1=Pavement, 2=Road, 3=Tree
%   (any proper subset is valid, e.g. [0 2 3] or [0 3])
dictionary = [0 1 2 3];

% Number of top-K results to visualize
numTopK = 3;

% Use 360-degree adjacency for ground images
cov360 = true;


%% Load and format data

% Dataset directories
dir_aerials = './aerial';
dir_grounds = './ground';

% Dictionary labels
dictionary_labels = ["Building", "Pavement", "Road", "Tree"];

% Images
aerial.Image = imread(fullfile(dir_aerials, [image_name '.jpg']));
ground.Image = imread(fullfile(dir_grounds, [image_name '.jpg']));

% Landmarks
aerial.Landmarks = readmatrix(fullfile(...
    dir_aerials, [image_name '.txt']), 'Range', 'A:B');
ground.Landmarks = readmatrix(fullfile(...
    dir_grounds, [image_name '.txt']), 'Range', 'A:B');

% Classes
aerial.Classes = cat2num(categorical(readmatrix(fullfile(...
    dir_aerials, [image_name '.txt']), 'Range', 'C:C', 'OutputType', 'string')), dictionary_labels);
ground.Classes = cat2num(categorical(readmatrix(fullfile(...
    dir_grounds, [image_name '.txt']), 'Range', 'C:C', 'OutputType', 'string')), dictionary_labels);

% Pick a subset of classes according to 'dictionary'
[aerial.Landmarks, aerial.Classes] = selectClasses(aerial.Landmarks, aerial.Classes, dictionary); 
[ground.Landmarks, ground.Classes] = selectClasses(ground.Landmarks, ground.Classes, dictionary); 

% Viewpoint
aerial.Viewpoint = [375 375];


%% Set covisibility windows

% Automatic window size for aerial images
covwind = autoWindowSize(aerial.Landmarks);
aerial.CovWind = [covwind covwind]; clear covwind

% Fixed window size for ground images
ground.CovWind = [size(ground.Image, 1) size(ground.Image, 1)];


%% Covisibility graphs

% Aerial covisibility graph
[aerial.Adj, aerial.Cliques, aerial.Locations] = covgraph(...
    aerial.Landmarks, size(aerial.Image), aerial.CovWind);

% Ground covisibility graph
[ground.Adj, ground.Cliques, ground.Locations] = covgraph(...
    ground.Landmarks, size(ground.Image), ground.CovWind, cov360);


%% Inverted indices

% Aerial inverted index
aerial.InvertedIndex = invindex(...
    aerial.Cliques, aerial.Classes, dictionary);

% Ground inverted index
ground.InvertedIndex = invindex(...
    ground.Cliques, ground.Classes, dictionary);


%% Candidate locations

% Relevant locations (cliques containing all classes visible in ground image)
aerial.RelevantLocations = relevantLocations(...
    aerial.InvertedIndex, ground.InvertedIndex);

% Virtual locations (expanded relevant clique)
aerial.VirtualLocations = virtualLocations(...
    aerial.RelevantLocations, aerial.Cliques, 0.5);


%% Class-adjacency graphs

% Class-adjacency matrix for query ground image
ground.ClassAdj = classAdjacencyMatrix(...
    ground.Adj, ground.Classes, dictionary);

% Class-adjacency matrix for candidate aerial locations
aerial.ClassAdjs = cell(size(aerial.VirtualLocations));
for v = 1:length(aerial.VirtualLocations)
    aerial.ClassAdjs{v} = classAdjacencyMatrix(...
        full(aerial.VirtualLocations{v}), aerial.Classes, dictionary);
end, clear v


%% Bayesian probabilities

% Location probabilities
probabilities = bayesianProbabilities(ground.ClassAdj, aerial.ClassAdjs);

% Get first-K results
[~, firstK] = maxk(probabilities, numTopK);


%% Show results

% Aerial image with viewpoint
aerial.FigureViewpoint = figure;
imshow(aerial.Image), hold on
viscircles(aerial.Viewpoint, 50, 'Color', 'yellow', 'LineWidth', 5)
title('Aerial image and ground-truth viewpoint')

% Aerial image and overlay graph
aerial.FigureGraph = figure;
imshow(aerial.Image), hold on 
graphoverlay(graph(aerial.Adj, 'omitselfloops'), aerial.Landmarks, ...
    aerial.Classes, dictionary, dictionary_labels)
title('Aerial image with overlayed landmark graph')

% Ground image and overlay graph
ground.FigureGraph = figure;
imshow(ground.Image), hold on
graphoverlay(graph(ground.Adj, 'omitselfloops'), ground.Landmarks, ...
    ground.Classes, dictionary, dictionary_labels)
title('Ground image with overlayed landmark graph')

% Relevant cliques
aerial.FigureLocations = figure;
imshow(aerial.Image), hold on
title('Viewpoint localization (top-K results)')
for r = aerial.RelevantLocations'
    rectangle('Position', ...
        [aerial.Locations(r, :), aerial.CovWind], ...
        'EdgeColor', [1 .6 0 .75], 'LineWidth', 1);
end, clear r

% First-K locations
for k = firstK'
    rectangle('Position', ...
        [aerial.Locations(aerial.RelevantLocations(k), :) aerial.CovWind], ...
        'EdgeColor', 'green', 'LineWidth', 5)
end, clear k
