L1 = 0.1; L2 = 0.1;

% ����D-H���������ȹؽ�
%                    theta   d     a  alpha  
links(1) = Link([    0       0    0   pi/2 ], 'standard');
links(2) = Link([    0       0    L1   0   ], 'standard');
links(3) = Link([    0       0   -L2   0   ], 'standard');

% ���ڴ���һ��������������һ����
leg = SerialLink(links, 'name', 'leg', 'offset', [pi/2   0  -pi/2]);

% ���岽̬�켣�Ĺؼ���������x��������
xf = 5; xb = -xf;   % ��̤�ڵ����ϵ�ǰ������
y = 5;              % ����������y��ľ���
zu = 2; zd = 5;     % ����ʱ�ŵĸ߶�
% ����������õľ���·��
segments = [xf y zd; xb y zd; xb y zu; xf y zu] * 0.01;
segments = [segments; segments];%pose�б�
tseg = [3 0.25 0.5 0.25]';
tseg = [1; tseg; tseg];
x = mstraj(segments, [], tseg, segments(1,:), 0.01, 0.1);
%   TRAJ = MSTRAJ(P, QDMAX, TSEG, Q0, DT, TACC, OPTIONS)
%   ��ζ���켣
% -  P��MxN����ͨ����ľ���ÿ��ͨ����1�У�ÿ����һ�С����һ������Ŀ�ĵء�
% -  QDMAX��1xN�����������ƣ����ܳ�����
% -  TSEG��1xM����ÿ��K�εĳ���ʱ��
% -  Q0��1xN���ǳ�ʼ����
% -  DT��ʱ�䲽��
% -  TACC��1x1���˼���ʱ��Ӧ�������ж�ת��
% - ÿ���ε�TACC��1xM������ʱ�䣬TACC��i���ǴӶ�i����i + 1��ת���ļ���ʱ�䡣 TACC��1��Ҳ�Ƕ�1��ʼʱ�ļ���ʱ�䡣
xcycle = x(100:500,:);
qcycle = leg.ikine( transl(xcycle), [], [1 1 1 0 0 0], 'pinv' );

%����������ľ��Σ���Ⱥ͸߶ȳߴ磬����ÿ�����䡣
W = 0.1; L = 0.2;
% һ���Ż�������ʹ���˺ܶ��ͼѡ�������������������ر�ע�ͣ��������ᡢ������Ӱ���ؽ��ᣬû��ƽ������Ӱ��
%���ǲ�����ÿ��ѭ���н������أ����������ｫ����Ԥ�ֽ�Ϊһ��plotop�ṹ�� 

plotopt = {'noraise', 'nobase', 'noshadow', 'nowrist', 'nojaxes', 'delay', 0};

% ����4���ȵĻ����ˡ�ÿһ���������������湹�����Ȳ������˵Ŀ�¡�壬
%��һ�����ص����ƣ��Լ�һ����ʾ�������߻�����������λ�õĻ����任��
legs(1) = SerialLink(leg, 'name', 'leg1');
legs(2) = SerialLink(leg, 'name', 'leg2', 'base', transl(-L, 0, 0));
legs(3) = SerialLink(leg, 'name', 'leg3', 'base', transl(-L, -W, 0)*trotz(pi));
legs(4) = SerialLink(leg, 'name', 'leg4', 'base', transl(0, -W, 0)*trotz(pi));

% Ϊ�����˴����̶���С���ᣬ����Z������������
clf; axis([-0.3 0.1 -0.2 0.2 -0.15 0.05]); set(gca,'Zdir', 'reverse')
hold on
% ���������˵�����
% patch�Ǹ��ײ��ͼ�κ���������������Ƭͼ�ζ���
%һ����Ƭ���������䶥������ȷ����һ����������Ρ��û�����ָ����Ƭ�������ɫ�͵ƹ⡣
patch([0 -L -L 0], [0 0 -W -W], [0 0 0 0], ...
    'FaceColor', 'r', 'FaceAlpha', 0.5)
% ������ʵ����ÿ��������
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
