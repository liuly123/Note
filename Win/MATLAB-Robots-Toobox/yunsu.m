%匀速运动
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
qz = [0 0 -pi/2 0 0 0 0]; 
qr = [0 -pi/2 0 0 0 0 0]; 
qs = [0 0 -pi/2 0 0 0 0];
qn = [0 pi/4 pi/2 0 pi/4  0 0];


t = [0:0.01:1];
[,len]=length(t);
path=zeros(len,7);
a1=(qr(1,2)-qz(1,2))/len;%角速度
a2=(qr(1,3)-qz(1,3))/len;
for i = 1:1:len
    q=[0 a1*i a2*i 0 0 0 0];%每过1/100s更新的角度量
    path(i,:)=q;
    %path= [path;q];
end
for q = path'
    hold on;
    left.plot(q');
    hold on;
    right.plot(q');
end
figure(2);
plot(t,path(:,2));

    
    