clc;clear;
L1 = Link('d', 0, 'a', 0, 'alpha', pi/2);
L2 = Link('d', 0, 'a', 0.4318, 'alpha', 0);
L3 = Link('d', 0.15005, 'a', 0.0203, 'alpha', -pi/2);
L4 = Link('d', 0.4318, 'a', 0, 'alpha', pi/2);
L5 = Link('d', 0, 'a', 0.2, 'alpha', -pi/2);
bot = SerialLink([L1 L2 L3 L4 L5], 'name', 'my robot');
%Ŀ��켣��һ���߶�
T1 = transl(0.2, -0.3, 0.0);%��ʼ��
T2 = transl(0.4, 0.3, 0.2);%Ŀ���
%�ϰ��켣�Ǵ���Ŀ��켣���߶Σ��ϰ������ϰ���켣���ٴ���Ŀ��켣
T3 = transl(0.28, 0.01, 0.1);%�ϰ���ʼ��
T4 = transl(0.32, -0.01, 0.1);%�ϰ�Ŀ���
%����ʱ��������120��
%�ϰ��켣�ߣ������˶�
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
%Ŀ��켣��
 T=ctraj(T1,T2,120);
 
 %���Ϲ���
 Kp=8;
 Ki=0.3;
 sum=0;%pid�Ļ�����
 for i=1:1:120
    d=sqrt((T(1,4,i)-Tb(1,4,i)).^2+(T(2,4,i)-Tb(2,4,i)).^2+(T(3,4,i)-Tb(3,4,i)).^2);%ĩ�����ϰ���ľ���
    if(d<0.06)
        n=[0.04,-0.02,0];%���Ϸ�������
        %pid���ƣ�������Ϊ���ϰ���ΪԲ�ĵ�������
        error=d-0.06;
        sum=sum+error;
        out=(Kp*error+Ki*sum)*n;
        T(1,4,i)=T(1,4,i)+out(1);
        T(2,4,i)=T(2,4,i)+out(2);
        T(3,4,i)=T(3,4,i)+out(3);
     end
end
 
%���˶�ѧ����
q0=[0 0 0 0 0];
M=[1 1 1 1 1 0];
q = ikine(bot,T,q0,M);

%��ʾ��е�ۺ��ϰ�����˶�����
for i=1:1:119
    %hold off;
    bot.plot(q(i,:));
    plot3(Tb_end(i,1),Tb_end(i,2),Tb_end(i,3) ,'r*');
end
hold on;
bot.plot(q(120,:));
plot3(Tb_end(120,1),Tb_end(120,2),Tb_end(120,3) ,'r*');

%����ĩ������
T_end=zeros(size(T,3),3);
 T_f=bot.fkine(q);
 for i=1:1:size(T,3)
     tmp=T_f(:,:,i);
     T_end(i,:)=[tmp(1,4),tmp(2,4),tmp(3,4)];
 end
plot3(T_end(2:size(T,3),1),T_end(2:size(T,3),2),T_end(2:size(T,3),3) );
plot3(Tb_end(2:size(T,3),1),Tb_end(2:size(T,3),2),Tb_end(2:size(T,3),3),'r' );
 hold on;
 










