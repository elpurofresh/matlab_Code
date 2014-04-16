%
%   SSEQN1.M   State Space System with Constant Coefficients
%
%   Used to evaluate derivative of state at some time point (called by ODE45 or ODE23)
%   Assumes that constant matrices A and B, and the constant (step) input vector 
%   are passed in through the global statement.
%
      function xp = sseqn1(t,x)
      global A B U
      xp = A*x + B*U;
%
%  end of routine
%
