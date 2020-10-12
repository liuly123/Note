---
title: Tensorflow笔记
author: liuly
date: 2020-03-06 17:11:02

categories:
- 其他
typora-root-url: ../..
---
# 安装

https://mirrors.tuna.tsinghua.edu.cn/help/tensorflow/

需要先安装pip： `sudo apt install python-pip`

选择`Linux`，`cp27`，`1.3.0`，复制代码安装

```sh
pip install \
  -i https://pypi.tuna.tsinghua.edu.cn/simple/ \
  https://mirrors.tuna.tsinghua.edu.cn/tensorflow/linux/cpu/tensorflow-1.3.0-cp27-none-linux_x86_64.whl
```

测试

```python
python
import tensorflow as tf
tf.__version__
```

设置vim

```sh
vim ~/.vimrc
set ts=4
set nu
```

# Tensorflow框架

#### 计算图和会话

```python
#coding:utf-8
import tensorflow as tf
x = tf.constant([[1.0,2.0]])
w = tf.constant([[3.0],[4.0]])
y = tf.matmul(x,w)#x与w相乘
print y
with tf.Session() as sess:#（这是一个用来计算的会话）不带with后面的，就不计算结果，就只是网络框架
	print sess.run(y)
```

#### 前向传播

```python
#coding:utf-8
#两层简单神经网络（全连接），两输入，一输出，隐含层三个神经元
import tensorflow as tf
#输入层，一行两列
x = tf.constant([[0.7,0.5]])
#网络层的权值，一层神经元有两组连接，权值用随机数生成
w1 = tf.Variable(tf.random_normal([2,3],stddev=1,seed=1))
w2 = tf.Variable(tf.random_normal([3,1],stddev=1,seed=1))
#前向传播过程
a = tf.matmul(x,w1)#x与w1矩阵乘
y = tf.matmul(a,w2)#a与w2乘
#用会话计算结果
with tf.Session() as sess:
	init_op = tf.global_variables_initializer()
	sess.run(init_op)
	print sess.run(y)
```

#### 反向传播（训练）

```python
#!/usr/bin/python2.7
# coding:utf-8
# 喂数据，并训练，共有32组样本
# 学习目标：输入为两个随机数，两数和<1时，输出1，否则输出0
import tensorflow as tf
import numpy
BATCH_SIZE = 8
seed = 23455
# 基于seed产生随机数：实例化一个随机数生成器
rdm = numpy.random.RandomState(seed)
# 生成32行2列的随机数作为输入
X = rdm.rand(32, 2)
# 从X输入的两个数小于1时，Y输出1
Y = [[int(x0 + x1 < 1)] for (x0, x1) in X]
# 打印样本
print "X:\n", X
print "Y:\n", Y
# 神经网络的输入输出占位
x = tf.placeholder(tf.float32, shape=(None, 2))
y_ = tf.placeholder(tf.float32, shape=(None, 1))
# 随机生成网络权值
w1 = tf.Variable(tf.random_normal([2, 3], stddev=1, seed=1))
w2 = tf.Variable(tf.random_normal([3, 1], stddev=1, seed=1))
# 相乘
a = tf.matmul(x, w1)
y = tf.matmul(a, w2)
# 损失函数
loss = tf.reduce_mean(tf.square(y-y_))
# 反向传播（训练）方法，步长=0.001，损失函数值=loss
train_step = tf.train.GradientDescentOptimizer(0.001).minimize(loss)
#train_step = tf.train.MomentumOptimizer(0.001, 0.9).minimize(loss)
#train_step = tf.train.AdamOptimizer(0.001).minimize(loss)
# 生成会话来用样本训练模型
with tf.Session() as sess:
    init_op = tf.global_variables_initializer()  # 初始化参数
    sess.run(init_op)
    # 打印出未经训练的模型
    print"w1:\n", sess.run(w1)
    print"w2:\n", sess.run(w2)
    # 训练模型
    STEPS = 3000
    for i in range(STEPS):
        start = (i*BATCH_SIZE) % 32  # 每次喂8组数据:0～8,8~16,16~24,24~32
        end = start + BATCH_SIZE
        # 喂数据训练，使用X[start,end]方式可以超出列表范围，使用X[place]不能超出索引
        sess.run(train_step, feed_dict={x: X[start:end], y_: Y[start:end]})
        if i % 500 == 0:
            total_loss = sess.run(loss, feed_dict={x: X, y_: Y})
            print("训练%d轮后，损失函数值为%g" % (i, total_loss))
    # 打印训练后的参数
    print"\n"
    print"w1:\n", sess.run(w1)
    print"w2:\n", sess.run(w2)
```

## 神经网络优化

#### 损失函数(loss)：预测值(y)与已知答案(y_)的差距 

主流的有三种：

- **均方误差mes(Mean Squared Error)**
  $$
  MSE(y\_,y)=\frac{\sum_{i=1}^n(y-y\_)^2}{n}
  $$


```python
loss_mse = tf.reduce_mean(tf.square(y-y_))
```

- **交叉熵ce(Cross Entropy)**

  表征两个概率分布之间的距离
  $$
  H(y\_,y)=-\sum_{i=1}^n(y\_*logy)
  $$

  ```python
  loss_ce = -tf.reduce_mean(y_*tf.log(tf.clip_by_value(y, 1e-12, 1.0)))#1e-12防止值为0
  ```

  当y有n个可能的输出值（即n分类）时，y_与每个y的ce符合概率分布（概率的和为1），使用softmax()函数
  $$
  softmax(y_{i})=\frac{e^{y_{i}}}{\sum_{j=1}^{n}e^{y_{i}}}
  $$

  ```python
  ce = tf.nn.sparse_softmax_cross_entropy_with_logits(
      logits=y, labels=tf.argmax(y_, 1))
  lose_ce = tf.reduce_mean(ce)
  ```

- **自定义损失函数**

  例如
  $$
  loss(y\_,y)=\sum_{i=1}^{n}f(y\_,y)
  $$
  
  $$
  f(y\_,y) = \left\{ {\begin{array}{*{20}{c}}
  {PROFIT*(y\_ - y)\quad y < y\_\quad 预测值小于实际值时，误差乘上PROFIT}\\
  {COST*(y - y\_)\quad y >  = y\_\quad {\rm{ }} 预测值大于实际值时，误差乘以COST}\end{array}} \right.
  $$

  ```python
  loss = tf.reduce_mean(tf.where(tf.grater(y, y_), COST*(y-y_), PROFIT*(y_-y)))
  ```

**一个训练的示例，损失函数采用均方误差**

```python
#!/usr/bin/python2.7
# coding:utf-8
# 喂数据，并训练，共有32组样本
# 学习目标：Y=x1+x2，并加入随机噪声-0.05~0.05
import tensorflow as tf
import numpy
BATCH_SIZE = 8
seed = 23455
rdm = numpy.random.RandomState(seed)
# 目标模型
X = rdm.rand(32, 2)
Y_ = [[x1+x2+(rdm.rand()/10.0-0.05)] for (x1, x2) in X]
# 神经网络模型，单层，没有隐含层
x = tf.placeholder(tf.float32, shape=(None, 2))
y_ = tf.placeholder(tf.float32, shape=(None, 1))
w1 = tf.Variable(tf.random_normal([2, 1], stddev=1, seed=1))
y = tf.matmul(x, w1)
# 损失函数为MSE（均方误差）
loss_mse = tf.reduce_mean(tf.square(y-y_))
# 训练过程为梯度下降法
train_step = tf.train.GradientDescentOptimizer(0.001).minimize(loss_mse)
# 生成会话，训练STEP轮
with tf.Session() as sess:
    init_op = tf.global_variables_initializer()
    sess.run(init_op)
    STEPS = 20000
    for i in range(STEPS):
        start = (i*BATCH_SIZE) % 32
        end = start + BATCH_SIZE
        sess.run(train_step, feed_dict={x: X[start:end], y_: Y_[start:end]})
        if i % 500 == 0:
            total_loss = sess.run(loss_mse, feed_dict={x: X, y_: Y_})
            print("训练%d轮后，损失函数值为%g" % (i, total_loss))
            print "w1为：\n", sess.run(w1)
    # 打印训练后的参数
    print ("\n")
    print "w1:\n", sess.run(w1)

```

#### 学习率(learning_rate)：每次参数更新的幅度

$$
W_{n_1}=W_{n}-learning\_rate*\nabla
$$

​			▽为损失函数的梯度(倒数)，learning_rate为常数(用户自定义的学习率)

**指数衰减学习率**
$$
learning\_rate=LEARNING\_RATE\_BASE*{LEARNING\_RATE\_DECAY}^{\frac{global\_step}{LEARNING\_RATE\_STEP}}
$$

```python
#!/usr/bin/python2.7
# coding:utf-8

# 单神经元，自定义损失函数loss=(w+1)^2，学习率为0.2，w初值为5；为了使loss最小时，w的最终结果应为-1
import tensorflow as tf
w = tf.Variable(tf.constant(5, dtype=tf.float32))  # 神经网络
loss = tf.square(w+1)  # 损失函数

# 指数衰减学习率参数
LEARNING_RATE_BASE = 0.1  # 最初学习率
LEARNING_RATE_DECAY = 0.99  # 学习率的衰减率
LEARNING_RATE_STEP = 2  # 每多少轮更新一次学习率，一般为:样本总数/BATCH_SIZE
global_step = tf.Variable(0, trainable=False)  # 当前是第几轮

# 定义学习率
learning_rate = tf.train.exponential_decay(
    LEARNING_RATE_BASE, global_step, LEARNING_RATE_STEP,
    LEARNING_RATE_DECAY, staircase=True)

# 反向传播方法
train_step = tf.train.GradientDescentOptimizer(
    learning_rate).minimize(loss, global_step=global_step)

# 定义会话，训练40轮
with tf.Session() as sess:
    init_op = tf.global_variables_initializer()
    sess.run(init_op)
    for i in range(40):
        sess.run(train_step)
        # 数据打印
        learning_rate_val = sess.run(learning_rate)
        w_val = sess.run(w)
        loss_val = sess.run(loss)
        learning_rate_val = sess.run(learning_rate)
        global_step_val = sess.run(global_step)
        print "训练%s轮后，w值为%f，loss值为%f，学习率为%s，step为%s" % (
            i, w_val, loss_val, learning_rate_val, global_step_val)
```



