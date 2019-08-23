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

  
  


 
 