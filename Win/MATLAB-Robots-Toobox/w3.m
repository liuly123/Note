%����е��ĩ��ֱ���˶������ܿ��ϰ���ʹ��pid���Ʒ���
clc;
clear;
L1 = Link('d', 0, 'a', 0, 'alpha', pi/2);
L2 = Link('d', 0, 'a', 0.4318, 'alpha', 0);
L3 = Link('d', 0.11505, 'a', 0.0203, 'alpha', -pi/2);
L4 = Link('d', 0.4318, 'a', 0, 'alpha', pi/2);
L5 = Link('d', 0, 'a', 0.2, 'alpha', -pi/2);

r1 = SerialLink([L1 L2 L3 L4 L5], 'name', '��е��1');

T1 = transl(0.2, -0.3, 0.0);        %��ʼ�������
T2 = transl(0.6, 0.3, 0.2);         %�յ��������
Tx = transl(0.3, 0.0, 0.1);         %�ٶ��е�Ϊ�ϰ�����Ҫ�ƹ�
T = ctraj(T1, T2, 150);              % ֱ�߹켣�滮��150�����Ƶ�

kp=1;
ki=0.7;
kd=0; 
sum=0;

d1 = zeros(150,1);
%d2 = zeros(150,1);
d3 = zeros(150,1);

d4 = zeros(150,1);          %�洢�����
 
 for i=1:1:150
    d=sqrt((T(1,4,i)-0.6).^2+(T(2,4,i)-0).^2+(T(3,4,i)-0.1).^2);
    d1(i,:) = d;  %��¼�����滮���̾����ϰ������
    
    if(d <= 0.07)
        d3(i,:) = i;            %�����ϰ���ķ�Χ
    end
 end
d3(d3==0) = [];  
[m1,n1] = size(d3);
m2 = d3(1,:);
m3 = d3(m1,:);          %108-153�ϰ��ﷶΧ

% d2 = zeros(m1+1,1);     %�������������洢������Ϣ
 
 
for i=1:1:150
      
 if((m2<= i)&&(i <= m3))             %������Ϲ���
    d=sqrt((T(1,4,i)-0.6).^2+(T(2,4,i)-0).^2+(T(3,4,i)-0.1).^2);
    n1 = [0.04,-0.02,0];                 %��������
    n2 = [-0.04,0.02,0]; 
    error = d - 0.07;                                   % ��� ����-���
    
    d1(i,:) = d;        %���ϰ�����
    
    d4(i,:)=error;
    
    if(error <= 0)           %��
%        d2(1,:) = 0;
%        d2(i-m2+2,:) = error;
%        delta = d2(i-m2+2,:)-d2(i-m2+1,:);    
%        sum = sum + error;
%        out=(kp*error+ki*sum+kd*delta)*n;          
         sum = sum + error;
         out=(kp*error+ki*sum)*n1;
%          T(1,4,i)=T(1,4,i)+out(1);
%          T(2,4,i)=T(2,4,i)+out(2);
%          T(3,4,i)=T(3,4,i)+out(3);            %����
    end
    
    if(error > 0)           %��
         sum = sum + error;
         out=(kp*error+ki*sum)*n2;
%          T(1,4,i)=T(1,4,i)+out(1);
%          T(2,4,i)=T(2,4,i)+out(2);
%          T(3,4,i)=T(3,4,i)+out(3);           
    end
    
    T(1,4,i+1)=T(1,4,i)+out(1);
    T(2,4,i+1)=T(2,4,i)+out(2);
    T(3,4,i+1)=T(3,4,i)+out(3);   %��������ĵ㴢��              
 end

end

q0=[0 0 0 0 0];
M=[1 1 1 1 1 0];
theta = ikine(r1,T,q0,M);        %�����˶�ѧ���ؽڽǶȾ���

aplot=zeros(150,3);
aa=r1.fkine(theta);                     %���⣬ĩ����̬�������

 for i=1:1:150
    position = transl(aa);          %ĩ�˿ռ��������xyz��
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
 title('ĩ�˾��ϰ������');
 hold on;
 
 figure(3);
 plot(d4,'r');
 title('����켣���');

  
  


 
 