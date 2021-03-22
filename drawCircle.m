function drawCircle(center,radius,R)
theta = linspace(0,2*pi,100);
points = R*[radius*cos(theta);zeros(size(theta));radius*sin(theta)];
line(center(1)+points(1,:),center(2)+points(2,:),center(3)+points(3,:));

end