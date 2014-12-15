function g = sigmoid(z)
%SIGMOID Compute sigmoid functoon
%   J = SIGMOID(z) computes the sigmoid of z.

% You need to return the following variables correctly 
g = zeros(size(z));
%fprintf('\nSize of g is: \n');
%size(g)
% ====================== YOUR CODE HERE ======================
% Instructions: Compute the sigmoid of each value of z (z can be a matrix,
%               vector or scalar).

ones_var = ones(size(z));

g = ones_var ./ (ones_var + exp(z.*-1) );


% =============================================================

end
