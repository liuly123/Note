[SLAM中的EKF，UKF，PF原理简介](https://www.cnblogs.com/gaoxiang12/p/5560360.html)

​	任何传感器，激光也好，视觉也好，整个SLAM系统也好，要解决的问题只有一个：**如何通过数据来估计自身状态。**每种传感器的测量模型不一样，它们的精度也不一样。换句话说，状态估计问题，也就是“**如何最好地使用传感器数据**”。可以说，SLAM是状态估计的一个特例。

## 1.离散时间系统的状态估计

​	记机器人在各时刻的状态为![x_1,\ldots,x_k](http://zhihu.com/equation?tex=x_1%2C%5Cldots%2Cx_k)，其中![k](http://zhihu.com/equation?tex=k)是离散时间下标。在SLAM中，我们通常要估计机器人的位置，那么系统的状态就指的是机器人的位姿。用两个方程来描述状态估计问题：

![](https://www.zhihu.com/equation?tex=%5C%5B%5Cleft%5C%7B+%5Cbegin%7Barray%7D%7Bl%7D%0A%7Bx_k%7D+%3D+f%5Cleft%28+%7B%7Bx_%7Bk+-+1%7D%7D%2C%7Bu_k%7D%2C%7Bw_k%7D%7D+%5Cright%29%5C%5C%0A%7By_k%7D+%3D+g%5Cleft%28+%7B%7Bx_k%7D%2C%7Bn_k%7D%7D+%5Cright%29%0A%5Cend%7Barray%7D+%5Cright.%5C%5D)

解释一下变量：

![](https://www.zhihu.com/equation?tex=f)-运动方程
![](https://www.zhihu.com/equation?tex=u)-输入
![](https://www.zhihu.com/equation?tex=w)- 输入噪声
![](https://www.zhihu.com/equation?tex=g)- 观测方程
![](https://www.zhihu.com/equation?tex=y)- 观测数据
![](https://www.zhihu.com/equation?tex=n)- 观测噪声

​	**运动方程**描述了状态![x_{k-1}](http://zhihu.com/equation?tex=x_%7Bk-1%7D)是怎么变到![x_k](http://zhihu.com/equation?tex=x_k)的，而**观测方程**描述的是从![x_k](http://zhihu.com/equation?tex=x_k)是怎么得到观察数据![y_k](http://zhihu.com/equation?tex=y_k)的。
　　请注意这是一种抽象的写法。当你有实际的机器人，实际的传感器时，方程的形式就会变得具体，也就是所谓的**参数化**。

​	例如，当我们关心机器人空间位置时，可以取![x_k = [x,y,z]_k](http://zhihu.com/equation?tex=x_k+%3D+%5Bx%2Cy%2Cz%5D_k)。进而，机器人携带了**里程计**，能够得到两个时间间隔中的相对运动，像这样![\Delta x_k=[\Delta x, \Delta y, \Delta z]_k](http://zhihu.com/equation?tex=%5CDelta+x_k%3D%5B%5CDelta+x%2C+%5CDelta+y%2C+%5CDelta+z%5D_k)，那么运动方程就变为：

![x_{k+1}=x_k+\Delta x_k+w_k](http://zhihu.com/equation?tex=x_%7Bk%2B1%7D%3Dx_k%2B%5CDelta+x_k%2Bw_k)

​	同理，观测方程也随传感器的具体信息而变。例如**激光传感器**可以得到空间点离机器人的距离和角度，记为![y_k=[r,\theta]_k](http://zhihu.com/equation?tex=y_k%3D%5Br%2C%5Ctheta%5D_k)，那么观测方程为：

![\[{\left[ \begin{array}{l} r\\ \theta  \end{array} \right]_k} = \left[ \begin{array}{l} \sqrt {{{\left\| {{x_k} - {L_k}} \right\|}_2}} \\ {\tan ^{ - 1}}\frac{{{L_{k,y}} - {x_{k,y}}}}{{{L_{k,x}} - {x_{k,x}}}} \end{array} \right] + {n_k}\]](http://zhihu.com/equation?tex=%5C%5B%7B%5Cleft%5B+%5Cbegin%7Barray%7D%7Bl%7D%0Ar%5C%5C%0A%5Ctheta+%0A%5Cend%7Barray%7D+%5Cright%5D_k%7D+%3D+%5Cleft%5B+%5Cbegin%7Barray%7D%7Bl%7D%0A%5Csqrt+%7B%7B%7B%5Cleft%5C%7C+%7B%7Bx_k%7D+-+%7BL_k%7D%7D+%5Cright%5C%7C%7D_2%7D%7D+%5C%5C%0A%7B%5Ctan+%5E%7B+-+1%7D%7D%5Cfrac%7B%7B%7BL_%7Bk%2Cy%7D%7D+-+%7Bx_%7Bk%2Cy%7D%7D%7D%7D%7B%7B%7BL_%7Bk%2Cx%7D%7D+-+%7Bx_%7Bk%2Cx%7D%7D%7D%7D%0A%5Cend%7Barray%7D+%5Cright%5D+%2B+%7Bn_k%7D%5C%5D)

​						其中![L_k=[L_{k,x},L_{k,y}]](http://zhihu.com/equation?tex=L_k%3D%5BL_%7Bk%2Cx%7D%2CL_%7Bk%2Cy%7D%5D)是一个2D路标点。

​	举这几个例子是为了说明，**运动方程和观测方程具体形式是会变化的**。但是，我们想讨论更一般的问题：当我们不限制传感器的具体形式时，能否设计一种方式，从已知的![u,y](http://zhihu.com/equation?tex=u%2Cy)（输入和观测数据）估计出![x](http://zhihu.com/equation?tex=x)呢？

​	这就是最一般的状态估计问题。我们会根据![f,g](http://zhihu.com/equation?tex=f%2Cg)是否线性，把它们分为**线性/非线性系统**。同时，对于噪声![w,n](http://zhihu.com/equation?tex=w%2Cn)，根据它们是否为高斯分布，分为**高斯/非高斯噪声**系统。最一般的，也是最困难的问题，是非线性-非高斯(NLNG, Nonlinear-Non Gaussian)的状态估计。下面先说最简单的情况：线性高斯系统。

## 2. 各类滤波器

​	在线性高斯系统中，运动方程、观测方程是线性的，且两个噪声项服从零均值的高斯分布。这是最简单的情况。简单在哪里呢？主要是因为**高斯分布经过线性变换之后仍为高斯分布**。而对于一个高斯分布，只要计算出它的一阶和二阶矩，就可以描述它（高斯分布只有两个参数![\mu, \Sigma](http://zhihu.com/equation?tex=%5Cmu%2C+%5CSigma)）。卡尔曼滤波器假设系统是线性高斯的，属于贝叶斯滤波。

#### 卡尔曼滤波器（KF）

​	先验估计

​	![\hat{x}_k=F_k\hat{x}_{k-1}+B_k\overrightarrow{u}_k+w_k](https://www.zhihu.com/equation?tex=%5Chat%7Bx%7D_k%3DF_k%5Chat%7Bx%7D_%7Bk-1%7D%2BB_k%5Coverrightarrow%7Bu%7D_k%2Bw_k)

​	![\hat{P}_k=F_k\hat{P}_{k-1}F_k^T+Q_k](https://www.zhihu.com/equation?tex=%5Chat%7BP%7D_k%3DF_k%5Chat%7BP%7D_%7Bk-1%7DF_k%5ET%2BQ_k)

​	后验估计

​	![\hat x_k^{'}=\hat x_k+K^{'}(\overrightarrow{z_k}-H_k\hat x_k)](https://www.zhihu.com/equation?tex=%5Chat+x_k%5E%7B%27%7D%3D%5Chat+x_k%2BK%5E%7B%27%7D%28%5Coverrightarrow%7Bz_k%7D-H_k%5Chat+x_k%29)

​	![P_k^{'}=P_k-K^{'}H_kP_k](https://www.zhihu.com/equation?tex=P_k%5E%7B%27%7D%3DP_k-K%5E%7B%27%7DH_kP_k)

​	![K^{'}=P_kH_k^T(H_kP_kH_k^T+R_k)^{-1}](https://www.zhihu.com/equation?tex=K%5E%7B%27%7D%3DP_kH_k%5ET%28H_kP_kH_k%5ET%2BR_k%29%5E%7B-1%7D)

​	![\hat{x}_k](https://www.zhihu.com/equation?tex=%5Chat%7Bx%7D_k)是先验状态估计向量，![P_k](https://www.zhihu.com/equation?tex=P_k)是先验状态估计协方差矩阵，![\overrightarrow{u_k}](https://www.zhihu.com/equation?tex=%5Coverrightarrow%7Bu_k%7D)为控制向量，![\overrightarrow {z_k}](https://www.zhihu.com/equation?tex=%5Coverrightarrow+%7Bz_k%7D)为观测向量，![\hat x_k^{'}](https://www.zhihu.com/equation?tex=%5Chat+x_k%5E%7B%27%7D)就是第k次卡尔曼预测结果，![P_k^{'}](https://www.zhihu.com/equation?tex=P_k%5E%7B%27%7D)是该结果的协方差矩阵。K为卡尔曼增益，就是通过这个变量来调节估计和预测的平衡。

![img](https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=2959512819,1155557907&fm=173&app=25&f=JPEG?w=451&h=286&s=1AAA742319DECCC81CFDA0DF0000C0B1)

#### 扩展卡尔曼滤波器（EKF）

https://baijiahao.baidu.com/s?id=1617263767992390794&wfr=spider&for=pc

​	卡尔曼滤波是在假设高斯和线性动作和观测模型下进行的，但是现实中并不是这样的。例如激光观测方程就不是线性的。

![img](https://ss1.baidu.com/6ONXsjip0QIZ8tyhnq/it/u=440523115,2395546669&fm=173&app=25&f=JPEG?w=416&h=135&s=80B4C433EBA458030C5DD0DA000050B0)

​	扩展卡尔曼滤波器的解决办法用高斯分布去近似它，并且在工作点附近对系统进行线性化。

**一、在工作点附近![](https://www.zhihu.com/equation?tex=%5C%5B%7B%7B%5Chat+x%7D_%7Bk+-+1%7D%7D%2C%7B%7B%5Ctilde+x%7D_k%7D%5C%5D)，对系统进行线性近似化：**

![](https://www.zhihu.com/equation?tex=%5C%5B%5Cbegin%7Barray%7D%7Bl%7D%0Af%5Cleft%28+%7B%7Bx_%7Bk+-+1%7D%7D%2C%7Bv_k%7D%2C%7Bw_k%7D%7D+%5Cright%29+%5Capprox+f%5Cleft%28+%7B%7B%7B%5Chat+x%7D_%7Bk+-+1%7D%7D%2C%7Bv_k%7D%2C0%7D+%5Cright%29+%2B+%5Cfrac%7B%7B%5Cpartial+f%7D%7D%7B%7B%5Cpartial+%7Bx_%7Bk+-+1%7D%7D%7D%7D%5Cleft%28+%7B%7Bx_%7Bk+-+1%7D%7D+-+%7B%7B%5Chat+x%7D_%7Bk+-+1%7D%7D%7D+%5Cright%29+%2B+%5Cfrac%7B%7B%5Cpartial+f%7D%7D%7B%7B%5Cpartial+%7Bw_k%7D%7D%7D%7Bw_k%7D%5C%5C%0Ag%5Cleft%28+%7B%7Bx_k%7D%2C%7Bn_k%7D%7D+%5Cright%29+%5Capprox+g%5Cleft%28+%7B%7B%7B%5Ctilde+x%7D_k%7D%2C0%7D+%5Cright%29+%2B+%5Cfrac%7B%7B%5Cpartial+g%7D%7D%7B%7B%5Cpartial+%7Bx_k%7D%7D%7D%7Bn_k%7D%0A%5Cend%7Barray%7D%5C%5D)

​	其中求偏导数用矩阵表示就是雅克比矩阵

**二、把噪声项和状态都当成了高斯分布**

​	这样，只要估计它们的均值和协方差矩阵，就可以描述状态了。经过这样的近似之后呢，后续工作都和卡尔曼滤波是一样的了

**三、公式**

![](http://zhihu.com/equation?tex=%5C%5B%5Cbegin%7Barray%7D%7Bl%7D%0A%7B%7B%5Ctilde+P%7D_k%7D+%3D+%7BF_%7Bk+-+1%7D%7D%7B%7B%5Chat+P%7D_%7Bk+-+1%7D%7DF_%7Bk+-+1%7D%5ET+%2B+Q_k%27%5C%5C%0A%7B%7B%5Ctilde+x%7D_k%7D+%3D+f%5Cleft%28+%7B%7B%7B%5Chat+x%7D_%7Bk+-+1%7D%7D%2C%7Bv_k%7D%2C0%7D+%5Cright%29%5C%5C%0A%7BK_k%7D+%3D+%7B%7B%5Ctilde+P%7D_k%7DG_k%5ET%7B%5Cleft%28+%7B%7BG_k%7D%7B%7B%5Ctilde+P%7D_k%7DG_k%5ET+%2B+R_k%27%7D+%5Cright%29%5E%7B+-+1%7D%7D%5C%5C%0A%7B%7B%5Chat+P%7D_k%7D+%3D+%5Cleft%28+%7BI+-+%7BK_k%7D%7BG_k%7D%7D+%5Cright%29%7B%7B%5Ctilde+P%7D_k%7D%5C%5C%0A%7B%7B%5Chat+x%7D_k%7D+%3D+%7B%7B%5Ctilde+x%7D_k%7D+%2B+%7BK_k%7D%5Cleft%28+%7B%7By_k%7D+-+g%28%7B%7B%5Ctilde+x%7D_k%7D%2C0%29%7D+%5Cright%29%0A%5Cend%7Barray%7D%5C%5D)

​	其中

![](http://zhihu.com/equation?tex=%5C%5BF_%7Bk-1%7D+%3D+%7B%5Cleft.+%7B%5Cfrac%7B%7B%5Cpartial+f%7D%7D%7B%7B%5Cpartial+%7Bx_%7Bk+-+1%7D%7D%7D%7D%7D+%5Cright%7C_%7B%7B%7B%5Chat+x%7D_%7Bk+-+1%7D%7D%7D%7D%2C%7BG_k%7D+%3D+%7B%5Cleft.+%7B%5Cfrac%7B%7B%5Cpartial+f%7D%7D%7B%7B%5Cpartial+%7Bx_k%7D%7D%7D%7D+%5Cright%7C_%7B%7B%7B%5Ctilde+x%7D_k%7D%7D%7D%5C%5D)

另一种写法：

![img](https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=2900172255,4052183982&fm=173&app=25&f=JPEG?w=441&h=235&s=8438E532119A41C84A5571CB0000C0B2)

![img](https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=2168246801,966478264&fm=173&app=25&f=JPEG?w=448&h=263&s=0AAA7C23191EC4C810DD90DE0000C0B2)

**四、局限性**

- 即使是高斯分布，经过一个非线性变换后也不是高斯分布。EKF只计算均值与协方差，是在用高斯近似这个非线性变换后的结果。

- 系统本身线性化过程中，丢掉了高阶项。

- 线性化的工作点往往不是输入状态真实的均值，而是一个估计的均值。于是，在这个工作点下计算的![F,G](http://zhihu.com/equation?tex=F%2CG)，也不是最好的。（解决方案：以EKF估计的结果为工作点，重新计算一遍EKF，直到这个工作点变化够小。是为迭代EKF（Iterated EKF, IEKF）。）

- 在估计非线性输出的均值时，EKF算的是![\mu_y=f(\mu_x)](http://zhihu.com/equation?tex=%5Cmu_y%3Df%28%5Cmu_x%29)的形式。这个结果几乎不会是输出分布的真正期望值。协方差也是同理。（解决方案：再计算其他几个精心挑选的采样点，然后用这几个点估计输出的高斯分布。是为Sigma Point KF（SPKF，或UKF）。）

  ​	为克服这些局限丢掉高斯假设，用一种比较暴力的方式来描述输出函数的分布：用足够多的采样点，来表达输出的分布。这种蒙特卡洛的方式，也就是粒子滤波的思路。

  ​	或者进一步丢掉滤波器思路，不用前一个时刻的值来估计下一个时刻，而是把所有状态看成变量，把运动方程和观测方程看成变量间的约束，构造误差函数，然后最小化这个误差的二次型，这样就会得到非线性优化的方法，在SLAM里就走向图优化那条路上去了。

#### 无迹卡尔曼UKF

  ​	UKF主要解决一个高斯分布经过非线性变换后，怎么用另一个高斯分布近似它。假设![x \sim N(\mu_x \Sigma_{xx} ), y=g(x)](http://zhihu.com/equation?tex=x+%5Csim+N%28%5Cmu_x+%5CSigma_%7Bxx%7D+%29%2C+y%3Dg%28x%29)，我们希望用![N(\mu_y, \Sigma_{yy})](http://zhihu.com/equation?tex=N%28%5Cmu_y%2C+%5CSigma_%7Byy%7D%29)近似![y](http://zhihu.com/equation?tex=y)。按照EKF，需要对![g](http://zhihu.com/equation?tex=g)做线性化。但在UKF里，不必做这个线性化。

  ​	UKF的做法是找一些叫做Sigma Point的点，把这些点用![g](http://zhihu.com/equation?tex=g)投影过去。然后，用投影之后的点做出一个高斯分布，如下式：
$$
\begin{gathered}
  {\mu _y}{\text{ = }}\frac{{{\text{g}}({\mu _x} - {\sigma _x}) + g({\mu _x} + {\sigma _x})}}{{\text{2}}} \hfill \\
  {\sigma _y}^2 = \frac{{{{\left( {{\text{g}}({\mu _x} - {\sigma _x}) - g({\mu _x} + {\sigma _x})} \right)}^2}}}{4} \hfill \\ 
\end{gathered}
$$
这里选了三个点：![\mu_x, \mu_x+\sigma_x, \mu_x-\sigma_x](http://zhihu.com/equation?tex=%5Cmu_x%2C+%5Cmu_x%2B%5Csigma_x%2C+%5Cmu_x-%5Csigma_x)。对于维数为N的分布，需要选2N+1个点。篇幅所限，这里就不解释这些点怎么选，以及为何要这样选了。总之UKF的好处就是：

- 不必线性化，也不必求导，对![g](http://zhihu.com/equation?tex=g)没有光滑性要求。

- 计算量随维数增长是线性的。

#### 粒子滤波PF

​	UKF的一个问题是输出仍假设成高斯分布。然而，即使在很简单的情况下，高斯的非线性变换仍然不是高斯。仅在很少的情况下，输出的分布有个名字（比如卡方），所以很难描述它们。

​	因为描述很困难，所以粒子滤波器采用了一种暴力的，用大量采样点去描述这个分布的方法。框架大概是一个不断采样——算权重——重采样的过程。

​	越符合观测的粒子拥有越大的权重，而权重越大就越容易在重采样时被采到。当然，每次采样数量、权重的计算策略，则是粒子滤波器里几个比较麻烦的问题，这里就不细讲了。

​	这种采样思路的最大问题是：**采样所需的粒子数量，随分布是指数增长的**。所以仅限于低维的问题，高维的基本就没办法了。

#### 非线性优化

​	非线性优化，计算的也是最大后验概率估计（MAP），但它的处理方式与滤波器不同。对于上面写的状态估计问题，可以简单地构造误差项：

![](http://zhihu.com/equation?tex=%5C%5B%5Cbegin%7Barray%7D%7Bl%7D%0A%7Be_%7Bv%2Ck%7D%7D%5Cleft%28+x+%5Cright%29+%3D+%7Bx_k%7D+-+f%5Cleft%28+%7B%7Bx_%7Bk+-+1%7D%7D%2C%7Bv_k%7D%2C0%7D+%5Cright%29%5C%5C%0A%7Be_%7By%2Ck%7D%7D%5Cleft%28+x+%5Cright%29+%3D+%7By_k%7D+-+g%5Cleft%28+%7B%7Bx_k%7D%2C0%7D+%5Cright%29%0A%5Cend%7Barray%7D%5C%5D)

​	然后最小化这些误差项的二次型：

![](http://zhihu.com/equation?tex=%5C%5B%5Cmin+J%5Cleft%28+x+%5Cright%29+%3D+%5Csum%5Climits_%7Bk+%3D+1%7D%5EK+%7B%5Cleft%28+%7B%5Cfrac%7B1%7D%7B2%7D%7Be_%7Bv%2Ck%7D%7D%7B%7B%5Cleft%28+x+%5Cright%29%7D%5ET%7DW_%7Bv%2Ck%7D%5E%7B+-+1%7D%7Be_%7Bv%2Ck%7D%7D%5Cleft%28+x+%5Cright%29%7D+%5Cright%29+%2B+%5Csum%5Climits_%7Bk+%3D+1%7D%5EK+%7B%5Cleft%28+%7B%5Cfrac%7B1%7D%7B2%7D%7Be_%7By%2Ck%7D%7D%7B%7B%5Cleft%28+x+%5Cright%29%7D%5ET%7DW_%7Bv%2Ck%7D%5E%7B+-+1%7D%7Be_%7Bv%2Ck%7D%7D%5Cleft%28+x+%5Cright%29%7D+%5Cright%29%7D+%7D+%5C%5D)

​	这里仅用到了噪声项满足高斯分布的假设，再没有更多的了。当构建一个非线性优化问题之后，就可以从一个初始值出发，计算梯度（或二阶梯度），优化这个目标函数。常见的梯度下降策略有牛顿法、高斯-牛顿法、Levenberg-Marquardt方法，可以在许多讲数值优化的书里找到。

​	非线性优化方法现在已经成为视觉SLAM里的主流，尤其是在它的稀疏性质被人发现且利用起来之后。它与滤波器最大不同点在于，一次可以考虑整条轨迹中的约束。它的线性化，即雅可比矩阵的计算，也是相对于整条轨迹的。相比之下，滤波器还是停留在马尔可夫的假设之下，只用上一次估计的状态计算当前的状态。

​	当然优化方式也存在它的问题。例如优化时间会随着节点数量增长——所以有人会提double window optimization这样的方式，以及可能落入局部极小。但是就目前而言，它比EKF还是优不少的。

PS：马尔科夫性质![img](https://gss1.bdstatic.com/9vo3dSag_xI4khGkpoWK1HF6hhy/baike/s%3D513/sign=31aaa6a2923df8dca23d8f90fe1072bf/43a7d933c895d143ec2e4c767ef082025aaf070e.jpg)