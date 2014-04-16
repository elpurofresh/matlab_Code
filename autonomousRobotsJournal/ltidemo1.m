%
%   LTIDEMO1.M  MATLAB sample that demonstrates various solution schemes for
%          Linear Time Invariant (LTI) systems.  DEMO1 in this series focuses
%          on time domain solutions.
%  
%   Three solutions schemes are demonstrated:
%     1. Analytical solution using continuous form of matrix exponential
%     2. Discretization of LTI system using matrix exponential with sampling time T
%     3. Numerical integration of the state equations
%
%   Simple RLC electrical circuit with applied voltage
%     Li'' + Ri' + i/C = ea'(t)
%
%   This can be put into standard state space form as follows:
%      d |x1|   |   0      1 ||x1|   |  1/L   |
%      - |  | = |            ||  | + |        |u
%      dt|x2|   |-(1/LC) -R/L||x2|   |-(R/L^2)|
%            
%               |x1|
%      y = [1 0]|  | + [0]u        with y = i(t) and u = ea(t)
%               |x2|
%   and
%      x1 = y   and x2 = x1'-(1/L)u
%
%   This file has been updated to include Matlab 5 conventions.
%
%   File prepared by J. R. White, UMass-Lowell (Feb. 1998)
%   --> minor modifications (Jan. 1999)
%

%
%   getting started
      clear all,   close all,   nfig = 0;
      global A B U
%
%   define coefficients for specific problem
      L = 0.1;                % inductance (henry)
      Ca = 0.001;             % capacitance (farad)
      RR = [100 10 0];        % various resistances (ohms)
      ir = menu('Choose R value in RLC circuit', ...
                'R = 100 ohms (over damped response)', ...
                'R = 10 ohms (under damped response)', ...
                'R = 0 ohms  (undamped response)');
      R = RR(ir);
%
%   create state space model 
      A = [0 1;-1/(L*Ca) -R/L];
      B = [1/L -R/L^2]';     C = [1 0];     D = [0];
%
%   set integration time, time vector, and initial conditions
      to = 0;   tf = 0.25;   nt = 251;   t = linspace(to,tf,nt);   xo = [0 0]';
%
%   set strength of input step function
      us = 10;
%
%
%   Part A  Continuous Analytical Solution 
%
%
%   Note: This solution uses Sylvester's theorem for distint roots to construct
%   the continuous matrix exponential form of the solution.  This will have to be 
%   modified if the roots are repeated. Also the solution here is for the specific
%   case of a step input to a 2nd order LTI system.
%
%   find eigenvalues of state matrix (use roots command for this simple 2x2 case)
      pp = [1 R/L 1/(L*Ca)];    rr = roots(pp);
%
%   determine matrix/vector constants in final equations 
      aibu = inv(A)*B*us;   xxo = xo+aibu;
      AA1 = (A-rr(2)*eye(size(A)))/(rr(1)-rr(2));
      AA2 = (A-rr(1)*eye(size(A)))/(rr(2)-rr(1));
%
%   determine terms with time behavior
      tb1 = exp(rr(1)*t);   tb2 = exp(rr(2)*t);
%
%   construct state vector versus time 
      xa = zeros(2,nt);   xa(:,1) = xo;   
      ya = zeros(1,nt);   ya(:,1) = C*xo + D*us;
      for k = 2:nt
        xa(:,k) = (AA1*tb1(k)+AA2*tb2(k))*xxo - aibu;
        ya(:,k) = C*xa(:,k) + D*us;
      end
%
%   note that this problem only has one input, thus
      xa = xa';   % store final state vector in matrix with jth column being xj(t)
      ya = ya';   % store final output vector in matrix with jth column being yj(t)
%
%
%   Part B  Discrete Solution of LTI System
%
%
%   simulate time domain response
      sys = ss(A,B*us,C,D);    [yb,t,xb] = step(sys,t);   
%
%
%   Part C  Numerical Solution of State Space System
%
%   
%   Note: Since the state matrices are constant for this case, we will use the 
%   global command to pass these constants into the ODE23 function routine.
      U = us;   options = odeset('RelTol',1.0e-6);
      [tn,xc] = ode23('sseqn1',[to,tf],xo,options);
      xct = xc';    ntn = length(tn);   yc = zeros(1,ntn);
      for k = 1:ntn
        yc(:,k) = C*xct(:,k) + D*U;
      end
      yc = yc';   % store final output vector in matrix with jth column being yj(t)
%
%   Plot all three solutions (current in milliamps versus time)
%
      nfig = nfig+1;   figure(nfig)
      subplot(3,1,1),plot(t,1000*ya,'r'),grid
      title(['Fig 3.3  Various Solutions for a Step Input to RLC Circuit (R = ', ...
           num2str(R),' ohms)'])
      range = axis;
      xt = range(1) + 0.55*(range(2)-range(1));
      yt = range(3) + 0.85*(range(4)-range(3)); 
      text(xt,yt,'Continuous Analytical Solution')
      ylabel('ia(t) (ma)')
      subplot(3,1,2),plot(t,1000*yb,'g'),grid
      text(xt,yt,'Discrete Solution for LTI System')
      ylabel('ib(t) (ma)')
      subplot(3,1,3),plot(tn,1000*yc,'b'),grid
      text(xt,yt,'Numerical Solution')
      ylabel('ic(t) (ma)'), xlabel('Time (sec)')

%
%  end of demo
%
