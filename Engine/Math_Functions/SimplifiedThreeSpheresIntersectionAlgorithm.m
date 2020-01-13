function [UpperIntersectionPoint, LowerIntersectionPoint] = SimplifiedThreeSpheresIntersectionAlgorithm(c1, c2, c3, r1, r2, r3)
% Simplified Three-speheres intersection algorithm from:
% The Delta Parallel Robot: Kinematics Solutions
% Robert L. Williams II, Ph.D., williar4@ohio.edu
% Mechanical Engineering, Ohio University, October 2016
% Appendix B.

x1 = c1(1);
y1 = c1(2);
z1 = c1(3);

x2 = c2(1);
y2 = c2(2);
z2 = c2(3);

x3 = c3(1);
y3 = c3(2);
z3 = c3(3);

if z1 ~= z2 && z2 ~= z3 && z3 ~= z1
    error("Sphere centers are not in the same height!");
end

a = 2*(x3-x1);
b = 2*(y3-y1);
c = power(r1,2)-power(r3,2)-power(x1,2)-power(y1,2)+power(x3,2)+power(y3,2);
d = 2*(x3-x2);
e = 2*(y3-y2);
f = power(r2,2)-power(r3,2)-power(x2,2)-power(y2,2)+power(x3,2)+power(y3,2);

aebd = a*e-b*d;

if aebd == 0
    error("First singularity condition fulfilled! See the appendix B. of The Delta Parallel Robot: Kinematics Solutions Robert L. Williams II, Ph.D., williar4@ohio.edu, Mechanical Engineering, Ohio University, October 2016 article for explanation!");
end

x = (c*e-b*f)/aebd;
y = (a*f-c*d)/aebd;

A = 1;
B = -2*z1;
C = power(z1,2)-power(r1,2)+power(x-x1,2)+power(y-y1,2);

z = quadraticEquationSolver(A,B,C);
[warnMsg, ~] = lastwarn;
if strcmp(warnMsg,'Imaginary solution for sqrt(power(b,2) - 4 * a * c).')
    warning('Not all 3 spheres intersect! Robot assembly is not fulfilled!')
end

UpperIntersectionPoint = [x; y; z(1)];
LowerIntersectionPoint = [x; y; z(2)];

end

