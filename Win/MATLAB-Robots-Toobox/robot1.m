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
