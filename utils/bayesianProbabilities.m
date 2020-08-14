function probs = bayesianProbabilities(query, candidates)
%BAYESIANPROBABILITIES Posterior probabilities for candidate locations.
%   Computes posterior probabilities for candidate locations given the
%   current query. Input parameters are class adjacency matrices for query 
%   and candidates.
%   See Section II-D of the main paper (reference below).


%% Ground-to-Aerial Viewpoint Localization via Landmark Graphs Matching

%   Authors:    S. Verde, T. Resek, S. Milani, A. Rocha
%   Contacts:   anderson.rocha@ic.unicamp.br

%   Published on IEEE Signal Processing Letters, 2020


%%

% Prior probability
pL = 1 / length(candidates);

% Observation likelihoods for all candidates
pZL = zeros(length(candidates), 1);
for k = 1:length(candidates)    
    L = candidates{k};
    num = 0;
    den1 = 0;
    den2 = 0;
    for u = 1:size(query, 1)
        for v = 1:u
            num = num + query(u,v) * L(u,v);
            den1 = den1 + query(u,v)^2;
            den2 = den2 + L(u,v)^2;
        end
    end
    pZL(k) = num / sqrt(den1 * den2);
end

% Posterior probabilities
probs = zeros(length(candidates), 1);
for k = 1:length(candidates) 
    probs(k) = pZL(k) * pL / ...
        (pZL(k) * pL + mean(pZL([1:k - 1, k + 1:end])) * (1 - pL));
end

end
