addpath('mr')
global L1
global L2
global L3
L1 = 2;
L2 = 2;
L3 = 2;

B1  = [0 1 0 L1+L2 0 0 ]';
B2  = [0 1 0 L1 0 0 ]';
B3  = [0 1 0 0  0 0 ]';
Blist = [B1,B2,B3];
M = [1 0 0 0; 0 1 0 0 ; 0 0 1 L1+L2+L3; 0 0 0 1];

sampling_freq = 100;
Tf = 2
N = sampling_freq*Tf
Xstart = [     1     0     0     0;...
     0     1     0     0;...
     0     0     1     6;...
     0     0     0     1];
 dd =pi/2
Xend = [     0 0 1      2;...
             0 1 0     0;...
             -1 0 0    4;...
     0     0     0     1];
Xd_list = ScrewTrajectory(Xstart, Xend, Tf, N, 3)
n = 1;
phi = 0;
x = 0;
y = 0;
thetalist = [0,0,0]';
q = [phi,x,y];
dt = 1/sampling_freq;
prev_Xd = Xd_list{1};
sum_Xerr = zeros(6,1);
Xerr = se3ToVec(MatrixLog6(TransInv(Xstart)*Xd_list{1}));
Kp = 50*eye(6)
Ki = 0*eye(6);
for tproc = linspace(0,Tf,N)
    Xd = Xd_list{n};
    dXd = (prev_Xd - Xd)/dt;
    Vd_ =TransInv(Xd)*dXd;
    Vd = se3ToVec(Vd_);
    
    drawArm(eye(4),thetalist);
    T0e = FKinBody(M,Blist,thetalist)
    
    Jarm = JacobianArm(Blist,thetalist);

    X = T0e;
    Xerr = se3ToVec(MatrixLog6(TransInv(X)*Xd))
    V = Adjoint(TransInv(X)*Xd)*Vd+Kp*Xerr+Ki*sum_Xerr;
    dthetalist = pinv(Jarm)*V;
    thetalist(1) = thetalist(1)+dt*dthetalist(1);
    thetalist(2) = thetalist(2)+dt*dthetalist(2);
    thetalist(3) = thetalist(3)+dt*dthetalist(3);
%     thetalist = [thetalist(1)+dthetalist(1)*dt,thetalist(2)+dthetalist(2)*dt,thetalist(3)+dthetalist(3)*dt]
    
    
    prev_Xd = Xd;
    sum_Xerr = sum_Xerr + Xerr;
    n = n+1
end