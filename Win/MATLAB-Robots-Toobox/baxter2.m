clc;clear;
%���ػ�����ģ��
mdl_baxter;
bot_left = left;
bot_right = right;

%��ʾ���ؽڽǶȶ���0��
left_theta = [0 0 0 0 0 0 0];
right_theta = [0 0 0 0 0 0 0];
bot_left.plot(left_theta);
hold on;
bot_right.plot(right_theta);

%���˶�ѧ����α任��
disp('����ĩ��λ�ˣ�');
left_p0=bot_left.fkine(left_theta)

%�ؽ�״̬��ֵ
t = [0:0.05:1];%ʱ��
%qz��qr��qs��qn���Ѿ�����õĹؽ�״̬
%left_path�ǹؽ�״̬�Ĳ�ֵ���γ����ᶯ��
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