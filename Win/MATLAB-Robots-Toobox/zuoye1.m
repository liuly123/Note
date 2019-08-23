%ĩ��ֱ���˶������ϰ��㴦��Բ���˶�
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
%�ж����ϰ���ľ���
index1=0;index2=0;%�������켣�������յ�
for i=1:1:50
    d=sqrt((T(1,4,i)-0.3).^2+(T(2,4,i)-0).^2+(T(3,4,i)-0.1).^2);
    if(d<0.014)
        if index1==0
           index1=i;
        end
        index2=i;
     end
end
%�滻��Բ��
n=[0 1 -3]; %������n����ֱ�߲��Ϊ0���ɣ�
r=0.014; %Բ�İ뾶Ϊ1
c=[0.3, 0.0, 0.1]; %Բ�ĵ�����
theta1=pi/10;
theta=(theta1:pi/20:theta1+pi)'; %theta�Ǵ�0��2*pi
a=cross(n,[1 0 0]); %n��i��ˣ���ȡa����
if ~any(a) %���aΪ����������n��j���
    a=cross(n,[0 1 0]);
end
b=cross(n,a); %��ȡb����
a=a/norm(a); %��λ��a����
b=b/norm(b); %��λ��b����
c1=c(1)*ones(size(theta,1),1);
c2=c(2)*ones(size(theta,1),1);
c3=c(3)*ones(size(theta,1),1);
x=c1+r*a(1)*cos(theta)+r*b(1)*sin(theta);%Բ�ϸ����x����
y=c2+r*a(2)*cos(theta)+r*b(2)*sin(theta);%Բ�ϸ����y����
z=c3+r*a(3)*cos(theta)+r*b(3)*sin(theta);%Բ�ϸ����z����
TT=T(:,:,1:index1-1);%TT��ֵǰһ���߶�
for i =1:1:size(x,1)%TT��ֵԲ����
    TT(:,:,index1-1+i)=transl(x(i),y(i),z(i));
end
zz=size(TT,3);
for i=1:1:(50-index2)%TT��ֵ��һ���߶�
    TT(:,:,zz+i)=T(:,:,index2+i);
end
%���˶�ѧ
q0=[0 0 0 0 0];
M=[1 1 1 1 1 0];
q = ikine(bot,TT,q0,M);
%����ĩ�˹켣��
T_size=size(TT,3);%��̬����
bot_end=zeros(T_size,3);%���ڴ��ĩ��λ��
 T_f=bot.fkine(q);%���˶�ѧ����
 for i=1:1:T_size%�����λ�˽����ֵ
     tmp=T_f(:,:,i);
     bot_end(i,:)=[tmp(1,4),tmp(2,4),tmp(3,4)];
 end
plot3(bot_end(2:T_size,1),bot_end(2:T_size,2),bot_end(2:T_size,3));%�����켣��
 hold on;
 %�����ϰ���
plot3(0.3 ,0 ,0.1,'r*');
 hold on;
 %�����˶�����
bot.plot(q);
