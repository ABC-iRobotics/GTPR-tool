function [UpperIntersectionPoint, LowerIntersectionPoint] = threeSpheresIntersectionAlgorithm(c1, c2, c3, r1, r2, r3)
% Three-speheres intersection algorithm from:
% The Delta Parallel Robot: Kinematics Solutions
% Robert L. Williams II, Ph.D., williar4@ohio.edu
% Mechanical Engineering, Ohio University, October 2016
% Appendix A.

x1 = c1(1);
y1 = c1(2);
z1 = c1(3);

x2 = c2(1);
y2 = c2(2);
z2 = c2(3);

x3 = c3(1);
y3 = c3(2);
z3 = c3(3);


a11 = 2*(x3-x1);
a12 = 2*(y3-y1);
a13 = 2*(z3-z1);

a21 = 2*(x3-x2);
a22 = 2*(y3-y2);
a23 = 2*(z3-z2);

b1 = power(r1,2)-power(r3,2)-power(x1,2)-power(y1,2)-power(z1,2)+power(x3,2)+power(y3,2)+power(z3,2);
b2 = power(r2,2)-power(r3,2)-power(x2,2)-power(y2,2)-power(z2,2)+power(x3,2)+power(y3,2)+power(z3,2);

a1 = (a11/a13)-(a21/a23);
a2 = (a12/a13)-(a22/a23);
a3 = (b2/a23)-(b1/a13);
a4 = -(a2/a1);
a5 = -(a3/a1);
a6 = (-a21*a4-a22)/a23;
a7 = (b2-a21*a5)/a23;


a = power(a4,2) + 1 + power(a6,2);

% Singularity conditions:
if a13 == 0 || a23 == 0 || a1 == 0 || a == 0
    error('Singularity condition present! Sphere centers are in same Z height!');
end

b = 2*a4*(a5-x1)-2*y1+2*a6*(a7-z1);
c = a5*(a5-2*x1)+a7*(a7-2*z1)+power(x1,2)+power(y1,2)+power(z1,2)-power(r1,2);

lastwarn(''); % clear last warning message

y = quadraticEquationSolver(a,b,c);

[warnMsg, ~] = lastwarn;

if strcmp(warnMsg,'Imaginary solution for sqrt(power(b,2) - 4 * a * c).')
    warning('Not all 3 spheres intersect!')
end

x = nan(2,1);
z = nan(2,1);

x(1) = a4*y(1)+a5;
x(2) = a4*y(2)+a5;

z(1) = a6*y(1)+a7;
z(2) = a6*y(2)+a7;

if z(1) > z(2)
    UpperIntersectionPoint = [x(1); y(1); z(1)];
    LowerIntersectionPoint = [x(2); y(2); z(2)];
else
    UpperIntersectionPoint = [x(2); y(2); z(2)];
    LowerIntersectionPoint = [x(1); y(1); z(1)];
end

end

