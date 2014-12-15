function [J, grad] = cofiCostFunc(params, Y, R, num_users, num_movies, ...
                                  num_features, lambda)
%COFICOSTFUNC Collaborative filtering cost function
%   [J, grad] = COFICOSTFUNC(params, Y, R, num_users, num_movies, ...
%   num_features, lambda) returns the cost and gradient for the
%   collaborative filtering problem.
%

% Unfold the U and W matrices from params
X = reshape(params(1:num_movies*num_features), num_movies, num_features);
Theta = reshape(params(num_movies*num_features+1:end), ...
                num_users, num_features);

            
% You need to return the following values correctly
J = 0;
X_grad = zeros(size(X));
Theta_grad = zeros(size(Theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost function and gradient for collaborative
%               filtering. Concretely, you should first implement the cost
%               function (without regularization) and make sure it is
%               matches our costs. After that, you should implement the 
%               gradient and use the checkCostFunction routine to check
%               that the gradient is correct. Finally, you should implement
%               regularization.
%
% Notes: X - num_movies  x num_features matrix of movie features
%        Theta - num_users  x num_features matrix of user features
%        Y - num_movies x num_users matrix of user ratings of movies
%        R - num_movies x num_users matrix, where R(i, j) = 1 if the 
%            i-th movie was rated by the j-th user
%
% You should set the following variables correctly:
%
%        X_grad - num_movies x num_features matrix, containing the 
%                 partial derivatives w.r.t. to each element of X
%        Theta_grad - num_users x num_features matrix, containing the 
%                     partial derivatives w.r.t. to each element of Theta
%

% To come up with a vectorized implementation, the following tip
% might be helpful: You can use the R matrix to set selected entries to 0.
% For example, R .* M will do an element-wise multiplication between M
% and R; since R only has elements with values either 0 or 1, this has the
% effect of setting the elements of M to 0 only when the corresponding value
% in R is 0. Hence, sum(sum(R.*M)) is the sum of all the elements of M for
% which the corresponding element in R equals 1.

h = X * Theta';
error = R.*(h - Y);
J = 0.5 * sum(sum(error.^2));

%  The X gradient is the product of the error factor and the Theta matrix. 
%         Dimensions are (movies x features)
%  The Theta gradient is the product of the error factor and the X matrix. A transposition may be needed. 
%         Dimensions are (users x features)
X_grad = (R .* ((X * Theta') - Y )) * Theta;
Theta_grad = (R .* ((X * Theta') - Y ))' * X;

% for i = 1:length(X_grad)
%    idx = find(R(i,:) == 1);
%    Theta_tmp = Theta(idx,:);
%    Y_tmp = Y(i, idx);
%    
%    X_grad(i,:) = ( (X(i,:)*Theta_tmp') - Y_tmp) * Theta_tmp;
% end
% 
% 

% Regularized Cost
theta_reg = (lambda / 2) * sum(sum(Theta.^2));
x_reg = (lambda / 2) * sum(sum(X.^2));

J = J + theta_reg + x_reg; 


% Regularized Gradient
X_grad = X_grad + lambda * X;
Theta_grad = Theta_grad + lambda * Theta;







% =============================================================

grad = [X_grad(:); Theta_grad(:)];

end
