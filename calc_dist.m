function d = calc_dist(X, Y, player, hmat)
    
    % Get the midpoint of the bottom line of each bounding box
    a = player.x + player.width/2;
    b = player.y + player.height;
	
	[a, b] = transf_point(hmat, a, b);
    
    % Get the distance between midpoint and inv X and Y
    d = sqrt((X-a)^2 + (Y-b)^2);
	d = d / 6.95;

end