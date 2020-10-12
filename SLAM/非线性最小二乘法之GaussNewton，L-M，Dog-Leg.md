---
title: 非线性最小二乘法之GaussNewton，L-M，Dog-Leg
author: liuly
date: 2020-03-06 16:48:14
categories:

- SLAM
typora-root-url: ../..
---

## 非线性最小二乘法之Gauss Newton、L-M、Dog-Leg

https://blog.csdn.net/stihy/article/details/52737723

### 最快下降法

假设$h^{T} F^{\prime}(x)<0$，则$h$是$F(x)$的下降方向，即对于任意足够小的$\alpha>0$，都满足$F(x+\alpha h)<F(x)$。

现在讨论$F(x)$沿着$h$下降的快慢：
$$
\lim _{\alpha \rightarrow 0} \frac{F(x)-F(x+\alpha h)}{\alpha\|h\|}=-\frac{1}{\|h\|} h^{T} F^{\prime}(x)=-\left\|F^{\prime}(x)\right\| \cos \theta
$$
其中$\theta$为矢量$h$和$F^{\prime}(x)$的夹角，当$\theta=\pi$时，下降最快。

即$h_{s d}=-F^{\prime}(x)$是最快下降方向。

### 最小二乘问题

通常的最小二乘问题都可以表示为： 
$$
F(x)=\frac{1}{2} \sum_{j=1}^{n}\left(f_{i}(x)^{2}\right)=\frac{1}{2}\|f(x)\|^{2}=\frac{1}{2} f(x)^{T} f(x)
$$
找到一个$x^{*}$使得$x^{*}=\operatorname{argmin}_{x} F(x)$，其中$x=\left[x_{1} x_{2} \cdots x_{m}\right], f(x)=\left[f_{1}(x) f_{2}(x) \cdots f_{n}(x)\right]$。

假设对$f(x)$的第$i$个分量$f_{i}(x)$在点$\boldsymbol{x}_{k}$处Taylor展开，

$f_{i}\left(x_{k}+h\right) \approx f_{i}\left(x_{k}\right)+\nabla f_{i}\left(x_{k}\right)^{T} h, i=1,2 \cdots n$

则$f\left(x_{k}+h\right) \approx f\left(x_{k}\right)+J\left(x_{k}\right) h$，其中Jacobian矩阵
$$
J\left(x_{k}\right)=\left[ \begin{array}{c}{\nabla f_{1}\left(x_{k}\right)^{T}} \\ {\nabla f_{2}\left(x_{k}\right)^{T}} \\ {\vdots} \\ {\nabla f_{n}\left(x_{k}\right)}\end{array}\right]=\left[ \begin{array}{cccc}{\frac{\partial f_{1}\left(x_{k}\right)}{\partial x_{1}}} & {\frac{\partial f_{1}\left(x_{k}\right)}{\partial x_{2}}} & {\cdots} & {\frac{\partial f_{1}\left(x_{k}\right)}{\partial x_{m}}} \\ {\frac{\partial f_{2}\left(x_{k}\right)}{\partial x_{1}}} & {\frac{\partial f_{2}\left(x_{k}\right)}{\partial x_{2}}} & {\cdots} & {\frac{\partial f_{2}\left(x_{k}\right)}{\partial x_{m}}} \\ {\vdots} & {\vdots} & {\ddots} & {\vdots} \\ {\frac{\partial f_{n}\left(x_{k}\right)}{\partial x_{1}}} & {\frac{\partial f_{n}\left(x_{k}\right)}{\partial x_{2}}} & {\cdots} & {\frac{\partial f_{n}\left(x_{k}\right)}{\partial x_{m}}}\end{array}\right]
$$
通常记$f_{k}=f\left(x_{k}\right), J_{k}=J\left(x_{k}\right)$。则

$$
\frac{\partial F(x)}{\partial x_{j}}=\sum_{i=1}^{n} f_{i}(x) \frac{\partial f_{i}(x)}{\partial x_{j}}
$$
所以$F(x)$的梯度为：

$$
g=F^{\prime}(x)=J(x)^{T} f(x)
$$

### Gauss-Newton法

选择$h$使$F(x)$在$x_{k}$附近二阶近似，则

$$
\begin{aligned} F\left(x_{k}+h\right) \approx L(h) &=\frac{1}{2} f\left(x_{k}+h\right)^{T} f\left(x_{k}+h\right) \\ &=\frac{1}{2} f_{k}^{T} f_{k}+h^{T} J_{k}^{T} f_{k}+\frac{1}{2} h^{T} J_{k}^{T} J_{k} h \\ &=F\left(x_{k}\right)+h^{T} J_{k}^{T} f_{k}+\frac{1}{2} h^{T} J_{k}^{T} J_{k} h \end{aligned}
$$
为了使$F\left(x_{k}+h\right)$取极小值，$L(h)$对$h$的一阶导数$L^{\prime}(h)$要等于0。即
$$
\frac{\partial L(h)}{\partial h}=J_{k}^{T} f_{k}+J_{k}^{T} J_{k} h =0
$$
（$F\left(x_{k}\right)$里不含$h$），则
$$
\left(J_{k}^{T} J_{k}\right) h_{g n}=-J_{k}^{T} f_{k} \\
x_{k+1}=x_{k}+h_{g n}
$$
由于Gauss-Newton法求解过程中需要对$J^{T} J$求逆，所以要求$J^{T} J$为非奇异；另外当$x_{0}$离极小值较远时，Gauss-Newton算法可能发散。

总结Gauss-Newton法的**一般步骤**：

- 根据$\left(J_{k}^{T} J_{k}\right) h_{g n}=-J_{k}^{T} f_{k}$，求迭代步长$h_{g n}$；

- $x_{k+1}=x_{k}+h_{g n}$对解进行更新；

- 如果$\left|F\left(x_{k+1}\right)-F\left(x_{k}\right)\right|<\epsilon$，则认为$F(x)$已收敛，则退出迭代，否则重复迭代。

通常Gauss-Newton法收敛较快，但是不稳定。而最快下降法稳定，但是收敛较慢。所以接下来我们介绍GaussNewton和最快下降法混合法。

### LM阻尼最小二乘法

Gauss-Newton法是用$\left(J_{k}^{T} J_{k}\right) h=-J_{k}^{T} f_{k}$来确定$h$，现在假设在$J_{k}^{T} J_{k}$对角线上元素都加上同一个数$u>0$，即：
$$
\left(J_{k}^{T} J_{k}+u I\right) h=-J_{k}^{T} f_{k}
$$
这样即使当$J_{k}^{T} J_{k}$奇异，只要$u$充分大，总能使$\left(J_{k}^{T} J_{k}+u I\right)$，则$\left(J_{k}^{T} J_{k}+u I\right) h=-J_{k}^{T} f_{k}$必有解，这个解依赖于$\boldsymbol{u}$，记作$h_{l m}$。
$$
\begin{cases}
当u=0 &h_{lm}\approx h_{gn}，即为GaussNewton法. \\
当u充分大 &uIh_{lm}\approx -J_k^Tf_k，h_{lm}=-\frac{1}{u}J_k^Tf_k ，即为最快下降法. \\
特别当u \to \infty &\left\|h_{lm} \right\| \to 0 \\
\end{cases}
$$
因此$u$ 起着使步长$\left\|h_{l m}\right\|$缩短或阻尼的作用，此即为阻尼最小二乘法。

---

那么LM阻尼最小二乘法实际迭代过程中怎样调整$u$呢？

假设$\|h\|$足够小，对$f(x+h)$一阶近似$f(x+h) \approx \iota(h)=f(x)+J(x) h$

则对$F(x+h)$二阶近似：
$$
\begin{aligned} F(x+h) \approx L(h) &=\frac{1}{2} f(x+h)^{T} f(x+h) \\ &=\frac{1}{2} f^{T} f+h^{T} J^{T} f+\frac{1}{2} h^{T} J^{T} J h \\ &=F(x)+h^{T} J^{T} f+\frac{1}{2} h^{T} J^{T} J h \end{aligned}
$$
我们定义一个增益比$\rho=\frac{F(x)-F\left(x+h_{l m}\right)}{L(0)-L\left(h_{l m}\right)}$

（在实际中，我们选择一阶近似、二阶近似并不是在所有定义域都满足的，而是在$[x-\epsilon, x+\epsilon]$作用域内满足这个近似条件。）

- 当$\rho$较大时，表明$F(x+h)$的二阶近似$L(h)$比$F(x+h)$更加接近$F(x)$，因此二阶近似比较好，所以可以减小$u$，采用更大的迭代步长，接近Gauss-Newton法来更快收敛。

- 当$\rho$较小时，表明采取的二阶近似较差，因此通过增大$u$，采用更小的步长，接近最快下降法来稳定的迭代。

一种比较好的阻尼系数$u$随$\rho$选择策略：

初值$A_{0}=J\left(x_{0}\right)^{T} J\left(x_{0}\right)$，$u_{0}=\tau * \max \left\{a_{i i}\right\}$，$v_{0}=2$。

（算法对$\tau$取值不敏感，$\tau$可以取$10^{-6} $、$ 10^{-3}$或1都行。）
$$
\begin{cases}
\text{if $\rho$>0} &u:=u*max\{\frac{1}{3},1-(2\rho-1)^3\} &v:=2;\\
else &u:=u*v &v:=2*v;\\
\end{cases}
$$

---

总结LM阻尼最小二乘法的步骤：

- step1：初始化$u_{0}=\tau * \max \left\{a_{i i}\right\}, v_{0}=2$；

- step2：求梯度$g_{k}=J_{k}^{T} f_{k}$，如果$\left\|g_{k}\right\| \leq \epsilon_{1}$，则退出，否则退出。

- step3：根据$\left(J_{k}^{T} J_{k}+u_{k} I\right) h_{l m}=-J_{k}^{T} f_{k}$，求解迭代步长$h_{l m}$，若$\left\|h_{l m}\right\| \leq \epsilon_{2}\left(\|x\|+\epsilon_{2}\right)$，则退出，否则继续。

- step4：$x_{n e w}=x_{k}+h_{l m}$，计算增益比$\boldsymbol{\rho}=\frac{F\left(\boldsymbol{x}_{k}\right)-\boldsymbol{F}\left(\boldsymbol{x}_{n e w}\right)}{L(0)-L\left(h_{l m}\right)}$。

  如果$\rho>0$，则$x_{k+1}=x_{n e w}$，$u_{k+1}=u_{k} * \max \left\{\frac{1}{3}, 1-(2 \rho-1)^{3}\right\}$，$v_{k+1}=2$；

  否则$u_{k+1}=u_{k} * v_{k}$，$v_{k+1}=2 * v_{k}$。

  重复step2。

对于$\epsilon_{1}$、$\epsilon_{2}$可以选取任意小的值如$10^{-12}$，只是作为迭代的终止条件，其值得选取对最终的收敛结果影响不大。

























