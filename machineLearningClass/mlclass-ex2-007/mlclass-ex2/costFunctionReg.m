function [J, grad] = costFunctionReg(theta, X, y, lambda)
%COSTFUNCTIONREG Compute cost and gradient for logistic regression with regularization
%   J = COSTFUNCTIONREG(theta, X, y, lambda) computes the cost of using
%   theta as the parameter for regularized logistic regression and the
%   gradient of the cost w.r.t. to the parameters. 

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

%ones_tmp = ones(size(y));

% z = zeros(size(X * theta));
% z = X * theta; % mx28 * 28x1 = mx1
% 
% z_0 = z(1); % Don't regularize for theta(1) equivalent to theta_0
% z_rest = z(2:end);
% 
% a = zeros( size(y .* log(sigmoid(z)) ));
% a_0 = -y(1) .* log(sigmoid(z(1)));
% a_rest = -y(2:end) .* log(sigmoid(z(2:end)));
% 
% 
% b = size( (ones(size(y)) - y) .* log(ones(size(y)) - sigmoid(z) ) );
% b_0 = (1 - y(1)) .* log(1 - sigmoid(z(1)) );
% b_rest = (ones(size(y(2:end))) - y(2:end)) .* log(ones(size(y(2:end))) - sigmoid(z(2:end)) );
% 
% J_0 = (1/m) * sum(a_0 - b_0);
% J_rest = (1/m) * sum(a_rest - b_rest) + ( (lambda * (2*m)) * sum(theta(2:end).^2) );
% J = J_0 + J_rest;
ones_tmp = ones(size(y));

z = X * theta; % mx3 * 3x1 = mx1
a = -y .* log(sigmoid(z));
b = (ones_tmp - y) .* log(ones_tmp - sigmoid(z) );

J = ((1/m) * sum(a - b)) + ( (lambda /(2*m)) * sum(theta(2:end).^2) );


% err_0 = sigmoid(z_0) - y(1);
% grad_0 = (1/m) * ( X(1) * err_0 ); % 1xm * mx1 = 1x1
% 
% err_rest = sigmoid(z_rest) - y(2:end);
% grad_rest = ((1/m) * ( X(2:end, :).'* err_rest )) + ( (lambda/m ) * sum(theta(2:end)) ); % 1xm * mx1 = 1x1
% grad = grad_0 + [0 ; grad_rest];

err = sigmoid(z) - y;
% NO NEED for sum() since inner multiplication implicitly does this for us
%grad_rest = ((1/m) * ( X(2:end, :).' * err(2:end) )) +( (lambda/m ) * sum(theta(2:end)) );
%grad_rest = ((1/m) * ( X(:, 2:end).' * err )) +( (lambda/m ) * sum(theta(2:end)) );
%grad_rest = ((1/m) * ( X.' * err )) +( (lambda/m ) * sum(theta(2:end)) );

grad_rest = ( (lambda/m ) * theta(2:end) );
grad = (1/m) * ( X.' * err ); 
grad = grad + [0 ; grad_rest];


% =============================================================

end
