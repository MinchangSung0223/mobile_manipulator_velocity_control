addpath('mr')
clear;

global L1
global L2
global L3
L1 = 2;
L2 = 2;
L3 = 2;

B1  = [0 1 0 L1+L2 0 0 ]';
B2  = [0 1 0 L1 0 0 ]';
B3  = [0 1 0 0  0 0 ]';
S1 = [0 1 0 0 0 0]';
S2 = [0 1 0 -L1 0 0]';
S3 = [0 1 0 -L1-L2 0 0]';
Slist = [S1,S2,S3];
Blist = [B1,B2,B3];
M = [1 0 0 0; 0 1 0 0 ; 0 0 1 L1+L2+L3; 0 0 0 1];

sampling_freq = 1000;
Tf = 2
N = sampling_freq*Tf

n = 1;
phi = 0;
x = 0;
y = 0;
z=0;
thetalist = [0.001,0.001,0.001]';
q = [phi,x,y]';
dt = 1/sampling_freq;
sum_Xerr = zeros(6,1);
Tsb = [cos(q(1)) -sin(q(1)) 0 q(2);...
     sin( q(1)) cos( q(1)) 0 q(3);...
     0 0 1 z;...
     0 0 0 1];
 Tb0 = [1 0 0 3; 0 1 0 0; 0 0 1 0; 0 0 0 1];
Xstart = Tsb*Tb0*FKinSpace(M,Slist,thetalist)
 dd =pi/6
Xend = [     cos(dd)     0     sin(dd)     10;...
                   0    1     0     5;...
             -sin(dd)     0     cos(dd)     4;...
     0     0     0     1];

Xd_list = ScrewTrajectory(Xstart, Xend, Tf, N, 5)
prev_Xd = Xd_list{1};

Xerr = se3ToVec(MatrixLog6(TransInv(Xstart)*Xd_list{1}));
Kp = [400 0 0 0 0 0;...
      0 400 0 0 0 0;...
      0 0 400 0 0 0;...
      0 0 0 400 0 0;...
      0 0 0 0 400 0;...
      0 0 0 0 0 400]
Ki = [10 0 0 0 0 0;...
      0 10 0 0 0 0;...
      0 0 10 0 0 0;...
      0 0 0 10 0 0;...
      0 0 0 0 10 0;...
      0 0 0 0 0 10]
 u = [q;thetalist];
 du =[0,0,0,0,0,0]';
 data = []
for tproc = linspace(0,Tf,N)
    Xd = Xd_list{n};
    dXd = (prev_Xd - Xd)/dt;
    Vd_ =TransInv(Xd)*dXd;
    Vd = se3ToVec(Vd_);

    z = 0;
    Tsb = [cos(q(1)) -sin(q(1)) 0 q(2);...
     sin( q(1)) cos( q(1)) 0 q(3);...
     0 0 1 z;...
     0 0 0 1];
    
    Tb0 = [1 0 0 3; 0 1 0 0; 0 0 1 0; 0 0 0 1];
    Ts0 = Tsb*Tb0;
    if mod(n,10) ==0
        drawArm(Ts0,thetalist);
        drawMobile(Tsb);
    end
    
    T0e = FKinSpace(M,Slist,thetalist)
    
    Jarm = JacobianArm(Blist,thetalist);
    Jbase = JacobianBase(thetalist,q,T0e,Tb0);
    Je = [Jbase , Jarm];
    X = Tsb*Tb0*T0e;
    Xerr = se3ToVec(MatrixLog6(TransInv(X)*Xd))
    V = Adjoint(TransInv(X)*Xd)*Vd+Kp*Xerr+Ki*sum_Xerr;
    du = pinv(Je)*V;
    u = u+dt*du;
    q = [u(1);u(2);u(3)];
    thetalist = [u(4);u(5);u(6)];
    Tse = Tsb*Tb0*T0e
    prev_Xd = Xd;
    sum_Xerr = sum_Xerr + Xerr;
   data(1,n) = tproc;
   data(2,n) = Xerr(1);
   data(3,n) = Xerr(2);
   data(4,n) = Xerr(3);
   data(5,n) = Xerr(4);
   data(6,n) = Xerr(5);
   data(7,n) = Xerr(6);
   data(8,n) = X(1,4);
   data(9,n) = X(2,4);
   data(10,n) =X(3,4);

    n = n+1
end
figure;
plot(data(1,:),data(2,:))
hold on;
plot(data(1,:),data(3,:))
plot(data(1,:),data(4,:))
plot(data(1,:),data(5,:))
plot(data(1,:),data(6,:))
plot(data(1,:),data(7,:))
legend('wx','wy','wz','vx','vy','vz')
figure
subplot(3,1,1)
plot(data(1,:),data(8,:))
hold on;
plot(data(1,:),Xend(1,4)*ones(size(data(1,:))),"r")
axis([0,Tf,-1,Xend(1,4)+1])
subplot(3,1,2)
plot(data(1,:),data(9,:))
hold on;
plot(data(1,:),Xend(2,4)*ones(size(data(1,:))),"r")
axis([0,Tf,-1,Xend(2,4)+1])

subplot(3,1,3)
plot(data(1,:),data(10,:))
hold on;
plot(data(1,:),Xend(3,4)*ones(size(data(1,:))),"r")
axis([0,Tf,-1,Xend(3,4)+1])


