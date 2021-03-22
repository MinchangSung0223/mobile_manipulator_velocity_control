function drawArm(Tsb,thetalist)
global L1;
global L2;
global L3;

S1 = [0 1 0 0 0 0]';
S2 = [0 1 0 -L1 0 0]';
S3 = [0 1 0 -L1-L2 0 0]';
matS1 = MatrixExp6(VecTose3(S1)*thetalist(1));
matS2 = MatrixExp6(VecTose3(S2)*thetalist(2));
matS3 = MatrixExp6(VecTose3(S3)*thetalist(3));
for k=1:1:4
T{k} = eye(4); 
end
M = [1 0 0 0;...
    0 1 0 0 ;...
    0 0 1 L1;...
    0 0 0 1 ];
Slist = [S1];
T01 =matS1*M;
T{1} = T01;

M = [1 0 0 0;...
    0 1 0 0 ;...
    0 0 1 L1+L2;...
    0 0 0 1 ];
Slist = [S1,S2];
T02 =matS1*matS2*M;
T{2} = T02;

M = [1 0 0 0;...
    0 1 0 0 ;...
    0 0 1 L1+L2+L3;...
    0 0 0 1 ];
Slist = [S1,S2,S3];
T03 =matS1*matS2*matS3*M;
T{3} = T03;

 p0 = [0,0,0,1]';
 p0x =[0.5,0,0,1]';
 p0y = [0,0.5,0,1]';
 p0z = [0,0,0.5,1]';
 
p1 = Tsb*T{1}*p0;
 p1x = Tsb*T{1}*p0x;
 p1y = Tsb*T{1}*p0y;
 p1z = Tsb*T{1}*p0z;
 
 p2 = Tsb*T{2}*p0;
 p2x = Tsb*T{2}*p0x;
 p2y =Tsb*T{2}*p0y;
 p2z =Tsb*T{2}*p0z;
 
 p3 =Tsb*T{3}*p0;
 p3x =Tsb*T{3}*p0x;
 p3y = Tsb*T{3}*p0y;
 p3z =Tsb*T{3}*p0z;
 
 p0 = Tsb*[0,0,0,1]';
 p0x =Tsb*[0.5,0,0,1]';
 p0y = Tsb*[0,0.5,0,1]';
 p0z = Tsb*[0,0,0.5,1]';
 
 plot3([0,10 0 0 0 -10 0 0 0 0 0 0 0 0],[0,0 0 10 0 0 0 -10 0 0 0 0 0 0],[0,0 0 0 0 0 0 0 0 0 0 0 0 -0],'k')
  hold on;
   pbaspect([1,1,1])
   grid on;
 line([p0(1) p1(1),p2(1),p3(1)],[p0(2) p1(2),p2(2),p3(2)],[p0(3) p1(3),p2(3),p3(3)],'LineWidth',2.5)
 plot3([p0(1) p1(1),p2(1),p3(1)],[p0(2) p1(2),p2(2),p3(2)],[p0(3) p1(3),p2(3),p3(3)],'r.')
 
 line([p0(1),p0x(1)],[p0(2),p0x(2)],[p0(3),p0x(3)],'Color','red','LineWidth',1)
 
 line([p0(1),p0y(1)],[p0(2),p0y(2)],[p0(3),p0y(3)],'Color','green','LineWidth',1)
 line([p0(1),p0z(1)],[p0(2),p0z(2)],[p0(3),p0z(3)],'Color','blue','LineWidth',1)
 line([p1(1),p1x(1)],[p1(2),p1x(2)],[p1(3),p1x(3)],'Color','red','LineWidth',1)
 line([p1(1),p1y(1)],[p1(2),p1y(2)],[p1(3),p1y(3)],'Color','green','LineWidth',1)
 line([p1(1),p1z(1)],[p1(2),p1z(2)],[p1(3),p1z(3)],'Color','blue','LineWidth',1)
line([p2(1),p2x(1)],[p2(2),p2x(2)],[p2(3),p2x(3)],'Color','red','LineWidth',1)
 line([p2(1),p2y(1)],[p2(2),p2y(2)],[p2(3),p2y(3)],'Color','green','LineWidth',1)
 line([p2(1),p2z(1)],[p2(2),p2z(2)],[p2(3),p2z(3)],'Color','blue','LineWidth',1)
 line([p3(1),p3x(1)],[p3(2),p3x(2)],[p3(3),p3x(3)],'Color','red','LineWidth',1)
 line([p3(1),p3y(1)],[p3(2),p3y(2)],[p3(3),p3y(3)],'Color','green','LineWidth',1)
 line([p3(1),p3z(1)],[p3(2),p3z(2)],[p3(3),p3z(3)],'Color','blue','LineWidth',1)
 
daspect([1,1,1])

end