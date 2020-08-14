function wsize = autoWindowSize(points)
%AUTOWINDOWSIZE Automatic calculation of covisibility window size.


%% Ground-to-Aerial Viewpoint Localization via Landmark Graphs Matching

%   Authors:    S. Verde, T. Resek, S. Milani, A. Rocha
%   Contacts:   anderson.rocha@ic.unicamp.br

%   Published on IEEE Signal Processing Letters, 2020


%%

min_distances = Inf * ones(length(points), 1);

for i = 1:length(points)
    for j = 1:length(points)
        if i ~= j 
            dist_ij = norm(points(i, :) - points(j, :));
            if dist_ij < min_distances(i)
                min_distances(i) = dist_ij;
            end
        end
    end
end

wsize = round(mean(min_distances) + 5 * std(min_distances));
            
end
