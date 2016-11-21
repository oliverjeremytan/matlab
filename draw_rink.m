function draw_rink(scale)
% Measurements taken from https://en.wikipedia.org/wiki/Ice_hockey_rink
% Using NHL measurements as oppossed to international
% 200 ft by 85 ft
leng = 200;
widd = 85;

marg = 5;
x_init = -leng/2;
y_init = -widd/2;
axis equal;

hold on;
xlim(scale*[-marg-leng/2, marg+leng/2]);
ylim(scale*[-marg-widd/2 , marg+widd/2]);


%% sidelines
r = rectangle('Position', scale*[x_init, y_init, leng, widd], 'Curvature', [.3 .5]);
%set(r, 'LineWidth', 3);


%% goal lines

% left
x = scale*[x_init+11, x_init+11];
y = scale*[y_init+5, y_init+widd-5];
gl1 = line(x,y);
set(gl1, 'Color', [1 0 0]);
%set(gl1, 'LineWidth', 3);

% right
x = scale*[x_init+leng-11, x_init+leng-11];
y = scale*[y_init+5, y_init+widd-5];
gl2 = line(x,y);
set(gl2, 'Color', [1 0 0]);


%% center line
x = scale*[x_init+leng/2, x_init+leng/2];
y = scale*[y_init, y_init+widd];
cl = line(x,y);
set(cl, 'Color', [1 0 0]);

%% blue lines

% left
x = scale*[x_init+leng/2-25, x_init+leng/2-25];
y = scale*[y_init, y_init+widd];
bl1 = line(x,y);
set(bl1, 'Color', [0 0 1]);

% right
x = scale*[x_init+leng/2+25, x_init+leng/2+25];
y = scale*[y_init, y_init+widd];
bl2 = line(x,y);
set(bl2, 'Color', [0 0 1]);


%% center circle
center = scale*[x_init+leng/2, y_init+widd/2];
viscircles(center, scale*15, 'Color', [0 0 1], 'LineWidth', .5);

% Alternate way
% t = linspace(0, 2*pi, 1000);
% r = 15;
% plot(marg+leng/2+r*cos(t), marg+widd/2+r*sin(t),'b');


%% neutral zone face off spot
% These are 2 ft in diameter and are 5 ft from the blue line. 
% They are 44 feet apart.

% Using circles function from MATLAB file exchange by Chad Greene

% bottom left
circles(scale*(x_init+leng/2-20), scale*(y_init+(widd-44)/2), scale, 'facecolor', 'red', 'edgecolor', [1 0 0])
% top left
circles(scale*(x_init+leng/2-20), scale*(y_init+widd-(widd-44)/2), scale, 'facecolor', 'red', 'edgecolor', [1 0 0])
% bottom right
circles(scale*(x_init+leng/2+20), scale*(y_init+(widd-44)/2), scale, 'facecolor', 'red', 'edgecolor', [1 0 0])
% top right
circles(scale*(x_init+leng/2+20), scale*(y_init+widd-(widd-44)/2), scale, 'facecolor', 'red', 'edgecolor', [1 0 0])


%% end zones face off circles
% The face off circles are located 20 feet out from the goal line

% bottom left
circles(scale*(x_init+11+20), scale*(y_init+(widd-44)/2), scale*15, 'facecolor', 'none', 'edgecolor', [1 0 0])
% top right
circles(scale*(x_init+11+20), scale*(y_init+widd-(widd-44)/2), scale*15, 'facecolor', 'none', 'edgecolor', [1 0 0])
% bottom right
circles(scale*(x_init+leng-11-20), scale*(y_init+(widd-44)/2), scale*15, 'facecolor', 'none', 'edgecolor', [1 0 0])
% top right
circles(scale*(x_init+leng-11-20), scale*(y_init+widd-(widd-44)/2), scale*15, 'facecolor', 'none', 'edgecolor', [1 0 0])


%% end zones face off spots

% bottom left
circles(scale*(x_init+11+20), scale*(y_init+(widd-44)/2), scale, 'facecolor', 'red', 'edgecolor', [1 0 0])
% top left
circles(scale*(x_init+11+20), scale*(y_init+widd-(widd-44)/2), scale, 'facecolor', 'red', 'edgecolor', [1 0 0])
% bottom right
circles(scale*(x_init+leng-11-20), scale*(y_init+(widd-44)/2), scale, 'facecolor', 'red', 'edgecolor', [1 0 0])
% top right
circles(scale*(x_init+leng-11-20), scale*(y_init+widd-(widd-44)/2), scale, 'facecolor', 'red', 'edgecolor', [1 0 0])


%% goal crease
% The goal crease is a half circle with radius of 6 ft (1.8 m). 
% In the NHL and North American professional leagues, this goal crease is 
% truncated by straight lines extending from the goal line 1 ft outside 
% each goal post which is 6 ft wide.
% http://icehockey.isport.com/icehockey-guides/ice-hockey-rink-dimensions

theta = asin(2/3);

% left
t = linspace(-theta, theta, 500);
r = 6;
plot(scale*(x_init+11+r*cos(t)), scale*(y_init+widd/2+r*sin(t)),'r');

x = scale*[x_init+11, x_init+11+r*cos(theta)];
y = scale*[y_init+widd/2+r*sin(theta), y_init+widd/2+r*sin(theta)];
gc1 = line(x,y);
set(gc1, 'Color', [1 0 0]);

y = scale*[y_init+widd/2-r*sin(theta), y_init+widd/2-r*sin(theta)];
gc2 = line(x,y);
set(gc2, 'Color', [1 0 0]);

% right
t = linspace(theta, -theta, 500);
r = 6;
plot(scale*(x_init+leng-11-r*cos(t)), scale*(y_init+widd/2-r*sin(t)),'r');

x = scale*[x_init+leng-11, x_init+leng-11-r*cos(theta)];
y = scale*[y_init+widd/2+r*sin(theta), y_init+widd/2+r*sin(theta)];
gc3 = line(x,y);
set(gc3, 'Color', [1 0 0]);

y = scale*[y_init+widd/2-r*sin(theta), y_init+widd/2-r*sin(theta)];
gc4 = line(x,y);
set(gc4, 'Color', [1 0 0]);


end
