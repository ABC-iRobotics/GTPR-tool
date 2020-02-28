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

        % Variables:
        characteristicPoints
        
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
        function dataOut = InverseGeometry(obj, TCP, varargin)
            % Calculates the inverse kinematics of the GTPR
            % Input can be given in either 3 arguments (x,y,z) or as one
            % array containing the coordinates.
            
            % Inverse kinematics starts from here.
            % Calculate the work triangle edge locations:
                % 1st:
            G = TCP - [0 obj.e1 0]';
            % Use the 2 circle intersection algorithm:
            l1p = sqrt(power(obj.l1,2) - power(G(1),2));
            [Dy, Dz] = circcirc(obj.A(2), obj.A(3), obj.L1, G(2), G(3), l1p);
            
                % 2nd:
            % Since coordinates are rotated here, it will be as if it was 
            % aligned with the zy plane
            H = TCP - rotz(obj.alpha12)*[0 obj.e2 0]';
            Hp = rotz(obj.alpha12)'*H;
            Bp = rotz(obj.alpha12)'*obj.B;
            l2p = sqrt(power(obj.l2,2) - power(Hp(1),2));
            [Epy, Epz] = circcirc(Bp(2), Bp(3), obj.L2, Hp(2), Hp(3), l2p);
            
                % 3rd:
            % Since coordinates are rotated here, it will be as if it was 
            % aligned with the zy plane
            I = TCP - rotz(obj.alpha13)*[0 obj.e3 0]';
            Ip = rotz(obj.alpha13)'*I; % Should be around -8 for x
            Cp = rotz(obj.alpha13)'*obj.C;
            l3p = sqrt(power(obj.l3,2) - power(Ip(1),2));
            [Fpy, Fpz] = circcirc(Cp(2), Cp(3), obj.L3, Ip(2), Ip(3), l3p);
            
            % Calculate the corresponding joint angles:
            
            
            
            q1 = atan2d(Dz, Dy-obj.A(2));
            q2 = atan2d(Epz, Epy-Bp(2));
            q3 = atan2d(Fpz, Fpy-Cp(2));
            
            if Dz(2) > obj.A(3) 
                q1 = -180+q1;
            else
                q1 = 180+q1;
            end
            
            if Epz(2) > obj.B(3)
                q2 = -180+q2;
            else
                q2 = 180+q2;
            end
            
            if Fpz(2) > obj.C(3)
                q3 = -180+q3;
            else
                q3 = 180+q3;
            end
            
            if strcmp(varargin, 'simple')
				dataOut = [q1 q2 q3];
				return;
				
            else
                
                D1 = rotz(0)*[0 Dy(1) Dz(1)]';
                E1 = rotz(obj.alpha12)*[0 Epy(1) Epz(1)]';
                F1 = rotz(obj.alpha13)*[0 Fpy(1) Fpz(1)]';
                
                D2 = rotz(0)*[0 Dy(2) Dz(2)]';
                E2 = rotz(obj.alpha12)*[0 Epy(2) Epz(2)]';
                F2 = rotz(obj.alpha13)*[0 Fpy(2) Fpz(2)]';
                
                %%
                
                dataOut = struct('TCP', TCP,...
                                              'q', [q1 q2 q3],...
                                              'A', obj.A,...
                                              'B', obj.B,...
                                              'C', obj.C,...
                                              'D1', D1,...
                                              'E1', E1,...
                                              'F1', F1,...
                                              'D2', D2,...
                                              'E2', E2,...
                                              'F2', F2,...
                                              'G', G,...
                                              'H', H,...
                                              'I', I);
            end
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
            
				
			if strcmp(varargin, 'simple')
				characteristicPoints = TCP;
				return;
							
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
            
            obj.characteristicPoints = characteristicPoints;
%             if ~isreal(TCP)
%                 characteristicPoints = struct('complex', characteristicPoints);
%             end
			
			end
        end
        
        
    %%  
    %######################################################################
    %           OTHER FUNCTIONS
    %######################################################################
    %%    
        function plotRobot(obj, charPointsFull)
            
            hold on;
            plot3(0,0,0, 'k*');
            
            D = charPointsFull.D;
            E = charPointsFull.E;
            F = charPointsFull.F;
            
            G = charPointsFull.G;
            H = charPointsFull.H;
            I = charPointsFull.I;
            
            TCP = charPointsFull.TCP;
            
            %Base triangle:
            plot3(obj.A(1), obj.A(2), obj.A(3), 'r*');
            plot3(obj.B(1), obj.B(2), obj.B(3), 'b*');
            plot3(obj.C(1), obj.C(2), obj.C(3), 'g*');

            plot3([0 obj.A(1)], [0 obj.A(2)], [0 obj.A(3)], 'k--')
            plot3([0 obj.B(1)], [0 obj.B(2)], [0 obj.B(3)], 'k--')
            plot3([0 obj.C(1)], [0 obj.C(2)], [0 obj.C(3)], 'k--')

            % Upper arm:
            plot3(D(1), D(2), D(3), 'r.');
            plot3(E(1), E(2), E(3), 'b.');
            plot3(F(1), F(2), F(3), 'g.');

            plot3([obj.A(1) D(1)], [obj.A(2) D(2)], [obj.A(3) D(3)], 'r');
            plot3([obj.B(1) E(1)], [obj.B(2) E(2)], [obj.B(3) E(3)], 'b');
            plot3([obj.C(1) F(1)], [obj.C(2) F(2)], [obj.C(3) F(3)], 'g');

            % Virtual point:
%             plot3(Dv(1), Dv(2), Dv(3), 'rs');
%             plot3(Ev(1), Ev(2), Ev(3), 'bs');
%             plot3(Fv(1), Fv(2), Fv(3), 'gs');

%             plot3([D(1) Dv(1)], [D(2) Dv(2)], [D(3) Dv(3)], 'r:');
%             plot3([E(1) Ev(1)], [E(2) Ev(2)], [E(3) Ev(3)], 'b:');
%             plot3([F(1) Fv(1)], [F(2) Fv(2)], [F(3) Fv(3)], 'g:');

            % Work Triangle:
            plot3(TCP(1), TCP(2), TCP(3), 'ko');

            plot3(G(1), G(2), G(3), 'rx');
            plot3(H(1), H(2), H(3), 'bx');
            plot3(I(1), I(2), I(3), 'gx');

            plot3([TCP(1) G(1)], [TCP(2) G(2)], [TCP(3) G(3)], 'r-.')
            plot3([TCP(1) H(1)], [TCP(2) H(2)], [TCP(3) H(3)], 'b-.')
            plot3([TCP(1) I(1)], [TCP(2) I(2)], [TCP(3) I(3)], 'g-.')

            % Lower arm:

            plot3([D(1) G(1)], [D(2) G(2)], [D(3) G(3)], 'r--');
            plot3([E(1) H(1)], [E(2) H(2)], [E(3) H(3)], 'b--');
            plot3([F(1) I(1)], [F(2) I(2)], [F(3) I(3)], 'g--');

            % Plot the triangles edges:
            % Base:
            plot3([obj.A(1) obj.B(1)], [obj.A(2) obj.B(2)], [obj.A(3) obj.B(3)], 'k');
            plot3([obj.A(1) obj.C(1)], [obj.A(2) obj.C(2)], [obj.A(3) obj.C(3)], 'k');
            plot3([obj.C(1) obj.B(1)], [obj.C(2) obj.B(2)], [obj.C(3) obj.B(3)], 'k');

            %Work:
            plot3([G(1) H(1)], [G(2) H(2)], [G(3) H(3)], 'k');
            plot3([G(1) I(1)], [G(2) I(2)], [G(3) I(3)], 'k');
            plot3([I(1) H(1)], [I(2) H(2)], [I(3) H(3)], 'k');

            hold off;
            
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