clear ; close all; clc
input_layer_size  = 400;  % 20x20 Input Images of Digits
hidden_layer_size = 25;   % 25 hidden units
num_labels = 10;  

load('ex4data1.mat');
load('ex4weights.mat');
nn_params = [Theta1(:) ; Theta2(:)];
lambda = 1;

Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

m = size(X, 1);

J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

a1 = [ones(m, 1) X];

z2 = a1 * Theta1.';
a2 = sigmoid(z2);

a2 = [ones(m, 1) a2];
z3 = a2 * Theta2.';

a3 = sigmoid(z3);

y_matrix = eye(num_labels);


part1 = log(a3) .* y_matrix(y,:);
part2 = log(1 - a3) .* (1 - y_matrix(y,:));
J = (-1/m) * sum(sum(part1 + part2));

cost1 = sum(sum(Theta1(:, 2:end).^2));
cost2 = sum(sum(Theta2(:, 2:end).^2));

cost3 = (lambda / (2*m) ) * (cost1 + cost2);

J = J + cost3;

smallDelta3 = a3 - y_matrix(y,:);
smallDelta2 = smallDelta3 * Theta2(:, 2:end) .* sigmoidGradient(z2);

capDelta2 = smallDelta3.' * a2;
capDelta1 = smallDelta2.' * a1;

Theta1_grad = (1/m) * capDelta1;
Theta2_grad = (1/m) * capDelta2;

Theta1_grad_reg = (lambda / m) * Theta1(:, 2:end);
Theta2_grad_reg = (lambda / m) * Theta2(:, 2:end);

%Find the size of the rows of Theta1_grad_reg and Theta2_grad_reg]
%They are NOT the same size
[rows1, cols]=size(Theta1_grad_reg);
[rows2, cols]=size(Theta2_grad_reg);

Theta1_grad_reg = [zeros(rows1,1) Theta1_grad_reg];
Theta2_grad_reg = [zeros(rows2,1) Theta2_grad_reg];

Theta1_grad = Theta1_grad + Theta1_grad_reg;
Theta2_grad = Theta2_grad + Theta2_grad_reg;

