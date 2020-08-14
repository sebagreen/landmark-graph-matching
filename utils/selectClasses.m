function [new_landmarks, new_classes] = selectClasses(landmarks, classes, dictionary)
%SELECTCLASSES Select subset of classes.
%   Retains the subset of classes in 'landmarks' given by 'dictionary'.


%% Ground-to-Aerial Viewpoint Localization via Landmark Graphs Matching

%   Authors:    S. Verde, T. Resek, S. Milani, A. Rocha
%   Contacts:   anderson.rocha@ic.unicamp.br

%   Published on IEEE Signal Processing Letters, 2020


%%

indices_to_keep = ismember(classes, dictionary);
new_landmarks = landmarks(indices_to_keep, :);
new_classes = classes(indices_to_keep);

end
