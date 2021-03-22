function drawMobile(T)
a = 3;
b = 2;
xb = T(1,4);
yb = T(2,4);
zb = T(3,4);
p1 = [-a,b,1]';
p2 = [a,b,1]';
p3 = [a,-b,1]';
p4 = [-a,-b,1]';
R = T(1:3,1:3);
p1 = R*p1+[xb;yb;zb];
p2 = R*p2+[xb;yb;zb];
p3 = R*p3+[xb;yb;zb];
p4 = R*p4+[xb;yb;zb];

plot3(0,0,0);
axis([-10,10,-10,10,-2,20]);

grid on;
hold on;
drawAxis(eye(4));
drawAxis(T);
drawBox(p1,p2,p3,p4);
drawCircle([p1(1),p1(2),0],1,R);
drawCircle([p2(1),p2(2),0],1,R);
drawCircle([p3(1),p3(2),0],1,R);
drawCircle([p4(1),p4(2),0],1,R);


daspect([1,1,1]);

drawnow;
hold off;

end