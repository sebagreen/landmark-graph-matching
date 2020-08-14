function numeric_classes = cat2num(classes, dictionary_labels)
%CAT2NUM Convert categorical class labels to numerical.
%   Converts categorical labels in 'classes' array to numerical labels,
%   using the ordering specified in 'dictionary_labels'.


%% Ground-to-Aerial Viewpoint Localization via Landmark Graphs Matching

%   Authors:    S. Verde, T. Resek, S. Milani, A. Rocha
%   Contacts:   anderson.rocha@ic.unicamp.br

%   Published on IEEE Signal Processing Letters, 2020


%%

dictionary_labels = categorical(dictionary_labels);

numeric_classes = zeros(size(classes));

for i = 1:length(classes)
    
    numeric_classes(i) = find(dictionary_labels == classes(i)) - 1;

end

end
