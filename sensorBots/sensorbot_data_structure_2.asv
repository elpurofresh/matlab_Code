% Proposed Matlab SensorBot Data Structure
%
% 9/21/2013
% JeffG
%
% Below is the proposed Matlab data structure, it is a Matlab structure
% array. Each row is a possible connection to the previous node, where row
% 1 (the first row) is presumed to be children connected to the master
% node. The number of columns is the number of children at that row level
% which can be connected to the previous row. A value of null, [], means no
% occupation in that position a value of 'o' means there is an occupation
% by a sensor node at that row and column position.
%
% The Matlab structure array allows other qualities to be attached in a
% physical index architectual manner if desired. Below is a Christmas tree
% typ of structure, the Master only sees one child, Child 0 sees two
% children and child 1 sees three children. Below is a EXAMPLE ONLY, our
% structure array needs to be 6x6, below is an example of 3x4 structure
% array.
row{1} = {[],[],[],'o'};
row{2} = {[],[],'o','o'};
row{3} = {[],'o','o','o'};
netvar = struct('architecture',row);
%
% Below is how you address the 1st row of data in a Matlab Array structure
disp('Output of 1st row of data in a Matlab Array structure');
netvar(1).architecture
% Below is how you address the 1st row of data and 4th column in a Matlab Array structure
disp('Output of the 1st row of data and 4th column in a Matlab Array structure');
netvar(1).architecture{4}
% Below is how how determine a empty value for the 1st row and 1st column
disp('Output of empty comparison for the 1st row and 1st column')
isempty(netvar(1).architecture{1})
% Below prints out 1st value of row{1} column 1
disp('Output of the 1st value of row{1} and column 1');
row{1}{1}
% Below prints out 1st value of row{1} column 4
disp('Output of the 1st value of row{1} and column 4');
row{1}{4}

