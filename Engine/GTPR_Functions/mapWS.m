function output = mapWS(GTPRobj, varargin)
% mapWS function of the GTPR class
% Maps the space with random evenly distributed numbers.
% Number of input arguments can be, 1, 3.
% The number of arguments make the program behave differently.
% The number of arguments have to follow the order of the explanation within
% the given number of inputs.
% Number of inputs: 1:
%   - The number of random inputs. These points will be randomly
%     distributed between 0 and 90 degrees.
% Number of inputs: 3:
%   - The number of random inputs.
%   - Starting angle
%   - Stopping angle

% *The nargin contains the length of varagin AND the other input variables
% as well, that's why it is shifted by 1.
switch length(cell2mat(varargin))
    case 1
        % varargin length = 1
        q = 90*rand(cell2mat(varargin), 3);
    
    case 3
        % varargin length = 3
        varargin = cell2mat(varargin);
        q_start = varargin(2);
        q_stop = varargin(3);
        q = rand(varargin(1),3);
        q = (q_stop-q_start)*q;
        q = q_start+q;
   
    otherwise
        error("Incorrect number of arguments in mapWS FUNCTION!")
end

qlength = length(q);

for i = qlength:-1:1
    data(i) = GTPRobj.DirectGeometry(q(qlength+1-i,:));
end

output = data;

end

