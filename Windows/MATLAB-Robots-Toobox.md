---
title: MATLAB Robots Toobox
author: liuly
date: 2020-03-06 16:48:14
categories:
- Windows
typora-root-url: ../..
---

# 安装

1. [主页](http://petercorke.com/wordpress/toolboxes/robotics-toolbox)
2. R2014a安装的是RTB 9.10
3. 解压，把`rvctools`文件夹放到`C:\Program Files\MATLAB\R2014a\toolbox`
4. 打开MATLAB>设置路径>添加并包含子文件夹>选中`rvctools`文件夹>保存

### demo

```matlab
rtbdemo
```

或者查看`C:\Program Files\MATLAB\R2014a\toolbox\rvctools\robot\demos`和`C:\Program Files\MATLAB\R2014a\toolbox\rvctools\robot\examples`

# 示例

### 画圆

```matlab
n=[1 1 1]; %法向量n
r=1; %圆的半径为1
c=[1 1 1]; %圆心的坐标
theta=(0:2*pi/100:2*pi)'; %theta角从0到2*pi
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

plot3(x,y,z)
xlabel('x轴')
ylabel('y轴')
zlabel('z轴')
```

### robot1

```matlab
L1 = 0.1; L2 = 0.1;

% 基于D-H参数创建腿关节
%                    theta   d     a  alpha  
links(1) = Link([    0       0    0   pi/2 ], 'standard');
links(2) = Link([    0       0    L1   0   ], 'standard');
links(3) = Link([    0       0   -L2   0   ], 'standard');

% 现在创建一个机器人来代表一条腿
leg = SerialLink(links, 'name', 'leg', 'offset', [pi/2   0  -pi/2]);

% 定义步态轨迹的关键参数，沿x方向行走
xf = 5; xb = -xf;   % 脚踏在地面上的前后限制
y = 5;              % 脚与身体沿y轴的距离
zu = 2; zd = 5;     % 上下时脚的高度
% 定义脚所采用的矩形路径
segments = [xf y zd; xb y zd; xb y zu; xf y zu] * 0.01;
segments = [segments; segments];%pose列表
tseg = [3 0.25 0.5 0.25]';
tseg = [1; tseg; tseg];
x = mstraj(segments, [], tseg, segments(1,:), 0.01, 0.1);
%   TRAJ = MSTRAJ(P, QDMAX, TSEG, Q0, DT, TACC, OPTIONS)
%   多段多轴轨迹
% -  P（MxN）是通过点的矩阵，每个通过点1行，每个轴一列。最后一个点是目的地。
% -  QDMAX（1xN）是轴速限制，不能超过，
% -  TSEG（1xM）是每个K段的持续时间
% -  Q0（1xN）是初始坐标
% -  DT是时间步长
% -  TACC（1x1）此加速时间应用于所有段转换
% - 每个段的TACC（1xM）加速时间，TACC（i）是从段i到段i + 1的转换的加速时间。 TACC（1）也是段1开始时的加速时间。
xcycle = x(100:500,:);
qcycle = leg.ikine( transl(xcycle), [], [1 1 1 0 0 0], 'pinv' );

%机器人身体的矩形，宽度和高度尺寸，腿在每个角落。
W = 0.1; L = 0.2;
% 一点优化。我们使用了很多绘图选项来快速制作动画：关闭注释，如手腕轴、地面阴影、关节轴，没有平滑的阴影。
%我们不是在每个循环中解析开关，而是在这里将它们预分解为一个plotop结构。 

plotopt = {'noraise', 'nobase', 'noshadow', 'nowrist', 'nojaxes', 'delay', 0};

% 创建4条腿的机器人。每一个都是我们在上面构建的腿部机器人的克隆体，
%有一个独特的名称，以及一个表示它在行走机器人身体上位置的基本变换。
legs(1) = SerialLink(leg, 'name', 'leg1');
legs(2) = SerialLink(leg, 'name', 'leg2', 'base', transl(-L, 0, 0));
legs(3) = SerialLink(leg, 'name', 'leg3', 'base', transl(-L, -W, 0)*trotz(pi));
legs(4) = SerialLink(leg, 'name', 'leg4', 'base', transl(0, -W, 0)*trotz(pi));

% 为机器人创建固定大小的轴，并将Z正向向下设置
clf; axis([-0.3 0.1 -0.2 0.2 -0.15 0.05]); set(gca,'Zdir', 'reverse')
hold on
% 画出机器人的身体
% patch是个底层的图形函数，用来创建补片图形对象。
%一个补片对象是由其顶点坐标确定的一个或多个多边形。用户可以指定补片对象的颜色和灯光。
patch([0 -L -L 0], [0 0 -W -W], [0 0 0 0], ...
    'FaceColor', 'r', 'FaceAlpha', 0.5)
% 在轴上实例化每个机器人
for i=1:4
    legs(i).plot(qcycle(1,:), plotopt{:});
end
hold off

% walk!
k = 1;
%A = Animate('walking');
%while 1
for i=1:500
    legs(1).animate( gait(qcycle, k, 0,   0));
    legs(2).animate( gait(qcycle, k, 100, 0));
    legs(3).animate( gait(qcycle, k, 200, 1));
    legs(4).animate( gait(qcycle, k, 300, 1));
    drawnow
    k = k+1;
    %A.add();
end
```

### robot2

```matlab

%串行链接操纵器包括一系列链接。 每个Link由四个D-H参数描述。
%让我们定义一个简单的2链接操纵器。 第一个Link是（Link的参数为d、a、alpha）
L1 = Link('d', 1, 'a', 2, 'alpha', pi/2);
%可以这样引用或定义：
%L1.a;

% 我们确定它是一个旋转关节
L1.isrevolute

% 对于给定的关节角度，假设q=0.2 rad，我们可以确定链接变换矩阵
L1.A(0.2)

% 第二个Link
L2 = Link('d', 3, 'a', 4, 'alpha', 0)

% 第三个Link
L3 = Link('d', 2, 'a', 3, 'alpha', 0)

% 现在我们需要将它们连接到一个串行链接机器人操纵器
bot = SerialLink([L1 L2 L3], 'name', 'my robot')
% 显示的机器人对象显示了很多细节。它还具有许多特性，例如关节数
bot.n

% 机器人的正向运动学
bot.fkine([0.2 0.3 0.4])


% 最后我们可以画出我们机器人的简笔画
bot.plot([0.4 0.5 0.6])

```

### baxter1

```matlab
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
```

### baxter2

```matlab
clc;clear;
%加载机器人模型
mdl_baxter;
bot_left = left;
bot_right = right;

%显示（关节角度都是0）
left_theta = [0 0 0 0 0 0 0];
right_theta = [0 0 0 0 0 0 0];
bot_left.plot(left_theta);
hold on;
bot_right.plot(right_theta);

%正运动学（齐次变换）
disp('左手末端位姿：');
left_p0=bot_left.fkine(left_theta)

%关节状态插值
t = [0:0.05:1];%时间
%qz、qr、qs、qn是已经定义好的关节状态
%left_path是关节状态的插值，形成连贯动作
q1=[0.1 0.2 0.3 0.4 0.5 0.6 0.7];
q2=[0.3 0.4 0.5 0.6 0.7 0.3 0.2];
q3=[0.5 0.6 0.7 0.1 0.5 0.9 1.0];
left_path = jtraj(qz,qr,t);
left_path= [left_path;jtraj(q1,q2,t)];
left_path= [left_path;jtraj(q2,q3,t)];
left_path= [left_path;jtraj(q3,q1,t)];

for q = left_path'
    hold on;
    left.plot(q');
    hold on;
    right.plot(q');
end
```

### 避障

```matlab
%末端直线运动，并避开障碍点
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
for i=1:1:50
    d=sqrt((T(1,4,i)-0.3).^2+(T(2,4,i)-0).^2+(T(3,4,i)-0.1).^2);
 if(d<0.014)
     T(1,4,i)=T(1,4,i)+sqrt(0.0002-d.^2);
     T(2,4,i)=T(2,4,i)+sqrt(0.0002-d.^2);
     T(3,4,i)=T(3,4,i)+sqrt(0.0002-d.^2);
 end
end

q0=[0 0 0 0 0];
M=[1 1 1 1 1 0];
q = ikine(bot,T,q0,M);

aplot=zeros(50,3);
 aa=bot.fkine(q);
 for i=1:1:50
     aaa=aa(:,:,i);
     aplot(i,:)=[aaa(1,4),aaa(2,4),aaa(3,4)];
 end
plot3(aplot(2:50,1),aplot(2:50,2),aplot(2:50,3) );
 hold on;
bot.plot(q);
hold on
plot3(0.3 ,0 ,0.1,'r*');
```

### w3

```matlab
%单机械臂末端直线运动，并避开障碍点使用pid控制方法
clc;
clear;
L1 = Link('d', 0, 'a', 0, 'alpha', pi/2);
L2 = Link('d', 0, 'a', 0.4318, 'alpha', 0);
L3 = Link('d', 0.11505, 'a', 0.0203, 'alpha', -pi/2);
L4 = Link('d', 0.4318, 'a', 0, 'alpha', pi/2);
L5 = Link('d', 0, 'a', 0.2, 'alpha', -pi/2);

r1 = SerialLink([L1 L2 L3 L4 L5], 'name', '机械臂1');

T1 = transl(0.2, -0.3, 0.0);        %起始坐标矩阵
T2 = transl(0.6, 0.3, 0.2);         %终点坐标矩阵
Tx = transl(0.3, 0.0, 0.1);         %假定中点为障碍，需要绕过
T = ctraj(T1, T2, 150);              % 直线轨迹规划，150个控制点

kp=1;
ki=0.7;
kd=0; 
sum=0;

d1 = zeros(150,1);
%d2 = zeros(150,1);
d3 = zeros(150,1);

d4 = zeros(150,1);          %存储误差量
 
 for i=1:1:150
    d=sqrt((T(1,4,i)-0.6).^2+(T(2,4,i)-0).^2+(T(3,4,i)-0.1).^2);
    d1(i,:) = d;  %记录整个规划过程距离障碍物距离
    
    if(d <= 0.07)
        d3(i,:) = i;            %存在障碍物的范围
    end
 end
d3(d3==0) = [];  
[m1,n1] = size(d3);
m2 = d3(1,:);
m3 = d3(m1,:);          %108-153障碍物范围

% d2 = zeros(m1+1,1);     %创建空向量，存储避障信息
 
 
for i=1:1:150
      
 if((m2<= i)&&(i <= m3))             %进入避障过程
    d=sqrt((T(1,4,i)-0.6).^2+(T(2,4,i)-0).^2+(T(3,4,i)-0.1).^2);
    n1 = [0.04,-0.02,0];                 %方向向量
    n2 = [-0.04,0.02,0]; 
    error = d - 0.07;                                   % 误差 输入-输出
    
    d1(i,:) = d;        %距障碍距离
    
    d4(i,:)=error;
    
    if(error <= 0)           %内
%        d2(1,:) = 0;
%        d2(i-m2+2,:) = error;
%        delta = d2(i-m2+2,:)-d2(i-m2+1,:);    
%        sum = sum + error;
%        out=(kp*error+ki*sum+kd*delta)*n;          
         sum = sum + error;
         out=(kp*error+ki*sum)*n1;
%          T(1,4,i)=T(1,4,i)+out(1);
%          T(2,4,i)=T(2,4,i)+out(2);
%          T(3,4,i)=T(3,4,i)+out(3);            %修正
    end
    
    if(error > 0)           %外
         sum = sum + error;
         out=(kp*error+ki*sum)*n2;
%          T(1,4,i)=T(1,4,i)+out(1);
%          T(2,4,i)=T(2,4,i)+out(2);
%          T(3,4,i)=T(3,4,i)+out(3);           
    end
    
    T(1,4,i+1)=T(1,4,i)+out(1);
    T(2,4,i+1)=T(2,4,i)+out(2);
    T(3,4,i+1)=T(3,4,i)+out(3);   %将修正后的点储存              
 end

end

q0=[0 0 0 0 0];
M=[1 1 1 1 1 0];
theta = ikine(r1,T,q0,M);        %反向运动学，关节角度矩阵

aplot=zeros(150,3);
aa=r1.fkine(theta);                     %正解，末端姿态坐标矩阵

 for i=1:1:150
    position = transl(aa);          %末端空间坐标矩阵（xyz）
    aplot(i,:)=[position(i,1),position(i,2),position(i,3)]; 
 end
 
 plot3(aplot(:,1),aplot(:,2),aplot(:,3),'LineWidth',2 ); 
 hold on;
 plot3(0.6 ,0 ,0.1,'r*');
 hold on;
 r1.plot(theta);
 hold on
  
 figure(2);
 plot(d1,'b');
 title('末端距障碍物距离');
 hold on;
 
 figure(3);
 plot(d4,'r');
 title('理想轨迹误差');
```

### 匀减速

```matlab
%匀加速运动
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


t = [0:0.01:1];
[,len]=length(t);
path=zeros(len,7);
a1=2*(qr(1,2)-qz(1,2));%角加速度
a2=2*(qr(1,3)-qz(1,3));
ddd=zeros(len,3);
bbb=zeros(len,3);
for i = 1:1:len
    tt=t(1,i);
    q=[0 (a1*tt*tt)/2 (a2*tt*tt)/2 0 0 0 0];%每过1/100s更新的角度量
    path(i,:)=q;
    zz=left.fkine(q);
   ddd(i,:)=[zz(1,4),zz(2,4),zz(3,4)];
    xx=right.fkine(q);
   bbb(i,:)=[xx(1,4),xx(2,4),xx(3,4)];
end
plot3(ddd(:,1),ddd(:,2),ddd(:,3));
hold on;
plot3(bbb(:,1),bbb(:,2),bbb(:,3));
hold on;
% plot(t,path(:,2));
% figure(2);
for q = path'
    hold on;
    left.plot(q');
    hold on;
    right.plot(q');
end
```

### 匀速

```matlab
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
```

### 直线

```matlab
%末端直线运动
clc;clear;
L1 = Link('d', 0, 'a', 0, 'alpha', pi/2);
L2 = Link('d', 0, 'a', 0.4318, 'alpha', 0);
L3 = Link('d', 0.15005, 'a', 0.0203, 'alpha', -pi/2);
L4 = Link('d', 0.4318, 'a', 0, 'alpha', pi/2);
L5 = Link('d', 0, 'a', 0.2, 'alpha', -pi/2);
bot = SerialLink([L1 L2 L3 L4 L5], 'name', 'my robot');
T1 = transl(0.2, -0.3, 0.0);
T2 = transl(0.4, 0.3, 0.2);
T = ctraj(T1, T2, 50);
q0=[0 0 0 0 0];
M=[1 1 1 1 1 0];
q = ikine(bot,T,q0,M);

aplot=zeros(50,3);
 aa=bot.fkine(q);
 for i=1:1:50
     aaa=aa(:,:,i);
     aplot(i,:)=[aaa(1,4),aaa(2,4),aaa(3,4)];
 end
plot3(aplot(2:50,1),aplot(2:50,2),aplot(2:50,3) );
 hold on;
bot.plot(q);
```

### 作业1

```matlab
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
```

### 作业2

```matlab
clc;clear;
L1 = Link('d', 0, 'a', 0, 'alpha', pi/2);
L2 = Link('d', 0, 'a', 0.4318, 'alpha', 0);
L3 = Link('d', 0.15005, 'a', 0.0203, 'alpha', -pi/2);
L4 = Link('d', 0.4318, 'a', 0, 'alpha', pi/2);
L5 = Link('d', 0, 'a', 0.2, 'alpha', -pi/2);
bot = SerialLink([L1 L2 L3 L4 L5], 'name', 'my robot');
%目标轨迹是一条线段
T1 = transl(0.2, -0.3, 0.0);%起始点
T2 = transl(0.4, 0.3, 0.2);%目标点
%障碍轨迹是穿过目标轨迹的线段，障碍点沿障碍点轨迹匀速穿过目标轨迹
T3 = transl(0.28, 0.01, 0.1);%障碍起始点
T4 = transl(0.32, -0.01, 0.1);%障碍目标点
%假设时间序列有120个
%障碍轨迹线，来回运动
Tb=ctraj(T4,T3,20);
Tb2=ctraj(T3,T4,20);
Tb3=ctraj(T4,T3,20);
Tb4=ctraj(T3,T4,20);
Tb5=ctraj(T4,T3,20);
Tb6=ctraj(T3,T4,20);
for i=1:1:20
    Tb(:,:,20+i)=Tb2(:,:,i);
end
for i=1:1:20
    Tb(:,:,40+i)=Tb3(:,:,i);
end
for i=1:1:20
    Tb(:,:,60+i)=Tb4(:,:,i);
end
for i=1:1:20
    Tb(:,:,80+i)=Tb5(:,:,i);
end
for i=1:1:20
    Tb(:,:,100+i)=Tb6(:,:,i);
end
 Tb_size=size(Tb,3);
 for i=1:1:Tb_size
     tmp=Tb(:,:,i);
     Tb_end(i,:)=[tmp(1,4),tmp(2,4),tmp(3,4)];
 end
%目标轨迹线
 T=ctraj(T1,T2,120);
 
 %避障过程
 Kp=8;
 Ki=0.3;
 sum=0;%pid的积分项
 for i=1:1:120
    d=sqrt((T(1,4,i)-Tb(1,4,i)).^2+(T(2,4,i)-Tb(2,4,i)).^2+(T(3,4,i)-Tb(3,4,i)).^2);%末端离障碍点的距离
    if(d<0.06)
        n=[0.04,-0.02,0];%避障方向向量
        %pid控制，跟踪量为以障碍点为圆心的球体面
        error=d-0.06;
        sum=sum+error;
        out=(Kp*error+Ki*sum)*n;
        T(1,4,i)=T(1,4,i)+out(1);
        T(2,4,i)=T(2,4,i)+out(2);
        T(3,4,i)=T(3,4,i)+out(3);
     end
end
 
%逆运动学解算
q0=[0 0 0 0 0];
M=[1 1 1 1 1 0];
q = ikine(bot,T,q0,M);

%显示机械臂和障碍物的运动过程
for i=1:1:119
    %hold off;
    bot.plot(q(i,:));
    plot3(Tb_end(i,1),Tb_end(i,2),Tb_end(i,3) ,'r*');
end
hold on;
bot.plot(q(120,:));
plot3(Tb_end(120,1),Tb_end(120,2),Tb_end(120,3) ,'r*');

%画出末端曲线
T_end=zeros(size(T,3),3);
 T_f=bot.fkine(q);
 for i=1:1:size(T,3)
     tmp=T_f(:,:,i);
     T_end(i,:)=[tmp(1,4),tmp(2,4),tmp(3,4)];
 end
plot3(T_end(2:size(T,3),1),T_end(2:size(T,3),2),T_end(2:size(T,3),3) );
plot3(Tb_end(2:size(T,3),1),Tb_end(2:size(T,3),2),Tb_end(2:size(T,3),3),'r' );
 hold on;
```