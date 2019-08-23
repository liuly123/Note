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