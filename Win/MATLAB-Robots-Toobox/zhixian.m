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