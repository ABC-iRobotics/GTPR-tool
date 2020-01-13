classdef GTPR < GTPR_Geometry
    % GTPR Superclass
    %   Holds the following classes for GTPRs:
    %       - GTPR_Geometry
    %       - GTPR_Volume_Functions
    
    properties
        % Class objects:
        GTPR_GeometryObj;
        
        % Variables:
        DiscretizedWorkspacePoints;
    end
    
    methods
        function obj = GTPR(a1, a2, a3, e1, e2, e3, L1, L2, L3, l1, l2, l3, alpha12, alpha13)
            %constructor
            obj = obj@GTPR_Geometry(a1, a2, a3, e1, e2, e3, L1, L2, L3, l1, l2, l3, alpha12, alpha13);
            obj.GTPR_GeometryObj = obj;
            
            
        end
        
        function discretizedWorkspacePoints = mapWorkSpace(obj, varargin)
            % mapWS is a function basically.
            
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
            
            vararginlength = length(varargin);
            vars = zeros(vararginlength,1);
            
            for i = 1:vararginlength
                vars(i) = varargin{i};
            end
            discretizedWorkspacePoints = mapWS(obj, vars);
            obj.DiscretizedWorkspacePoints = discretizedWorkspacePoints;
        end
        
        function output = displayVoxels(obj, varargin)
            % Displays the voxelized workspace
            % If no argument is given then it maps randomly 30000 points
            % between 0 and 90 degrees for the given GTPR (if no
            % mapWorkSpace function ran before).
            
            switch nargin-1 % Cases are shifted by one since the first argument is "obj"
                case 0
                    if isempty(obj.DiscretizedWorkspacePoints)
                        obj.mapWorkSpace(30000);
                    end
                    inData = obj.DiscretizedWorkspacePoints;
                    edgeLength = 10;
                case 1
                    inData = varargin{1};
                    edgeLength = 10; % [mm]
                case 2
                    inData = varargin{1};
                    edgeLength = varargin{2};
                otherwise
                    error('No inputs specified for GTPR.displayVoxels function!');
            end
            
            voxelizedSpace = voxelize(inData, edgeLength);
            
            output = struct('VoxelData', voxelizedSpace.Voxels, 'grid', voxelizedSpace.grid);
           
        end
    end
end

