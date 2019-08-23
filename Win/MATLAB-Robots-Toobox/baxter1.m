clc;clear;
links = [
        Revolute('d', 0.27,        'a', 0.069, 'alpha', -pi/2)
        Revolute('d', 0,           'a', 0, 'alpha', pi/2, 'offset', pi/2)
        Revolute('d', 0.102+0.262, 'a', 0.069, 'alpha', -pi/2)
        Revolute('d', 0,           'a', 0, 'alpha', pi/2)
        Revolute('d', 0.103+0.271, 'a', 0.010, 'alpha', -pi/2)
        Revolute('d', 0,           'a', 0, 'alpha', pi/2)
        Revolute('d', 0.28,        'a', 0, 'alpha', 0)
];

left =  SerialLink(links, 'name', 'Baxter LEFT', 'manufacturer', 'Rethink Robotics');
right = SerialLink(links, 'name', 'Baxter RIGHT', 'manufacturer', 'Rethink Robotics');

left.base = transl(0.064614, 0.25858, 0.119)*rpy2tr(0, 0, pi/4, 'xyz');
right.base = transl(0.063534, -0.25966, 0.119)*rpy2tr(0, 0, -pi/4, 'xyz');

%4个不同姿态的关节角
qz = [0 0 0 0 0 0 0]; 
qr = [0 -pi/2 -pi/2 0 0 0 0]; 
qs = [0 0 -pi/2 0 0 0 0];
qn = [0 pi/4 pi/2 0 pi/4  0 0];

% left.plot(qz);
% hold on;
% right.plot(qz);

t = [0:0.05:1];
path = jtraj(qz,qr,t);
%计算两种配置之间的关节空间轨迹
path= [path;jtraj(qr,qs,t)];
path= [path;jtraj(qs,qn,t)];
path= [path;jtraj(qn,qz,t)];
for q = path'
    hold on;
    left.plot(q');
    hold on;
    right.plot(q');
end
a=0;
for i = 1:1:20
    a=[a;(path(i+1,2)-path(i,2))/0.05];
end
plot(t,a, 'r');
hold on;    
plot(t,path(:,2));