function drawAxis(T)

R = T(1:3,1:3);
tx = T(1:3,4);
px = [1,0,0,1]';
py = [0,1,0,1]';
pz = [0,0,1,1]';

px = T*px;
py = T*py;
pz = T*pz;


line([tx(1) px(1) ],[tx(2) px(2) ],[tx(3) px(3) ],'Color','red')
line([tx(1) py(1) ],[tx(2) py(2) ],[tx(3) py(3) ],'Color','green')
line([tx(1) pz(1) ],[tx(2) pz(2) ],[tx(3) pz(3) ],'Color','blue')
end