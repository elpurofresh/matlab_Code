function idx = findClosestCentroids(X, centroids)
%FINDCLOSESTCENTROIDS computes the centroid memberships for every example
%   idx = FINDCLOSESTCENTROIDS (X, centroids) returns the closest centroids
%   in idx for a dataset X where each row is a single example. idx = m x 1 
%   vector of centroid assignments (i.e. each entry in range [1..K])
%

% Set K
K = size(centroids, 1);

% You need to return the following variables correctly.
idx = zeros(size(X,1), 1);

% ====================== YOUR CODE HERE ======================
% Instructions: Go over every example, find its closest centroid, and store
%               the index inside idx at the appropriate location.
%               Concretely, idx(i) should contain the index of the centroid
%               closest to example i. Hence, it should be a value in the 
%               range 1..K
%
% Note: You can use a for-loop over the examples to compute this.
%
% current = 100;
% min_val = 100;
% m = size(X,1);
% 
% for i = 1:m
%     for j = 1:K
%         %current = abs(X(i,:) - centroids(j,:));
%         current = centroids(j,:)*X(i,:)';
%         if current < min_val
%             idx(i) = j;
%             min_val = current;
%         end
%     end
% end

%Taken from
%http://statinfer.wordpress.com/2011/11/14/efficient-matlab-i-pairwise-distances/
% function D = sqDistance(X, Y)
% D = bsxfun(@plus,dot(X,X,1)',dot(Y,Y,1))-2*(X'*Y);
% but in this case we have to modify the transpose and dim inside bsxfun
% to become as follows.
Y = centroids;

% We denote x_i as a vector in X and y_j as a vector in Y. The square of distance d_{ij} between x_i and y_j is
% d_{ij}^2 = \|x_i-y_j\|^2=\|x_i\|^2+\|y_j\|^2-2<x_i,y_j>,
% where <\cdot,\cdot> is dot product. d_{ij}^2 can be considered as an entry of matrix D. Therefore, we can write the formula in matrix form as:
% D = \bar x1'+1\bar y'-2X'Y
% where, \bar x is column vector of squared norms of all vectors in X.
D = bsxfun(@plus,dot(X,X,2),dot(Y,Y,2)')-2*(X*Y');

% D is a m x K matrix with the squared euclidean distance from each example 
% to each centroid
% Then we look for the minimum among those three distances and store the
% index inside of the idx
[min_val, idx] = min(D, [], 2);






% =============================================================

end

