function [J, grad] = costFunction(theta, X, y)
%COSTFUNCTION Compute cost and gradient for logistic regression
%   J = COSTFUNCTION(theta, X, y) computes the cost of using theta as the
%   parameter for logistic regression and the gradient of the cost
%   w.r.t. to the parameters.

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
J = 0;
grad = zeros(size(theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost of a particular choice of theta.
%               You should set J to the cost.
%               Compute the partial derivatives and set grad to the partial
%               derivatives of the cost w.r.t. each parameter in theta
%
% Note: grad should have the same dimensions as theta
%
ones_tmp = ones(size(y));

z = X * theta; % mx3 * 3x1 = mx1
a = -y .* log(sigmoid(z));
b = (ones_tmp - y) .* log(ones_tmp - sigmoid(z) );

J = (1/m) * sum(a - b);


err = sigmoid(z) - y;
% NO NEED for sum() since inner multiplication implicitly does this for us
grad = (1/m) * ( X.' * err ); % 1xm * mx1 = 1x1


% =============================================================

end
