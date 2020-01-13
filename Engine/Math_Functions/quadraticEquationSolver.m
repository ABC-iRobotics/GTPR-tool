function x = quadraticEquationSolver(a,b,c)
d = sqrt(power(b,2) - 4 * a * c);
e = 2*a;

x(1) = (-b + d)/e;
x(2) = (-b - d)/e;

if ~isreal(x)
    warning('Imaginary solution for sqrt(power(b,2) - 4 * a * c).')
end

end