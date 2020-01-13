classdef GTPR_Geometry < handle
    %Generalized Triangle Parallel Robot Kinematics based on the works of
    %Somló János. This class discusses the kinematics of the system:
    % Forward Kinematics: (q1, q2, q3) -> (X, Y, Z)
    % Inverse Kinematics: (X, Y, Z) -> (q1, q2, q3)
    % Not all robots are physically feasible which calculations are
    % performed here.
    % Basic considerations:
    % - When arms are parallel to the XY plane it is considered to be 0
    %   degrees on the joints, and when the upper arms are going downwards
    %   the degrees values are positive, when going upwards (toward Z) it
    %   is considered to be negative.
    % - Z axis is looking up, so the Tool Center Point (TCP) can only have
    %   negative values for Z
    % - The base triangles rotational points intersection on the base
    %   triangle is considered to be the origin of the coordinate system.
    % - Base triangles Z coordinates are 0
    %
    %
    % Robot parameters:
    % - i -> 1,2,3 the arms of the robot (3 is considered only)
    % - ai -> Base triangle radius from the origin to the rotational joint
    %         of i [Unit: mm]
    % - ei -> Work triangle radius from the TCP to the rotational joint of
    %         i [Unit: mm]
    % - Li -> Upper arms length [Unit: mm]
    % - li -> Lower arms length [Unit: mm]
    % - alpha12; alpha13 -> the angle between the respective arms 1 and 2,
    %                       1 and 3 respectively [Unit: rad]
    % - TCP -> Work triangles center location in space TCP = [X, Y, Z]
    %          [Unit: mm]
    % - qi -> upper arms angle closed with the XY plane (actuator
    %         rotational joint angle) [Unit: rad]

    %%
    %######################################################################
    %----------------------------------------------------------------------
    %######################################################################
    %----------------------------------------------------------------------
    %######################################################################
    %%

    % Public properties
    properties
        % Base Triangle parameters:
        a1 = [];
        a2 = [];
        a3 = [];

        % Work Triangle parameters:
        e1 = [];
        e2 = [];
        e3 = [];

        % Upper arm length:
        L1 = [];
        L2 = [];
        L3 = [];

        % Lower arm length:
        l1 = [];
        l2 = [];
        l3 = [];

        % Angles between the arms:
        alpha12 = [];
        alpha13 = [];

    end 
    
    %%
    %######################################################################
    %----------------------------------------------------------------------
    %######################################################################
    %----------------------------------------------------------------------
    %######################################################################
    %%

    % Private properties:
    properties (SetAccess = private, Hidden = true)

        % Base triangle points:
        A = [];
        B = [];
        C = [];

    end

    %%
    %######################################################################
    %----------------------------------------------------------------------
    %######################################################################
    %----------------------------------------------------------------------
    %######################################################################
    %%

    % Public methods:
    methods
        %##################################################################
        % CONSTRUCTOR
        %##################################################################
        
        
        function obj = GTPR_Geometry(a1, a2, a3, e1, e2, e3, L1, L2, L3, l1, l2, l3, alpha12, alpha13)
            obj.a1 = a1;
            obj.a2 = a2;
            obj.a3 = a3;

            obj.e1 = e1;
            obj.e2 = e2;
            obj.e3 = e3;

            obj.L1 = L1;
            obj.L2 = L2;
            obj.L3 = L3;

            obj.l1 = l1;
            obj.l2 = l2;
            obj.l3 = l3;

            obj.alpha12 = alpha12;
            obj.alpha13 = alpha13;
            
            % Base triangle points:
			obj.A = rotz(0) * [0 -a1 0]';
			obj.B = rotz(alpha12) * [0 -a2 0]';
			obj.C = rotz(alpha13) * [0 -a3 0]';
        end
        
        %##################################################################
        % INVERSE GEOMETRY
        %##################################################################
        function [q1, q2, q3] = InverseGeometry(~, X, Y, Z)
            % Calculates the inverse kinematics of the GTPR
            q1 = X;
            q2 = Y;
            q3 = Z;
            
			% EMPTY!!!

        end



        %##################################################################
        % DIRECT GEOMETRY
        %##################################################################
        function characteristicPoints = DirectGeometry(obj, q, varargin)
            % Calculates the direct kinematics of the GTPR
			% Input q should be a 1*3 or 3*1 vector
			% varargin input can be 'simple', which will result in the pure
			% TCP coordinates, or can be left blank, which will output the
			% characteristic points as well
			
			q1 = q(1);
			q2 = q(2);
			q3 = q(3);

			% Upper arm end points:
			D = obj.A + rotz(0) * rotx(q1) * [0 -obj.L1 0]';
			E = obj.B + rotz(obj.alpha12) * rotx(q2) * [0 -obj.L2 0]';
			F = obj.C + rotz(obj.alpha13) * rotx(q3) * [0 -obj.L3 0]';

			% Virtual end points:
			Dv = D + rotz(0) * [0 obj.e1 0]';
			Ev = E + rotz(obj.alpha12) * [0 obj.e2 0]';
			Fv = F + rotz(obj.alpha13) * [0 obj.e3 0]';

			% TCP = L:

			% Using the three spheres intersection algorithm to find the proper TCP:
			[~, TCP] = threeSpheresIntersection(Dv,Ev,Fv,obj.l1,obj.l2,obj.l3);
            
			if nargin > 2			
				if strcmp(varargin{1}, 'simple')
					characteristicPoints = TCP;
					return;
				end
				
			else
			%%
			% Other not "useful" points:
			
			G = TCP + rotz(0) * [0 -obj.e1 0]';
			H = TCP + rotz(obj.alpha12) * [0 -obj.e2 0]';
			I = TCP + rotz(obj.alpha13) * [0 -obj.e3 0]';
			
            if ~isreal(TCP)
                characteristicPoints = struct('q', q,...
                                              'A', [],...
                                              'B', [],...
                                              'C', [],...
                                              'D', [],...
                                              'E', [],...
                                              'F', [],...
                                             'Dv', [],...
                                             'Ev', [],...
                                             'Fv', [],...
                                              'G', [],...
                                              'H', [],...
                                              'I', [],...
                                              'TCP', []);    
            else
                characteristicPoints = struct('q', q,...
                                              'A', obj.A,...
                                              'B', obj.B,...
                                              'C', obj.C,...
                                              'D', D,...
                                              'E', E,...
                                              'F', F,...
                                             'Dv', Dv,...
                                             'Ev', Ev,...
                                             'Fv', Fv,...
                                              'G', G,...
                                              'H', H,...
                                              'I', I,...
                                              'TCP', TCP);
            end
%             if ~isreal(TCP)
%                 characteristicPoints = struct('complex', characteristicPoints);
%             end
			
			end
        end
        
    %%
    %######################################################################
    %----------------------------------------------------------------------
    %######################################################################
    %----------------------------------------------------------------------
    %######################################################################
    %%
    end
    
    % Private methods:
    methods (Hidden = true)
        %##################################################################
        % INVERSE KINEMATICS HELPER FUNCTIONS
        %##################################################################
        
        
        %##################################################################
        
        function theta = calcAngleYZ(~, x0, y0, z0, rf, re, R, e)
        % From: http://forums.trossenrobotics.com/tutorials/introduction-129/delta-robot-kinematics-3276/
        % For explanation see sample code
        % rf -> upper arm length
        % re -> lower arm length
        % R -> base triangle radius
        % e -> work triangle radius
        
            y1 = -R;
            y0 = y0-e;
            a = (x0*x0 + y0*y0 + z0*z0 +rf*rf - re*re - y1*y1)/(2*z0);
            b = (y1-y0)/z0;
            % // discriminant
            d = -(a+b*y1)*(a+b*y1)+rf*(b*b*rf+rf); 
            yj = (y1 - a*b - sqrt(d))/(b*b + 1); %// choosing outer point
            zj = a + b*yj;
            theta = atan(-zj/(y1 - yj));
            if yj > y1
                theta = theta + pi;
            end
        
        end
        
        %##################################################################
        % DIRECT KINEMATICS HELPER FUNCTIONS
        %##################################################################
        
        
		%##################################################################
        % HELPER FUNCTIONS
        %##################################################################
		
        function RobotData = exportRobotData(obj, saveTF_, savename_)
        % Exports robot data to a .mat file
        % Can specify if you wish to export the robot data, or only create
        % a structure for it. In both cases a savename_ is needed.
            
            data_BaseTriangle   =   struct( 'a1', obj.a1, 'a2', obj.a2, ...
                                            'a3', obj.a3);
                                        
            data_WorkTriangle   =   struct( 'e1', obj.e1, 'e2', obj.e2, ...
                                            'e3', obj.e3);
                                        
            data_UpperArm       =   struct( 'L1', obj.L1, 'L2', obj.L2, ...
                                            'L3', obj.L3);
            
            data_LowerArm       =   struct( 'l1', obj.l1, 'l2', obj.l2, ...
                                            'l3', obj.l3);
            
            data_Angles         =   struct( 'alpha12', obj.alpha12, ...
                                            'alpha13', obj.alpha13);
                     
                                      
            RobotData = struct( 'BaseTriangle', data_BaseTriangle, ...
                                'WorkTriangle', data_WorkTriangle, ...
                                'UpperArm'    , data_UpperArm, ...
                                'LowerArm'    , data_LowerArm, ...
                                'AlphaAngles' , data_Angles);
        
            RobotData = struct('GTPR_Data', RobotData);
            
            if saveTF_ == 1
                save(savename_, '-struct', 'RobotData'); 
            end
        
        end
    end
end