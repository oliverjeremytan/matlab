%% Setup
clear 
clc

% Open file containing vector of structures
period = 1;
dataDir = 'somedirectory';
load([dataDir, 'ParseData/period1.mat']);    % will get "frames"
imgDir = [dataDir, '1403-1_frames/period1_'];
numImgs = 62516;


%% Open file containing play sequences
load period1seq    % will get "sequence"

%% Open player map and vector containing frames with actions
load period1frames  % will get "frameNum"
load playerMap      % will get "playerMap"

%% Open template file
% Get spatial referencing information about the image
tp = imread('template.png');
Rtp = imref2d(size(tp));
Rout = Rtp;


%% Process each frame
% Read the image
% Show that image in one subplot
% Check if there is a given homography matrix for that image
% Apply the homography to that image and show it in another subplot
% Plot the rink on top of the new image
% Save the entire figure
A = [1 0 0; 0 1 0; -720 -320 1];


parfor i = 1: length(frameNum)
    
    % get the frame number
    i = frameNum(jj);
    
    %% Read the image
    imgPath = [imgDir, num2str(i, '%.5d'), '.jpg'];
    [~,imgName,~] = fileparts(imgPath);
    
    im = imread(imgPath);
    
    %% Show image in one subplot
    f = figure('units','normalized','outerposition',[0 0 1 1]);
    % Do not display output
    set(f, 'visible', 'off');
    
    h = subplot(2,2,1);
    hold on;
    imshow(im);
    h.Position = [0.000 0.5000 0.5300 0.4612];
    title(['Frame ', num2str(i)]);
    
    %% Get the number of actions in this frame and get their coords
    numActions = sequence(i).num;
    
    % Create a vector that will hold the xy of the action and the xy of the
    % feet of the bounding box if there is any
    % 1/2 for coordinates in real world
    % 3/4 for coordinates in video image
    % 5/6 for the bounding box feet in video image
    % 7/8 for the bounding box feet in real world
    actionPoints = NaN(numActions, 8);
    for aa=1 : numActions        
        actionPoints(aa, 1) = sequence(i).play(aa).x * 6.95;
        actionPoints(aa, 2) = sequence(i).play(aa).y * 6.95;       
    end
     
    %%
    h3 = subplot(2,2,2);
    hold on;
    imshow(im);
    h3.Position = [0.5 0.5000 0.5300 0.4612];
    

    %% Next subplot
    
    h2 = subplot(2,1,2);
    hold on;
    
    % Homography if any
    if i <= length(frames) && frames(i).id ~= 0
               
        % get thenumber of players present in the tracking
        numPlayers = frames(i).numPlayers;
       
        %% Calculate distance
        
        % create a row vector to hold distances
        distances = zeros(1, numPlayers);
        for aa =1 : numActions
            
            [invX, invY] = inv_transf_point(frames(i).hmat, ... 
                                            actionPoints(aa, 1), ...
                                            actionPoints(aa, 2));
                                        
            actionPoints(aa, 3) = invX;
            actionPoints(aa, 4) = invY;
                                        
            for k=1: numPlayers
                distances(k) = calc_dist(invX, invY, frames(i).players(k));
            end
            
            % get the index of the smallest distance
            [c, smallest] = min(distances);
            
            player = frames(i).players(smallest);
            
            actionPoints(aa, 5) = player.x + player.width/2;
            actionPoints(aa, 6) = player.y + player.height;
            
            [xx, yy] = transf_point(frames(i).hmat, actionPoints(aa, 5), ...
                      actionPoints(aa, 6));
            
            actionPoints(aa, 7) = xx;
            actionPoints(aa, 8) = yy;          
        
        end
               
        
        %% Project frame
        tform = projective2d(frames(i).hmat');
        out = imwarp(im,tform,'OutputView',Rout, 'FillValues', 255);
        
        % Translate by 720 x 320
        tform = affine2d(A);
        [o, p] = imwarp(out, tform);
        imshow(o, p);
        
       % Plot bounding boxes
       x = zeros(frames(i).numPlayers, 1);
       y = zeros(frames(i).numPlayers, 1);
       
       % Specify color
       c = zeros(frames(i).numPlayers, 3);
       
       subplot(h3)      
       for k = 1 : numPlayers
           
           % coordinates of the "feet of the bounding box"
           a = frames(i).players(k).x + frames(i).players(k).width/2;
           b = frames(i).players(k).y + frames(i).players(k).height;
           
           % Apply homography to get new points 
           [x(k), y(k)] = transf_point(frames(i).hmat, a, b);
           
           
           %% Plot bounding box on original image also
           x2 = frames(i).players(k).x;
           y2 = frames(i).players(k).y;
           width = frames(i).players(k).width;
           height = frames(i).players(k).height;
           
           subplot(h3);
           r = rectangle('Position', [x2 ,y2, width, height]);
           
           % Change color
           for aa=1: numActions
               if actionPoints(aa, 5) == a && actionPoints(aa, 6) == b
                   refId = sequence(i).play(aa).refId;
                   player = playerMap(refId);
                   if strcmp('Pittsburgh Penguins', player.team)
                       c(k, :) = [1 0 1];
                       r.EdgeColor = [1 0 1];
                   elseif strcmp('Montreal Canadiens', player.team)
                       c(k, :) = [0 1 0];
                       r.EdgeColor = [0 1 0];
                   end
               end
           end
           
           subplot(h);
           r = rectangle('Position', [x2 ,y2, width, height]);
           q = mod(frames(i).players(k).id, 2);
           w = 0;
           e = 0;
           
           if mod(frames(i).players(k).id, 3) == 1
               w = 1;
           end
           if mod(frames(i).players(k).id, 3) == 2
               e = 1;
           end
           
           r.EdgeColor = [q w e];
       end
       
       %% Plot line from action to bounding box
       for aa=1: numActions
           subplot(h3);
           lx = [actionPoints(aa, 3), actionPoints(aa, 5)];
           ly = [actionPoints(aa, 4), actionPoints(aa, 6)];           
           
           plot(lx,ly,'-ks', 'LineWidth',2, 'MarkerSize',6,...
                'MarkerEdgeColor','r', 'MarkerFaceColor',[0.5,0.5,0.5]);
            
            
           subplot(h2);
           lx = [actionPoints(aa, 1), actionPoints(aa, 7)];
           ly = [actionPoints(aa, 2), actionPoints(aa, 8)];           
           
           plot(lx,ly,'-ks', 'LineWidth',2, 'MarkerSize',6,...
                'MarkerEdgeColor','r', 'MarkerFaceColor',[0.5,0.5,0.5]);
       end
       
       
       subplot(h2)
       d= 45;
       scatter(x,y, d, c, 'filled', 'd', 'MarkerEdgeColor', [0 0 0]);
       
 
       %% Plot play sequence actions
       if sequence(i).num ~= 0
            str = '';
            num = sequence(i).num;
        
            px = zeros(num, 1);
            py = zeros(num, 1);
        
            for ii=1:num
                % get the name of the action
                str = [str, sequence(i).play(ii).name, '\n'];
                
                % get the coordinates
                if isnan(sequence(i).play(ii).x)
                    px(ii) = 720;
                    py(ii) = 320;
                else
                    [px(ii), py(ii)] = inv_transf_point(frames(i).hmat, ...
                                   sequence(i).play(ii).x*6.95, sequence(i).play(ii).y*6.95);
                end           
            end
        
            str = strsplit(str, '\\n');
            str = cellstr(str);
            subplot(h3)
            text(px, py, str, 'Color', [0 0 1], 'FontSize', 13);
       end
    else
        % no homography
        subplot(h2);
        for aa=1: numActions
            plot(actionPoints(aa,1), actionPoints(aa, 2),'s','MarkerSize',6,...
                'MarkerEdgeColor','r', 'MarkerFaceColor',[0.5,0.5,0.5]);
        end
        
    end
    subplot(h2);
    % Draw the hockey rink
    draw_rink(6.95);
    
    % Adjust the plot
    ax = gca;
    ax.XTick = [-700 -350 0 350 700];
    ax.YTick = [-280 -140 0 140 280];
    ax.XTickLabel = {'-100', '-50', '0', '50', '100'};
    ax.YTickLabel = {'-40', '-20', '0', '20', '40'};    
    h2.Position = [.13 .07 .8 .45];
    axis ij
    hold off;
    
    %% Save the new image
    print([dataDir, '1403-', num2str(period), '_playseq/', imgName], ...
             '-djpeg', '-r150');
       
    close(f);


end