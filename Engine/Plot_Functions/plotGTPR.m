function plotGTPR(GTPR, q, varargin)
    % Plots the GTPR:
    % Use the arguments 'nice' to plot the triangle edges

    GTPRCharacteristicPoints = GTPR.DirectGeometry(q);

    A = GTPRCharacteristicPoints.A;
    B = GTPRCharacteristicPoints.B;
    C = GTPRCharacteristicPoints.C;

    D = GTPRCharacteristicPoints.D;
    E = GTPRCharacteristicPoints.E;
    F = GTPRCharacteristicPoints.F;

    Dv = GTPRCharacteristicPoints.Dv;
    Ev = GTPRCharacteristicPoints.Ev;
    Fv = GTPRCharacteristicPoints.Fv;
    
    TCP = GTPRCharacteristicPoints.TCP;

    G = GTPRCharacteristicPoints.G;
    H = GTPRCharacteristicPoints.H;
    I = GTPRCharacteristicPoints.I;

%             figureHandle = figure();

    hold on;
    plot3(0,0,0, 'k*');

    %Base triangle:
    plot3(A(1), A(2), A(3), 'r*');
    plot3(B(1), B(2), B(3), 'b*');
    plot3(C(1), C(2), C(3), 'g*');

    plot3([0 A(1)], [0 A(2)], [0 A(3)], 'k--')
    plot3([0 B(1)], [0 B(2)], [0 B(3)], 'k--')
    plot3([0 C(1)], [0 C(2)], [0 C(3)], 'k--')

    % Upper arm:
    plot3(D(1), D(2), D(3), 'r.');
    plot3(E(1), E(2), E(3), 'b.');
    plot3(F(1), F(2), F(3), 'g.');

    plot3([A(1) D(1)], [A(2) D(2)], [A(3) D(3)], 'r');
    plot3([B(1) E(1)], [B(2) E(2)], [B(3) E(3)], 'b');
    plot3([C(1) F(1)], [C(2) F(2)], [C(3) F(3)], 'g');

    % Virtual point:
    plot3(Dv(1), Dv(2), Dv(3), 'rs');
    plot3(Ev(1), Ev(2), Ev(3), 'bs');
    plot3(Fv(1), Fv(2), Fv(3), 'gs');

    plot3([D(1) Dv(1)], [D(2) Dv(2)], [D(3) Dv(3)], 'r:');
    plot3([E(1) Ev(1)], [E(2) Ev(2)], [E(3) Ev(3)], 'b:');
    plot3([F(1) Fv(1)], [F(2) Fv(2)], [F(3) Fv(3)], 'g:');

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

    % Check the no of arguments to make adjustments:
    if size(varargin) == 1
        if strcmp(varargin{1}, 'nice')

            % Plot the triangles edges:
            % Base:
            plot3([A(1) B(1)], [A(2) B(2)], [A(3) B(3)], 'k');
            plot3([A(1) C(1)], [A(2) C(2)], [A(3) C(3)], 'k');
            plot3([C(1) B(1)], [C(2) B(2)], [C(3) B(3)], 'k');

            %Work:
            plot3([G(1) H(1)], [G(2) H(2)], [G(3) H(3)], 'k');
            plot3([G(1) I(1)], [G(2) I(2)], [G(3) I(3)], 'k');
            plot3([I(1) H(1)], [I(2) H(2)], [I(3) H(3)], 'k');

        end
    end

    hold off;

end