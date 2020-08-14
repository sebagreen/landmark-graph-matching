function graphoverlay(graph, landmarks, classes, dictionary, verb_dict)
%GRAPHOVERLAY Overlay landmark graph to source image.


%% Ground-to-Aerial Viewpoint Localization via Landmark Graphs Matching

%   Authors:    S. Verde, T. Resek, S. Milani, A. Rocha
%   Contacts:   anderson.rocha@ic.unicamp.br

%   Published on IEEE Signal Processing Letters, 2020


%%

% Flag for showing edges on the overlay
PLOT_EDGES = true;

% Get edges list from graph object
edges = graph.Edges{:, 'EndNodes'};

% Plot edges
if PLOT_EDGES
    for n = 1:size(edges, 1)
        plot(...
            [landmarks(edges(n, 1), 1); landmarks(edges(n, 2), 1)], ...
            [landmarks(edges(n, 1), 2); landmarks(edges(n, 2), 2)], ...
            'Color', [1 1 1 .25])
    end
end

present_classes = find(logical(sum(dictionary == unique(classes))));

% Define color-legend (select color subset according to classes' presence)
colors = lines(length(dictionary));
colors = colors(present_classes, :);

% Plot vertices
scats = zeros(length(present_classes), 1);
for c = 1:length(present_classes)
    ids = (classes == dictionary(present_classes(c)));
    scats(c) = scatter(landmarks(ids, 1), landmarks(ids, 2), 120, 'd', ...
        'MarkerFaceColor', colors(c, :), 'MarkerEdgeColor', [1 1 1], ...
        'MarkerEdgeAlpha', 0.5);
end
legend(scats, verb_dict(dictionary(present_classes) + 1), 'Location', 'southeast', 'NumColumns', length(present_classes))

end
