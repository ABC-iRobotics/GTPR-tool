function [UpperIntersectionPoint, LowerIntersectionPoint] = threeSpheresIntersection(c1, c2, c3, r1, r2, r3)
    % Three-speheres intersection algorithm from:
    % The Delta Parallel Robot: Kinematics Solutions
    % Robert L. Williams II, Ph.D., williar4@ohio.edu
    % Mechanical Engineering, Ohio University, October 2016
    % Appendix A-B.
    % This function uses both algorithms, and chooses the one that is solvable.

    % UpperIntersectionPoint = nan;
    % LowerIntersectionPoint = interx(c1,c2,c3,r1,r2,r3,0);


    if c1(3) == c2(3) && c2(3) == c3(3) && c3(3) == c1(3)
        [UpperIntersectionPoint, LowerIntersectionPoint] = SimplifiedThreeSpheresIntersectionAlgorithm(c1, c2, c3, r1, r2, r3);

    elseif c3(3) == c1(3)
        [UpperIntersectionPoint, LowerIntersectionPoint] = threeSpheresIntersectionAlgorithm(c1, c3, c2, r1, r3, r2);

    elseif c3(3) == c2(3)
        [UpperIntersectionPoint, LowerIntersectionPoint] = threeSpheresIntersectionAlgorithm(c3, c2, c1, r3, r2, r1);

    else
        [UpperIntersectionPoint, LowerIntersectionPoint] = threeSpheresIntersectionAlgorithm(c1, c2, c3, r1, r2, r3);
    end

end

