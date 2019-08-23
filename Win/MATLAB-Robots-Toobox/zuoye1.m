%末端直线运动，在障碍点处做圆弧运动
clc;clear;
L1 = Link('d', 0, 'a', 0, 'alpha', pi/2);
L2 = Link('d', 0, 'a', 0.4318, 'alpha', 0);
L3 = Link('d', 0.15005, 'a', 0.0203, 'alpha', -pi/2);
L4 = Link('d', 0.4318, 'a', 0, 'alpha', pi/2);
L5 = Link('d', 0, 'a', 0.2, 'alpha', -pi/2);
bot = SerialLink([L1 L2 L3 L4 L5], 'name', 'my robot');
T1 = transl(0.2, -0.3, 0.0);
T2 = transl(0.4, 0.3, 0.2);
Tx = transl(0.3, 0.0, 0.1);
T = ctraj(T1, T2, 50);
%判断离障碍点的距离
index1=0;index2=0;%待修正轨迹的起点和终点
for i=1:1:50
    d=sqrt((T(1,4,i)-0.3).^2+(T(2,4,i)-0).^2+(T(3,4,i)-0.1).^2);
    if(d<0.014)
        if index1==0
           index1=i;
        end
        index2=i;
     end
end
%替换成圆弧
n=[0 1 -3]; %法向量n（与直线叉积为0即可）
r=0.014; %圆的半径为1
c=[0.3, 0.0, 0.1]; %圆心的坐标
theta1=pi/10;
theta=(theta1:pi/20:theta1+pi)'; %theta角从0到2*pi
a=cross(n,[1 0 0]); %n与i叉乘，求取a向量
if ~any(a) %如果a为零向量，将n与j叉乘
    a=cross(n,[0 1 0]);
end
b=cross(n,a); %求取b向量
a=a/norm(a); %单位化a向量
b=b/norm(b); %单位化b向量
c1=c(1)*ones(size(theta,1),1);
c2=c(2)*ones(size(theta,1),1);
c3=c(3)*ones(size(theta,1),1);
x=c1+r*a(1)*cos(theta)+r*b(1)*sin(theta);%圆上各点的x坐标
y=c2+r*a(2)*cos(theta)+r*b(2)*sin(theta);%圆上各点的y坐标
z=c3+r*a(3)*cos(theta)+r*b(3)*sin(theta);%圆上各点的z坐标
TT=T(:,:,1:index1-1);%TT赋值前一段线段
for i =1:1:size(x,1)%TT赋值圆弧段
    TT(:,:,index1-1+i)=transl(x(i),y(i),z(i));
end
zz=size(TT,3);
for i=1:1:(50-index2)%TT赋值后一段线段
    TT(:,:,zz+i)=T(:,:,index2+i);
end
%逆运动学
q0=[0 0 0 0 0];
M=[1 1 1 1 1 0];
q = ikine(bot,TT,q0,M);
%画出末端轨迹线
T_size=size(TT,3);%姿态数量
bot_end=zeros(T_size,3);%用于存放末端位置
 T_f=bot.fkine(q);%正运动学计算
 for i=1:1:T_size%计算的位姿结果赋值
     tmp=T_f(:,:,i);
     bot_end(i,:)=[tmp(1,4),tmp(2,4),tmp(3,4)];
 end
plot3(bot_end(2:T_size,1),bot_end(2:T_size,2),bot_end(2:T_size,3));%画出轨迹线
 hold on;
 %画出障碍点
plot3(0.3 ,0 ,0.1,'r*');
 hold on;
 %画出运动过程
bot.plot(q);
