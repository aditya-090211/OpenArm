clc;
clear;
close all;

set(0,'DefaultFigureWindowStyle','normal');

%% =====================================================
% OPENARM CYLINDRICAL MOTION PLANNER
%% =====================================================

% -----------------------------------------------------
% ARM GEOMETRY
% -----------------------------------------------------

L1 = 75;
L2 = 75;
L3 = 75;

shoulderOffset = 31.64;
shoulderHeight = 55;

maxReach = L1 + L2 + L3;

% -----------------------------------------------------
% DEADZONE
% -----------------------------------------------------

deadzoneLength = 180;
deadzoneWidth  = 100;
deadzoneHeight = 57;

safetyMargin = 8;

dzXMin = -deadzoneLength/2 - safetyMargin;
dzXMax =  deadzoneLength/2 + safetyMargin;

dzYMin = -deadzoneWidth/2 - safetyMargin;
dzYMax =  deadzoneWidth/2 + safetyMargin;

dzZMin = 0;
dzZMax = deadzoneHeight + safetyMargin;

% -----------------------------------------------------
% CURRENT STATE
% -----------------------------------------------------

currentBase = deg2rad(0);

currentTheta1 = deg2rad(40);
currentTheta2 = deg2rad(-30);
currentTheta3 = deg2rad(-10);

% -----------------------------------------------------
% MAIN WINDOW
% -----------------------------------------------------

animFig = figure( ...
    'Name','OpenArm Planner', ...
    'NumberTitle','off');

%% =====================================================
% MAIN LOOP
%% =====================================================

while true

    %% =================================================
    % TOP VIEW - SELECT PLANE
    %% =================================================

    topFig = figure( ...
        'Name','Top View', ...
        'NumberTitle','off');

    clf;

    hold on;
    grid on;
    axis equal;

    title('TOP VIEW - Select Direction / Plane');

    xlabel('X (mm)');
    ylabel('Y (mm)');

    xlim([-300 300]);
    ylim([-300 300]);

    %% Workspace Circle

    th = linspace(0,2*pi,400);

    plot( ...
        maxReach*cos(th), ...
        maxReach*sin(th), ...
        '--', ...
        'LineWidth',2);

    %% Deadzone

    rectangle( ...
        'Position', ...
        [ ...
        -deadzoneLength/2 ...
        -deadzoneWidth/2 ...
         deadzoneLength ...
         deadzoneWidth], ...
        'FaceColor',[1 0.4 0.4], ...
        'EdgeColor','none');

    %% Base

    scatter(0,0,200,'filled');

    %% User Click

    disp('Click desired arm direction');

    [planeX,planeY] = ginput(1);

    plot([0 planeX],[0 planeY], ...
        'LineWidth',2);

    scatter(planeX,planeY,250,'filled');

    drawnow;
    pause(0.2);

    close(topFig);

    %% =================================================
    % BASE ANGLE
    %% =================================================

    targetBase = atan2(planeY,planeX);

    %% =================================================
    % SIDE VIEW - SELECT REACH + HEIGHT
    %% =================================================

    sideFig = figure( ...
        'Name','Side View', ...
        'NumberTitle','off');

    clf;

    hold on;
    grid on;
    axis equal;

    title('SIDE VIEW - Click Reach + Height');

    xlabel('Radial Distance (mm)');
    ylabel('Height (mm)');

    xlim([0 300]);
    ylim([0 300]);

    %% Ground

    plot([0 400],[0 0], ...
        'k','LineWidth',3);

    %% Workspace Boundary

    plot( ...
        shoulderOffset + maxReach*cos(th), ...
        shoulderHeight + maxReach*sin(th), ...
        '--', ...
        'LineWidth',2);

    %% Deadzone

    rectangle( ...
        'Position', ...
        [0 0 deadzoneLength/2 deadzoneHeight], ...
        'FaceColor',[1 0.4 0.4], ...
        'EdgeColor','none');

    %% Shoulder

    scatter( ...
        shoulderOffset, ...
        shoulderHeight, ...
        200, ...
        'filled');

    %% Instructions

    text( ...
        20, ...
        270, ...
        'Click desired reach + height', ...
        'FontSize',12);

    %% User Click

    [radialTarget,zt] = ginput(1);

    zt = max(zt,5);

    %% Draw Target

    scatter( ...
        radialTarget, ...
        zt, ...
        250, ...
        'filled');

    plot( ...
        [radialTarget radialTarget], ...
        [0 zt], ...
        ':', ...
        'LineWidth',1.5);

    plot( ...
        [0 radialTarget], ...
        [zt zt], ...
        ':', ...
        'LineWidth',1.5);

    drawnow;
    pause(0.2);

    close(sideFig);

    %% =================================================
    % CYLINDRICAL -> CARTESIAN
    %% =================================================

    xt = radialTarget*cos(targetBase);
    yt = radialTarget*sin(targetBase);

    %% =================================================
    % PLANNING SCREEN
    %% =================================================

    figure(animFig);

    clf;
    axis off;

    text( ...
        0.1, ...
        0.5, ...
        'Searching for optimal collision-free path...', ...
        'FontSize',18);

    drawnow;

    %% =================================================
    % MONTE CARLO SEARCH
    %% =================================================

    bestCost = inf;
    validPathFound = false;
    bestTrajectory = [];

    bestBase = currentBase;
    bestT1 = currentTheta1;
    bestT2 = currentTheta2;
    bestT3 = currentTheta3;

    numAttempts = 1000;

    for attempt = 1:numAttempts

        %% Progress Display

        if mod(attempt,25) == 1

            figure(animFig);

            clf;
            axis off;

            text( ...
                0.08, ...
                0.55, ...
                sprintf( ...
                'Searching paths... %d / %d', ...
                attempt, ...
                numAttempts), ...
                'FontSize',18);

            text( ...
                0.08, ...
                0.42, ...
                'Testing alternate trajectories...', ...
                'FontSize',12);

            drawnow;

        end

        %% =================================================
        % RANDOM WAYPOINT STRATEGIES
        %% =================================================

        mode = randi(7);

        switch mode

            case 1

                waypoints = [
                    xt yt zt];

            case 2

                waypoints = [
                    xt yt zt+80+rand()*100;
                    xt yt zt];

            case 3

                waypoints = [
                    0 0 max(zt+120,90);
                    xt yt zt];

            case 4

                retractScale = 0.3 + 0.4*rand();

                waypoints = [
                    xt*retractScale ...
                    yt*retractScale ...
                    zt+80+rand()*80;

                    xt yt zt];

            case 5

                rr = radialTarget*(0.2 + 0.6*rand());

                aa = targetBase + ...
                    (rand()-0.5)*deg2rad(40);

                waypoints = [
                    rr*cos(aa) ...
                    rr*sin(aa) ...
                    zt+100+rand()*120;

                    xt yt zt];

            case 6

                waypoints = [
                    xt yt zt+160;
                    xt yt zt];

            otherwise

                rr = radialTarget*(0.3 + 0.5*rand());

                aa = targetBase + ...
                    (rand()-0.5)*deg2rad(60);

                waypoints = [
                    rr*cos(aa) ...
                    rr*sin(aa) ...
                    zt+140+rand()*80;

                    xt yt zt];

        end

        %% =================================================
        % TEMP STATE
        %% =================================================

        tempBase = currentBase;

        tempT1 = currentTheta1;
        tempT2 = currentTheta2;
        tempT3 = currentTheta3;

        fullTrajectory = struct( ...
            'base',{}, ...
            't1',{}, ...
            't2',{}, ...
            't3',{});

        pathValid = true;
        totalCost = 0;

        %% =================================================
        % SOLVE WAYPOINTS
        %% =================================================

        for wp = 1:size(waypoints,1)

            tx = waypoints(wp,1);
            ty = waypoints(wp,2);
            tz = waypoints(wp,3);

            %% Cylindrical

            baseAngle = atan2(ty,tx);

            radial = sqrt(tx^2 + ty^2);

            dx = radial - shoulderOffset;
            dz = tz - shoulderHeight;

            %% Reachability

            totalDistance = sqrt(dx^2 + dz^2);

            if totalDistance > maxReach

                pathValid = false;
                break;

            end

            %% End Effector Angle

            desiredAngle = atan2(dz,dx);

            %% Wrist Position

            wristX = dx - L3*cos(desiredAngle);
            wristZ = dz - L3*sin(desiredAngle);

            wristDistance = ...
                sqrt(wristX^2 + wristZ^2);

            if wristDistance > (L1 + L2)

                pathValid = false;
                break;

            end

            %% IK

            D = ( ...
                wristX^2 + wristZ^2 ...
                - L1^2 - L2^2) ...
                / (2*L1*L2);

            D = max(min(D,1),-1);

            solutions = [];

            for signValue = [-1 1]

                theta2 = atan2( ...
                    signValue*sqrt(1-D^2), ...
                    D);

                theta1 = atan2( ...
                    wristZ, ...
                    wristX) ...
                    - atan2( ...
                    L2*sin(theta2), ...
                    L1 + L2*cos(theta2));

                theta3 = desiredAngle ...
                    - theta1 ...
                    - theta2;

                cost = ...
                    abs(theta1-tempT1) ...
                    + abs(theta2-tempT2) ...
                    + abs(theta3-tempT3);

                solutions = [solutions;
                    theta1 theta2 theta3 cost];

            end

            %% Best IK

            [~,idx] = min(solutions(:,4));

            targetT1 = solutions(idx,1);
            targetT2 = solutions(idx,2);
            targetT3 = solutions(idx,3);

            %% =================================================
            % TRAJECTORY
            %% =================================================

            steps = 45;

            s = linspace(0,1,steps);

            smoothS = 3*s.^2 - 2*s.^3;

            trajBase = tempBase + ...
                smoothS*(baseAngle-tempBase);

            traj1 = tempT1 + ...
                smoothS*(targetT1-tempT1);

            traj2 = tempT2 + ...
                smoothS*(targetT2-tempT2);

            traj3 = tempT3 + ...
                smoothS*(targetT3-tempT3);

            %% =================================================
            % COLLISION CHECK
            %% =================================================

            trajectoryValid = true;
            minDistance = inf;

            for i = 1:steps

                base = trajBase(i);

                t1 = traj1(i);
                t2 = traj2(i);
                t3 = traj3(i);

                %% FK

                sx = shoulderOffset*cos(base);
                sy = shoulderOffset*sin(base);
                sz = shoulderHeight;

                px1 = L1*cos(t1);
                pz1 = L1*sin(t1);

                px2 = px1 + L2*cos(t1+t2);
                pz2 = pz1 + L2*sin(t1+t2);

                px3 = px2 + L3*cos(t1+t2+t3);
                pz3 = pz2 + L3*sin(t1+t2+t3);

                x1 = sx;
                y1 = sy;
                z1 = sz;

                x2 = sx + px1*cos(base);
                y2 = sy + px1*sin(base);
                z2 = sz + pz1;

                x3 = sx + px2*cos(base);
                y3 = sy + px2*sin(base);
                z3 = sz + pz2;

                x4 = sx + px3*cos(base);
                y4 = sy + px3*sin(base);
                z4 = sz + pz3;

                %% Distal Links Only

                links = [
                    x2 y2 z2 x3 y3 z3;
                    x3 y3 z3 x4 y4 z4];

                for L = 1:size(links,1)

                    xs = links(L,1);
                    ys = links(L,2);
                    zs = links(L,3);

                    xe = links(L,4);
                    ye = links(L,5);
                    ze = links(L,6);

                    %% Dense Sampling

                    for t = linspace(0,1,25)

                        px = xs + t*(xe-xs);
                        py = ys + t*(ye-ys);
                        pz = zs + t*(ze-zs);

                        %% Ground

                        if pz < 0
                            trajectoryValid = false;
                        end

                        %% Deadzone

                        insideX = ...
                            px > dzXMin ...
                            && px < dzXMax;

                        insideY = ...
                            py > dzYMin ...
                            && py < dzYMax;

                        insideZ = ...
                            pz > dzZMin ...
                            && pz < dzZMax;

                        if insideX && insideY && insideZ

                            trajectoryValid = false;

                        end

                        %% Distance

                        dxBox = max([ ...
                            dzXMin-px ...
                            0 ...
                            px-dzXMax]);

                        dyBox = max([ ...
                            dzYMin-py ...
                            0 ...
                            py-dzYMax]);

                        dzBox = max([ ...
                            dzZMin-pz ...
                            0 ...
                            pz-dzZMax]);

                        distBox = sqrt( ...
                            dxBox^2 + ...
                            dyBox^2 + ...
                            dzBox^2);

                        minDistance = ...
                            min(minDistance,distBox);

                    end

                end

            end

            %% Invalid

            if ~trajectoryValid

                pathValid = false;
                break;

            end

            %% Cost

            segmentCost = ...
                abs(targetT1-tempT1) ...
                + abs(targetT2-tempT2) ...
                + abs(targetT3-tempT3) ...
                + 0.02*(1/max(minDistance,1));

            totalCost = totalCost + segmentCost;

            %% Store Segment

            seg.base = trajBase;
            seg.t1 = traj1;
            seg.t2 = traj2;
            seg.t3 = traj3;

            fullTrajectory = [
                fullTrajectory;
                seg];

            %% Update State

            tempBase = baseAngle;

            tempT1 = targetT1;
            tempT2 = targetT2;
            tempT3 = targetT3;

        end

        %% =================================================
        % BEST PATH
        %% =================================================

        if pathValid

            validPathFound = true;

            if totalCost < bestCost

                bestCost = totalCost;

                bestTrajectory = fullTrajectory;

                bestBase = tempBase;
                bestT1 = tempT1;
                bestT2 = tempT2;
                bestT3 = tempT3;

            end

        end

    end

    %% =================================================
    % NO VALID PATH
    %% =================================================

    if ~validPathFound

        figure(animFig);

        clf;
        axis off;

        text( ...
            0.2, ...
            0.5, ...
            'No valid path found.', ...
            'FontSize',18);

        drawnow;

        choice = menu( ...
            'No valid path found', ...
            'Choose Another Target', ...
            'Exit');

        if choice == 2

            close(animFig);
            break;

        else

            continue;

        end

    end

    %% =================================================
    % ANIMATION
    %% =================================================

    figure(animFig);

    for seg = 1:length(bestTrajectory)

        trajBase = bestTrajectory(seg).base;

        traj1 = bestTrajectory(seg).t1;
        traj2 = bestTrajectory(seg).t2;
        traj3 = bestTrajectory(seg).t3;

        for i = 1:length(trajBase)

            clf;

            hold on;
            grid on;
            axis equal;

            view(45,30);

            xlabel('X');
            ylabel('Y');
            zlabel('Z');

            xlim([-300 300]);
            ylim([-300 300]);
            zlim([0 300]);

            title('OPENARM MOTION');

            %% Ground

            fill3( ...
                [-400 400 400 -400], ...
                [-400 -400 400 400], ...
                [0 0 0 0], ...
                [0.9 0.9 0.9]);

            %% Deadzone

            dzX = [-90 90 90 -90 -90 90 90 -90];
            dzY = [-50 -50 50 50 -50 -50 50 50];
            dzZ = [0 0 0 0 57 57 57 57];

            faces = [
                1 2 3 4;
                5 6 7 8;
                1 2 6 5;
                2 3 7 6;
                3 4 8 7;
                4 1 5 8];

            patch( ...
                'Vertices',[dzX' dzY' dzZ'], ...
                'Faces',faces, ...
                'FaceColor',[1 0.4 0.4], ...
                'FaceAlpha',0.4);

            %% FK

            base = trajBase(i);

            t1 = traj1(i);
            t2 = traj2(i);
            t3 = traj3(i);

            sx = shoulderOffset*cos(base);
            sy = shoulderOffset*sin(base);
            sz = shoulderHeight;

            px1 = L1*cos(t1);
            pz1 = L1*sin(t1);

            px2 = px1 + L2*cos(t1+t2);
            pz2 = pz1 + L2*sin(t1+t2);

            px3 = px2 + L3*cos(t1+t2+t3);
            pz3 = pz2 + L3*sin(t1+t2+t3);

            x0 = 0;
            y0 = 0;
            z0 = 0;

            x1 = sx;
            y1 = sy;
            z1 = sz;

            x2 = sx + px1*cos(base);
            y2 = sy + px1*sin(base);
            z2 = sz + pz1;

            x3 = sx + px2*cos(base);
            y3 = sy + px2*sin(base);
            z3 = sz + pz2;

            x4 = sx + px3*cos(base);
            y4 = sy + px3*sin(base);
            z4 = sz + pz3;

            %% Draw Arm

            plot3([x0 x1],[y0 y1],[z0 z1], ...
                'LineWidth',5);

            plot3([x1 x2],[y1 y2],[z1 z2], ...
                'LineWidth',5);

            plot3([x2 x3],[y2 y3],[z2 z3], ...
                'LineWidth',5);

            plot3([x3 x4],[y3 y4],[z3 z4], ...
                'LineWidth',5);

            %% Joints

            scatter3( ...
                [x0 x1 x2 x3 x4], ...
                [y0 y1 y2 y3 y4], ...
                [z0 z1 z2 z3 z4], ...
                120, ...
                'filled');

            %% Target

            scatter3( ...
                xt, ...
                yt, ...
                zt, ...
                250, ...
                'filled');

            drawnow;

            pause(0.015);

        end

    end

    %% Save Final State

    currentBase = bestBase;

    currentTheta1 = bestT1;
    currentTheta2 = bestT2;
    currentTheta3 = bestT3;

    %% USER MENU

    choice = menu( ...
        'Path Complete', ...
        'Choose Another Target', ...
        'Exit');

    if choice == 2

        close(animFig);
        break;

    end

end
