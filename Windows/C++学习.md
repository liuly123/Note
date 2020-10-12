---
title: C++学习
author: liuly
date: 2020-03-06 16:48:14
categories:

- Windows
typora-root-url: ../..
---
[TOC]

# C++学习

## 代码示例

```
#include <bits/stdc++.h>
ios::sync_with_stdio(false);cin.tie(0);cout.tie(0);
```


### 命令行参数

```c++
#include<iostream>
using namespace std;

//int main(int argc, char** argv)
int main(int argc, char * argv[])
{
	for (int i = 0; i < argc; i++)
	{
		cout << argv[i] << endl;
	}
}
//输出为所有参数
//包括程序名本身（完整路径）
//argc不包括程序名本身
```

示例：

```c++
int nargs = argc/2 - 1;///参数的数量（参数成对出现：参数名和参数值）
for( int i = 0; i < nargs; i++ )
{
    int j = 2*i + 2;
    if( string(argv[j]) == "-o" )
        frame_offset = stoi(argv[j+1]);
    else if( string(argv[j]) == "-n" )
        frame_number = stoi(argv[j+1]);
    else if( string(argv[j]) == "-s" )
        frame_step = stoi(argv[j+1]);
    else if (string(argv[j]) == "-c")
        config_file = string(argv[j+1]);
    else
        return false;
}
```

### 程序计时

```c++
#include<iostream>
#include<chrono>

using namespace std;
int main(int argc, char **argv)
{
	std::chrono::steady_clock::time_point t1 = std::chrono::steady_clock::now();//开始时刻
	while (true)
	{
		std::chrono::steady_clock::time_point t2 = std::chrono::steady_clock::now();//当前时刻
		double t = std::chrono::duration_cast<std::chrono::duration<double> >(t2 - t1).count();//开始到现在的时间
		cout << t << endl;
	}
}
```

写个class方便使用


```c++
#include<iostream>
#include <chrono>
#include<Windows.h>///只是为了Sleep
using namespace std;
//声明
class Timer {
public:
	static constexpr double SECONDS = 1e-9;///秒
	static constexpr double MILLISECONDS = 1e-6;//毫秒
	static constexpr double NANOSECONDS = 1.0;//纳秒
	Timer(double scale = MILLISECONDS);//默认的时间单位是毫秒
	virtual ~Timer();
	void start();
	double stop();
private:
	std::chrono::high_resolution_clock::time_point start_t;///开始计时的时间
	bool started;
	double scale;
};
//调用
int main(int argc, char * argv[])
{

	Timer timer1(1e-6);
	//或者 Timer timer1(1e-6);
	timer1.start();
	Sleep(1000);
	double time = timer1.stop();
	cout <<"持续时间："<< time<< "毫秒" << endl;
	system("pause");
	return 0;
}
//定义
Timer::Timer(double scale) : started(false), scale(scale) { }
Timer::~Timer() { }

void Timer::start() {
	started = true;
	start_t = std::chrono::high_resolution_clock::now();
}

double Timer::stop() {
	std::chrono::high_resolution_clock::time_point end_t = std::chrono::high_resolution_clock::now();
	if (!started)
		throw std::logic_error("[Timer] Stop called without previous start");
	started = false;
	std::chrono::duration<double, std::nano> elapsed_ns = end_t - start_t;
	return elapsed_ns.count()*scale;
}
```



### vector和iterator

```c++
#include <iostream>
#include <vector>
using namespace std;
int main()
{
	vector<int> v;  //v是存放int类型变量的可变长数组，开始时没有元素
	for (int n = 0; n < 5; ++n)
		v.push_back(n);  //push_back成员函数在vector容器尾部添加一个元素
    //正向迭代器遍历容器
	vector<int>::iterator i;
	for (i = v.begin(); i != v.end(); ++i) {  //用迭代器遍历容器
		cout << *i << " ";  //*i 就是迭代器i指向的元素
		*i *= 2;  //每个元素变为原来的2倍
	}
	cout << endl;
	//用反向迭代器遍历容器
	for (vector<int>::reverse_iterator j = v.rbegin(); j != v.rend(); ++j)
		cout << *j << " ";
	cin.ignore();
	return 0;
}
```

输出为：

```
0 1 2 3 4
8 6 4 2 0
```

### iterator/list的偏移

```c++
#include <iostream>     // std::cout
#include <iterator>     // std::advance
#include <list>         // std::list

using namespace std;
int main() 
{
	std::list<int> mylist;
	for (int i = 0; i < 10; i++) mylist.push_back(i);

	std::list<int>::iterator it = mylist.begin();//第一个元素标号为0

	std::advance(it, 5);//向后5个偏移
	cout << "mylist第6个元素是: " << *it << endl;

	std::advance(it, -1);//向前1个偏移
	cout << "mylist第5个元素是: " << *it << endl;

	return 0;
}
```

输出为：

```
mylist第6个元素是: 5
mylist第5个元素是: 4
```

### 迭代器删除元素

**关联容器**

对于关联容器（如map，set，multimap，multiset），删除当前的iterator，仅仅会使当前的iterator失效，只要在erase时，递增当前的iterator即可。这是因为map之类的容器，使用了红黑树来实现，插入，删除一个结点不会对其他结点造成影响。

```c++
set<int> valset = { 1,2,3,4,5,6 };  
set<int>::iterator iter;  
for (iter = valset.begin(); iter != valset.end(); )  
{  
     if (3 == *iter)  
          valset.erase(iter++);  
     else  
          iter++;  
}
```

**顺序容器**

对于序列式容器（如vector，deque，list等），删除当前的iterator会使后面所有元素的iterator都失效。这是因为vector，deque使用了连续分配的内存，删除一个元素导致后面所有的元素会向前移动一个位置。不过erase方法可以返回下一个有效的iterator。

```c++
vector<int> val = { 1,2,3,4,5,6 };  
vector<int>::iterator iter;  
for (iter = val.begin(); iter != val.end(); )  
{  
     if (3 == *iter)  
          iter = val.erase(iter);//返回下一个有效的迭代器，无需+1  
     else  
          iter++;  
}
```

### nth_element排序

nth_element(first,nth,last);在first到last的范围内（各种容器），确保第nth的数是正好位于nth的位置，默认升序排列，当nth元素确定拍在nth的位置后，后续就不排了（但通常结果是顺序都对）。也可以加第四个参数：bool型的比较函数

**数组排序**

```c++
#include <iostream>
#include <algorithm>
using namespace std;

int main()
{
	int iarray[] = { 5,6,11,19,34,55,77,15,89,7,2,1,3,52 };
	int len = sizeof(iarray) / sizeof(int);
	cout << "原数组：" << endl;
	for (size_t i = 0; i < len; i++)
		cout << iarray[i] << " ";
	nth_element(iarray, iarray + 2, iarray + len);
	cout << endl << "升序排列后：" << endl;
	for (size_t i = 0; i < len; i++)
		cout << iarray[i] << " ";
	cout << endl << "第6个元素：" << endl << iarray[6] << endl;
	return 0;
}
```

输出：

```
原数组：
5 6 11 19 34 55 77 15 89 7 2 1 3 52
升序排列后：
1 2 3 5 6 7 11 15 19 34 52 55 77 89
第6个元素：
11
```

**vector排序**


```c++
//vector排序
#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

int main()
{
	vector<int> a(9);
	cout << "生成的随机数组：" << endl;
	for (int i = 0; i < 9; i++)
		a[i] = i + 1;
	//对一个元素序列进行(伪)随机的重新排序
	random_shuffle(a.begin(), a.end());
	for (int i = 0; i < 9; i++)
		cout << a[i] << " ";
	cout << endl;

	cout << "(由大到小)第5个数：";
	nth_element(a.begin(), a.begin() + 4, a.end());
	cout << *(a.begin() + 4) << endl;

	cout << "排完之后的顺序：" << endl;
	for (int i = 0; i < 9; i++)
		cout << a[i] << " ";
	cout << endl;
	return 0;
}
```

输出：

```
生成的随机数组：
9 2 7 3 1 6 8 4 5
(由大到小)第5个数：5
排完之后的顺序：
1 2 3 4 5 6 7 8 9
```

### 遍历文件（windows）

```c++
#include <stdio.h>
#include <io.h>
#include <windows.h>
//windows x86 only
const char *to_search = "D:\\SLAM\\*";        //欲查找的文件，支持通配符(\\前一个\表示转义字符)，这是正则表达式
int main()
{
	long handle;                               //用于查找的句柄
	struct _finddata_t fileinfo;               //文件信息的结构体
	//第1次查找
	handle = _findfirst(to_search, &fileinfo); 
	if (-1 == handle) return -1;
	printf("%s\n", fileinfo.name);             //打印出找到的文件的文件名
	//第2次直到后面的全部文件
	while (!_findnext(handle, &fileinfo))
	{
		printf("%s\n", fileinfo.name);
	}
	//关闭句柄
	_findclose(handle);
	system("pause");
	return 0;
}
```

### OpenCV遍历图片

```c++

#include <opencv2/opencv.hpp>
#include <iostream>
#include <vector>
#include <string>
#include <fstream>

using namespace cv;
using namespace std;
int main()
{
	std::string img_dir = "D:\\SLAM\\dataset\\EuRoC\\MH_01_easy\\mav0\\cam0\\data\\*.png";

	std::vector<cv::String> image_files;
	cv::glob(img_dir, image_files);
	if (image_files.size() == 0)
	{
		std::cout << "No image files" << std::endl;
		system("pause");
		return 0;
	}

	for (unsigned int frame = 0; frame < image_files.size(); ++frame)
	{//image_file.size()代表文件中总共的图片个数
		Mat image = cv::imread(image_files[frame]);
		imshow("1", image);
		waitKey(1);
	}
}
```

### class、vector、iterator遍历文件

```c++
#include <iostream>
#include <io.h>
#include <windows.h>
#include <string>
#include <list>//list同vector同理
#include <vector>
using namespace std;

class GetName
{
	char *path;
	long handle;                               //用于查找的句柄
	struct _finddata_t fileinfo;               //文件信息的结构体
public:
	GetName(char *to_search);
	vector<string> NameToVector();
};

GetName::GetName(char *to_search):path(to_search){}

vector<string> GetName::NameToVector()
{
	vector<string> NameVector;
	//第1次查找
	handle = _findfirst(path, &fileinfo);
	//if (-1 == handle) return;
	NameVector.push_back(fileinfo.name);
	//第2次直到后面的全部文件
	while (!_findnext(handle, &fileinfo))
	{
		NameVector.push_back(fileinfo.name);
	}
	//关闭句柄
	_findclose(handle);
	return NameVector;
}
int main()
{
	vector<string> NameVector;
	char *to_search = "D:\\SLAM\\*";        //前一个\表示转义字符
	GetName GN(to_search);
	NameVector = GN.NameToVector();

	vector<string>::iterator i;
	for (i = NameVector.begin();i != NameVector.end();i++)
	{
		cout << *i << endl;
	}

	system("pause");
	return 0;
}
```


### 隐藏控制台窗口

include后面加上：

```c++
#pragma comment( linker, "/subsystem:\"windows\" /entry:\"mainCRTStartup\"" )
```

### 回调函数

普通函数与回调函数主要是在调用方式上有区别：

1、对**普通函数**的调用：调用程序发出对普通函数的调用后，程序执行立即转向被调用函数执行，直到被调用函数执行完毕后，再返回调用程序继续执行。从发出调用的程序的角度看，这个过程为“调用-->等待被调用函数执行完毕-->继续执行”。

2、对**回调函数**调用：调用程序发出对回调函数的调用后，`不等回调函数执行完毕`，立即返回并继续执行。这样，调用程序执和被调用函数同时在执行。当被调函数执行完毕后，被调函数会反过来调用某个事先指定的函数，以通知调用程序：函数调用结束。这个过程称为回调（Callback），这正是回调函数名称的由来。

```c++
#include <stdio.h>
typedef int(*callback)(int, int);//函数指针：输入类型和输出类型
int fun1(int a, int b, callback p)//fun2函数的指针作为参数
{
	return (*p)(a, b);
}
int fun2(int a, int b)//回调函数
{
	return a + b;
}
int main()
{
	int res = fun1(4, 2, fun2);
	printf("%d\n", res);
	return 0;
}
```

 它们与普通函数并没有任何区别, 只是与其它函数使用的方式有些许差别。

 回调函数的好处是，通过修改传入fun1的参数（回调函数的指针），可以让fun1内调用不同的执行函数，如给(*p)赋值fun2、fun3的指针

### 函数参数传递的三种方式(x,*x,&x)

函数实现两个将两个数交换位置

**第一种**

```c++
#include<stdio.h>
void myswap(int x, int y)
{
	int t;
	t = x;
	x = y;
	y = t;
}
int main()
{
	int a = 1, b = 2;
	printf("交换前a=%d,b=%d\n", a, b);
	myswap(a, b);  //作为对比，直接交换两个整数，显然不行
	printf("交换后a=%d,b=%d\n", a, b);
	return 0;
}
```

结果

```
交换前a=1,b=2
交换后a=1,b=2
```

**第二种**

```c++
#include<stdio.h>
void myswap(int *p1, int *p2)
{
	int  t;
	t = *p1;
	*p1 = *p2;
	*p2 = t;
}
int main()
{
	int a = 1, b = 2;
	printf("交换前a=%d,b=%d\n", a, b);
	myswap(&a, &b);  //交换两个整数的地址
	printf("交换后a=%d,b=%d\n", a, b);
	return 0;
}
```

结果

```
交换前a=1,b=2
交换后a=2,b=1
```

**第三种**

```c++
#include<stdio.h>
void myswap(int &x, int &y) //这里的形参为引用类型，引用与实参进行绑定，作为实参的别名
{                           //所以，使用引用类型，传入实参后，函数对引用的操作，
	int t;                  //就是对实参的操作，所以实参会发生变化                
	t = x;
	x = y;
	y = t;
}
int main()
{
	int a = 1, b = 2;
	printf("交换前a=%d,b=%d\n", a, b);
	myswap(a, b);  //交换两个整数的地址
	printf("交换后a=%d,b=%d\n", a, b);
	return 0;
}
```

结果

```
交换前a=1,b=2
交换后a=2,b=1
```

### const的使用

#### 使用const修饰变量

 有时候我们需要定义这样一种变量，它的值不能被更改。为了满足这一要求，可以通过关键字const对变量的类型加以限定。 

**const 修饰普通的变量**

 用const修饰变量的语义是要求编译器去阻止所有对该变量的赋值行为。因此，必须在const变量初始化时就提供给它初值： （ 这个初值可以是编译时即确定的值，也可以是运行期才确定的值 ）

```c++
const int bufSize=512;
```

 这里将bufSize定义成了一个常量。任何试图为bufSize赋值的行为都将引发错误。

**注意**:const对象必须初始化，因为const对象一旦创建后其值就不能再改变 。

如：

```c++
const int j=42; //正确，编译时初始化
const int i=get_size();//正确，运行时初始化
const int k;  //错误，未初始化
int i=42;
const int ci=i;//正确，
```

**const的引用**

 对**常量的引用(reference to const)**，将引用绑定到const对象上。与普通引用不同的是： 

(1) 对常量的引用不能用于修改它所绑定的对象。

```c++
int i=42;
int &r1=i;
const int &r2=i;//r2也绑定了对象i,但不允许通过r2修改i的值
r1=0;           //正确
r2=0;           //错误，r2是一个常量引用
```

(2) 不能将非常量引用指向一个常量对象值。 

```c++
const int ci=1024;
int &r2=ci;         //错误，试图让一个非常量引用指向一个常量对象
```

#### const与指针

 const修饰指针变量有3种情况：

1. 指向常量的指针(pointer to const)不能用于改变其所指对象的值。

2. 常量指针(const pointer)，指针本身定义为常量。

3. const 修饰指针和指针指向的内容，则指针和指针指向的内容都为不可变量。 

**（1）指向常量的指针(pointer to const)，不能通过该指针改变其所指对象的值。** 

```c++
const double pi=3.14;
double *ptr=&pi;        //错误：ptr是一个普通的指针。
const double *cptr=&pi; //正确：
*cptr=42;               //错误：不能给*cptr赋值
```

 指向常量的指针却可以指向一个非常量对象。 

```c++
double val=3.14;
*cptr=&val;         //正确，但不能通过cptr改变val的值。
```

 **（2）常量指针(const pointer),指针本身定义为常量。**
常量指针必须被初始化，一旦初始化完成，它的值(也就是存放在指针中的那个地址)将不能被改变。
把*放在const关键字之前用以说明指针是一个常量。 

```c++
int errorNumb=0;
int *const curErr = &errorNumb;//正确：curErr将一直指向errorNumb
```

 **（3）将上述两种结合，指向常量对象的常量指针** 

```c++
int a=10;
const int * const p=&a;
```

 上面的例子中，不能通过指针p修改其所指对象的值(变量a),并且指针p必须被初始化，一旦初始化后，它的值将不能被改变(也就是指针p只能指向a)。 

### 函数前后加const的区别

 **函数前加const**：普通函数或成员函数（非静态成员函数）前均可加const修饰，表示函数的返回值为const，不可修改。格式为： 

```c++
const returnType functionName(param list)
```

 **函数后加const**：只有类的非静态成员函数后可以加const修饰，表示该类的this指针为const类型，不能改变类的成员变量的值，即成员变量为read only，任何改变成员变量的行为均为非法。此类型的函数可称为只读成员函数，格式为： 

```c++
returnType functionName(param list) const
```

**const类型的对象只能调用后const成员函数**

```c++
#include <iostream>
using namespace std;

class A{
private:
	int m_a;
public:
	A():m_a(0){}
	int getA() const
	{
		return m_a;
	}
	int GetA() //非const成员函数，若在后面加上const修饰则编译通过
	{
		return m_a;
	}
};

int main()
{
	const A a2;//const对象
	int t;
	t = a2.getA();
	t = a2.GetA();//const类型的对象只能调用后const成员函数
	return 0;
}
```

###  constexpr常量表达式 

 constexpr是C++11中新增的关键字，其语义是“常量表达式”，也就是在编译期可求值的表达式。最基础的常量表达式就是字面值或全局变量/函数的地址或sizeof等关键字返回的结果，而其它常量表达式都是由基础表达式通过各种确定的运算得到的 。

 constexpr所修饰的变量一定是编译期可求值的，所修饰的函数在其所有参数都是constexpr时，一定会返回constexpr 

```c++
constexpr int Inc(int i)
{
    return i + 1;
}
constexpr int a = Inc(1); // ok
constexpr int b = Inc(cin.get()); // !error
constexpr int c = a * 2 + 1; // ok
```

### 容器的front()和pop_front()

```c++
std::list<std::string> images;
images.push_back("123.jpg");
string img= images.front();//获取容器的第一的元素
images.pop_front();//删除容器的第一个元素
```

### template\<tymename T>

其实就是模板，函数的类型是未知的，当你把它应用于不同的类型时，不会造成类型冲突。

比如求最小值，要对int，float，double类型的数都适用，那么你就要写三个函数：

```c++
int sum(int, int);
float sum(float, float);
double sum(double, double);
```

 但是有了`templae<typename T>`你就只需要写一个函数。 

```c++
#include<iostream>
#include<vector>
#include<algorithm>
using namespace std;
template <typename T>
T mmax(T a,T b)
{
    return a>b?a:b;
}
int main()
{
    int  a,b;
    cin>>a>>b;
    cout<<mmax(a,b)<<endl;
    float c,d;
    cin>>c>>d;
    cout<<mmax(c,d)<<endl;
    double f,g;
    cin>>f>>g;
    cout<<mmax(f,g)<<endl;
}
```

### list, vector, map, set 区别与用法比较

1. List封装了链表,Vector封装了数组, list和vector得最主要的区别在于vector使用连续内存存储的，他支持[]运算符，而list是以链表形式实现的，不支持[]。
2. Vector对于随机访问的速度很快，但是对于插入尤其是在头部插入元素速度很慢，在尾部插入速度很快。
3. List对于随机访问速度慢得多，因为可能要遍历整个链表才能做到，但是对于插入就快的多了，不需要拷贝和移动数据，只需要改变指针的指向就可以了。另外对于新添加的元素，Vector有一套算法，而List可以任意加入。
   Map,Set属于标准关联容器，使用了非常高效的平衡检索二叉树：红黑树，他的插入删除效率比其他序列容器高是
4. 因为不需要做内存拷贝和内存移动，而直接替换指向节点的指针即可。
   Set和Vector的区别在于Set不包含重复的数据。
5. Set和Map的区别在于Set只含有Key，而Map有一个Key和Key所对应的Value两个元素。
   Map和Hash_Map的区别是Hash_Map使用了Hash算法来加快查找过程，但是需要更多的内存来存放这些Hash桶元素。

###  std::pair 

 pair是将2个数据组合成一个数据，当需要这样的需求时就可以使用pair，如stl中的map就是将key和value放在一起来保存。另一个应用是，当一个函数需要返回2个数据的时候，可以选择pair。 pair的实现是一个结构体，主要的两个成员变量是first second 因为是使用struct不是class，所以可以直接使用pair的成员变量 。

```c++
pair<int, double> p1;  //声明
p1 = make_pair(1, 1.2);//赋值
pair<int, double> p2(1, 2.4);  //声明并赋初值
pair<int, double> p3(p2);  //声明并拷贝初值
//访问元素
p1.first = 1;
p1.second = 2.5;
cout << p1.first << ' ' << p1.second << endl;
```

### 关联容器set

 **顺序容器**包括vector、deque、list、forward_list、array、string，所有顺序容器都提供了快速顺序访问元素的能力。 

 **关联容器**包括set、map ，关联容器没有顺序，通过关键字查找元素保存和访问（类似struct）

 关联容器和顺序容器有着根本的不同：关联容器中的元素是按关键字来保存和访问的。与之相对，顺序容器中的元素是按它们在容器中的位置来顺序保存和访问的 。

 关联容器支持高效的关键字查找和访问。两个主要的关联容器(associative container)类型是map和set。**map中的元素是一些关键字----值(key--value)对**：关键字起到索引的作用，值则表示与索引相关联的数据。**set中每个元素只包含一个关键字**：set支持高效的关键字查询操作----检查一个给定关键字是否在set中 。

 set就是关键字的简单集合。当只是想知道一个值是否存在时，set是最有用的 。

 标准库提供set关联容器分为： 

1. 按关键字有序保存元素：set(关键字即值，即只保存关键字的容器)；multiset(关键字可重复出现的set) 。

2.  无序集合：unordered_set(用哈希函数组织的set)；unordered_multiset(哈希组织的set，关键字可以重复出现) 。

 在set中每个元素的值都唯一，而且系统能根据元素的值自动进行排序。set中元素的值不能直接被改变。set内部采用的是一种非常高效的平衡检索二叉树：红黑树，也称为RB树(Red-Black Tree)。RB树的统计性能要好于一般平衡二叉树。 

 **set具备的两个特点**：

1. set中的元素都是排序好的 
2. set中的元素都是唯一的，没有重复的 

set的使用

```c++

#include <iostream>
#include <set>
 
int main ()
{
  int myints[] = {75,23,65,42,13};
  std::set<int> myset (myints, myints+5);//初始化
 
  std::cout << "myset contains:";
  for (std::set<int>::iterator it=myset.begin(); it!=myset.end(); ++it)
    std::cout << ' ' << *it;
  std::cout << '\n';
  return 0;
}
//输出：
//myset contains: 13 23 42 65 75
```

set支持的操作

```c++
begin();            // 返回指向第一个元素的迭代器
end();              // 返回指向最后一个元素的迭代器
clear();            // 清除所有元素
count();            // 返回某个值元素的个数
 
empty();            // 如果集合为空，返回true
 
equal_range();      //返回集合中与给定值相等的上下限的两个迭代器
 
erase();			//删除集合中的元素
 
find();				//返回一个指向被查找到元素的迭代器
 
get_allocator();	//返回集合的分配器
 
insert();			//在集合中插入元素
 
lower_bound();		//返回指向大于（或等于）某值的第一个元素的迭代器
 
key_comp();			//返回一个用于元素间值比较的函数
 
max_size();			//返回集合能容纳的元素的最大限值
 
rbegin();			//返回指向集合中最后一个元素的反向迭代器
 
rend();				//返回指向集合中第一个元素的反向迭代器
 
size();				//集合中元素的数目
 
swap();				//交换两个集合变量
 
upper_bound();		//返回大于某个值元素的迭代器
 
value_comp();		//返回一个用于比较元素间的值的函数
```

### 多线程

https://blog.csdn.net/ktigerhero3/article/details/78249266/

#### 建立多个线程

```c++
#include <Windows.h>
#include <iostream>
#include <thread>
using namespace std;
void sayHello()
{
	while(1)
	{
		Sleep(1000);//单位毫秒
		cout << endl << "hello" << endl;
	}
}
void sayWorld()
{
	while(1)
	{
		Sleep(1000);
		cout << endl << "world" << endl;
	}
}
int main()
{
	thread threadHello(&sayHello);
	thread threadWorld(&sayWorld);
	threadHello.join();
	threadWorld.join();
	return 0;
}
```

#### 线程加互斥锁mutex

```c++
#include <Windows.h>
#include <iostream>
#include <thread>
#include <mutex>

std::mutex mymutex;
void sayHello()
{
	int k = 0;
	std::unique_lock<std::mutex> lock(mymutex);//threadHello先运行，先加锁
	while (k < 4)
	{
		k++;
		std::cout << "hello" << std::endl;
		Sleep(2000);
	}
}
void sayWorld()
{
	int k = 0;
	std::unique_lock<std::mutex> lock(mymutex);//threadWorld后运行，要等待mymutex锁释放
	while (k <5)
	{
		k++;
		std::cout << "world" << std::endl;
		Sleep(1000);
	}
}
int main()
{
	std::thread threadHello(&sayHello);
	std::thread threadWorld(&sayWorld);
	threadHello.join();
	threadWorld.join();
	return 0;
}
//说明：定义完std::unique_lock<std::mutex>就会检查mymutex的状态，如果mymutex已被锁住，就等待；如果未被锁住，就把它锁住。所以叫互斥锁
```

输出

```
hello
hello
hello
hello
world
world
world
world
world
```

**程序运行说明**

程序运行步骤是这样的： 
首先同时运行threadHello线程和threadWorld线程 ；先进入threadHello线程的sayHello()函数，这个时候加了mymutex锁，另外一个threadWorld线程进入后发现mymutex锁没有释放，只能等待；当过去4个循环（每个循环2秒后）threadHello线程结束，unique_lock lock(mymutex)的生命周期结束，mymutex锁释放，执行threadWorld线程，此时开始一直say world。

**使用说明**

unique_lock中的unique表示独占所有权。 
unique_lock独占的是mutex对象，就是对mutex锁的独占

用法： 
（1）新建一个unique_lock 对象 
（2）给对象传入一个std::mutex 对象作为参数; 

```c++
std::mutex  mymutex; 
unique_lock lock(mymutex);
```

由于unique_lock lock(mymutex)的存在，这个函数结束后会自动解锁（也可以手动unlock）。 加锁的结果是使当前线程运行时别的线程等待不动。注意定义mutex的位置。

#### join和detach

`thread.join();`使用join时，原始线程（主线程）会等待新线程执行结束后（阻塞），再去销毁原始线程对象

`thread.detach();`使用detch时，新线程与原线程分离，如果原线程先执行完毕，就销毁原线程对象及局部变量

如果不加join或detach，默认就是detach的效果，因为定义thread时就已经启动子线程了，然后主线程运行完就退出

#### 互斥锁mutex和全局条件变量condition_variable

```c++
#include <iostream>
#include <thread>
#include <mutex>
#include <condition_variable>

std::mutex mtx;              // 全局互斥锁
std::condition_variable cv;  // 全局条件变量

void do_print_id(int id)
{
	std::unique_lock <std::mutex> lck(mtx);	// 获取互斥锁
	cv.wait(lck);							// 使用wait实现线程同步。现在是阻塞状态，当cv收到全局通知时解除wait阻塞
	//解释：当某个线程先获得锁后，会处于wait的阻塞状态。如果某个线程没有获得锁，就会处于锁的阻塞状态。
	//总之都是在阻塞。当收到cv的通知时，所以线程抢夺mtx锁

	// 当全局标志位变为 true 之后，线程被唤醒，继续往下执行打印线程编号id
	std::cout << "thread " << id << '\n';
}

void go()
{
	std::unique_lock <std::mutex> lck(mtx);
	cv.notify_all();	// 唤醒所有线程
}

int main()
{
	std::thread threads[10];
	for (int i = 0; i < 10; ++i)
		threads[i] = std::thread(do_print_id, i);
	std::cout << "启动了10个线程...\n";	//启动了10个线程，其中有一个处于wait阻塞，其他9个处于mutex阻塞
	go();								// 通过全局条件变量通知所有线程解除wait(其实就一个线程，但不知道是哪个)

	for (auto & th : threads)
		th.join();//join防止主线程先于子线程退出
	return 0;
}
```

互斥锁实现了多个线程中，同一时间只有一个线程能执行某个操作。全局条件变量通过wait能同时给多个线程发出指令，实现线程同步

### 异步编程std::async和std::future

 std::asyanc是std::future的高级封装， 一般我们不会直接使用std::futrue，而是使用对std::future的高级封装std::async 。[链接](https://www.cnblogs.com/moodlxs/p/10111601.html)

#### std::async基本用法

`std::future`可以从异步任务中**获取结果**，一般与std::async配合使用，`std::async`用于**创建异步任务**，实际上就是创建一个线程执行相应任务。

std::async就是异步编程的高级封装，封装了std::future的操作，基本上可以代替std::thread 的所有事情。

std::async的操作，其实相当于封装了std::promise、std::packaged_task加上std::thread。

```c++
#include <future>
#include <iostream>

bool is_prime(int x)//判断是不是素数
{
	for (int i = 2; i < x; i++)
	{
		if (x % i == 0)
			return false;
	}
	return true;
}

int main()
{
	std::future<bool> fut = std::async(is_prime, 700020007);
	//std::async首先创建线程执行is_prime(700020007)，创建后立即执行
	std::cout << "please wait";
	std::chrono::milliseconds span(100);
	while (fut.wait_for(span) != std::future_status::ready)
        //等待线程执行完成（等100ms之后查询是不是ready了，不是就继续while）
		std::cout << ".";
	std::cout << std::endl;
	//fut.wait_for(span)也可写作fut.wait_for(std::chrono::milliseconds(100))
	bool ret = fut.get();//获取执行结果
	std::cout << "final result: " << ret << std::endl;
	return 0;
}
//输出：
//please wait................
//final result: 1
```

 上面先说了通用的做法，然后我们了解一下std::future、std::promise、std::packaged_task 

#### std::future说明

 future是std::async、std::promise、std::packaged_task的底层对象，用来传递其他线程中操作的数据结果。 

#### std::promise用法 

 std::promise的作用就是提供一个**不同线程之间的数据同步**机制，它可以存储一个某种类型的值，并将其传递给对应的future， 即使这个future不在同一个线程中也可以安全的访问到这个值 。

```c++
// promise example
#include <iostream>       // std::cout
#include <functional>     // std::ref
#include <thread>         // std::thread
#include <future>         // std::promise, std::future

void print_int(std::future<int>& fut)
{
	int x = fut.get();
	std::cout << "value: " << x << '\n';
}

int main()
{
	std::promise<int> prom;                    // 创建promise用来（在不同线程间）同步数据
	std::future<int> fut = prom.get_future();  // promise的future
	std::thread th1(print_int, std::ref(fut)); // 把future发送到新的线程
	prom.set_value(10);                        // 给promise输入数据，线程th1可以同步更新这个数据
	th1.join();                                // 启动线程
	// 线程th1的函数通过fut可以get到prom中的参数
	return 0;
}
```

#### std::packaged_task用法

 std::packaged_task的作用就是提供一个**不同线程之间的数据同步机制**，它可以存储一个函数操作，并将其返回值传递给对应的future， 而这个future在另外一个线程中也可以安全的访问到这个值。 

```c++
// packaged_task example
#include <iostream>     // std::cout
#include <future>       // std::packaged_task, std::future
#include <chrono>       // std::chrono::seconds
#include <thread>       // std::thread, std::this_thread::sleep_for

// 为每个值倒计时一秒：
int countdown(int from, int to)
{
	for (int i = from; i != to; --i)
	{
		std::cout << i << std::endl;
		std::this_thread::sleep_for(std::chrono::seconds(1));//线程休眠1秒
	}
	std::cout << "倒计时结束!" << std::endl;
	return from - to;//10-0
}

int main()
{
	std::packaged_task<int(int, int)> tsk(countdown);   // 创建packaged_task
	std::future<int> ret = tsk.get_future();            // 获取它的future

	std::thread th(std::move(tsk), 10, 0);				// 生成线程以从10倒计时到0

	// ...

	int value = ret.get();                  // 等待线程完成并得到结果

	std::cout << "倒计时持续了" << value << "秒" << std::endl;

	th.join();

	return 0;
}
```

```
10
9
8
7
6
5
4
3
2
1
倒计时结束!
倒计时持续了10秒
```

### 左值，右值，左值引用，右值引用

[链接](https://blog.csdn.net/xiaolewennofollow/article/details/52559306)

#### 左值和右值

**左值**，就是有名字的变量（对象），可以被赋值，可以在多条语句中使用。

**右值**，就是临时变量（对象），没有名字，只能在一条语句中出现，不能被赋值 。

#### 左值引用和右值引用

 左值引用的声明符号为”&”， 为了和左值区分，右值引用的声明符号为”&&”。 

```c++
#include <iostream>

void process_value(int& i)
{
	std::cout << "左值引用: " << i << std::endl;
}

void process_value(int&& i)
{
	std::cout << "右值引用: " << i << std::endl;
}

int main()
{
	int a = 0;
	process_value(a);
	process_value(1);
	return 0;
}
// 结果为：
//左值引用: 0
//右值引用: 1
```

 被声明为右值引用的，它本身被看作左值或右值都可以。区分的标准是：如果它有一个名字，那么它是一个左值。否则，它是一个右值。 

```c++
int main()
{
	int a = 0;
	process_value(a);
	int&& b = 1;
	process_value(b);
	return 0;
}
// 结果为：
//左值引用: 0
//左值引用: 1
```

b是一个右值引用，指向一个右值1，但是由于b是有名字的，所以b在这里被视为一个左值，所以在函数重载的时候选择为第一个函数 。

#### 右值引用的意义

 直观**意义**：为临时变量续命，也就是为右值续命，因为右值在表达式结束后就消亡了，如果想继续使用右值，那就会动用昂贵的拷贝构造函数。 

 **右值引用是用来支持转移语义的**。转移语义可以将资源 ( 堆，系统对象等 ) 从一个对象转移到另一个对象，这样能够减少不必要的临时对象的创建、拷贝以及销毁，能够大幅度提高 C++ 应用程序的性能。临时对象的维护 ( 创建和销毁 ) 对性能有严重影响。 

 **转移语义**是和拷贝语义相对的，可以类比文件的剪切与拷贝，当我们将文件从一个目录拷贝到另一个目录时，速度比剪切慢很多。通过转移语义，临时对象中的资源能够转移其它的对象里。

> 在现有的 C++ 机制中，我们可以定义拷贝构造函数和赋值函数。要实现转移语义，需要定义转移构造函数，还可以定义转移赋值操作符。对于右值的拷贝和赋值会调用转移构造函数和转移赋值操作符。如果转移构造函数和转移拷贝操作符没有定义，那么就遵循现有的机制，拷贝构造函数和赋值操作符会被调用。
> 普通的函数和操作符也可以利用右值引用操作符实现转移语义。

### std::move 左值引用转右值引用 

在C++11中，标准库在\<utility>中提供了一个有用的函数std::move，std::move并不能移动任何东西，它唯一的功能是将一个左值强制转化为右值引用，继而可以通过右值引用使用该值，以用于移动语义。从实现上讲，std::move基本等同于一个类型转换：static_cast<T&&>(lvalue);

> 1. C++ 标准库使用比如vector::push_back 等这类函数时,会对参数的对象进行复制,连数据也会复制.这就会造成对象内存的额外创建, 本来原意是想把参数push_back进去就行了,通过std::move，可以避免不必要的拷贝操作。
> 2. std::move是将对象的状态或者所有权从一个对象转移到另一个对象，只是转移，**没有内存的搬迁或者内存拷贝所以可以提高利用效率,改善性能**。
> 3. 对指针类型的标准库对象并不需要这么做。

**用法**

```c++
#include <iostream>
#include <utility>//std::move
#include <vector>
#include <string>
int main()
{
	std::string str = "Hello";
	std::vector<std::string> v;
	//调用常规的拷贝构造函数，新建字符数组，拷贝数据
	v.push_back(str);
	std::cout << "拷贝之后，str是：\"" << str << "\"\n";
	//调用move构造函数，掏空str，掏空后，最好不要使用str
	v.push_back(std::move(str));
	std::cout << "move之后，str是：\"" << str << "\"\n";
	std::cout << "vector的内容是：\"" << v[0] << "\", \"" << v[1] << "\"\n";
	system("pause");
}
```

### ref和引用&的区别

 c++ 中 本身可以使用 & 来实现引用 ，那为什么还会出现ref 呢？ 

ref

```c++
#include <iostream>
using namespace std;

void f2(int &c)
{
	c++;
	cout << "in function c = " << c << endl;
}
int main()
{
	int c = 10;
	f2(ref(c));
	cout << "out function c = " << c << endl;
	return 0;
}
```

&

```c++
#include <iostream>
using namespace std;

void f2(int &c)
{
	c++;
	cout << "in function c = " << c << endl;
}
int main()
{
	int c = 10;
	f2(c);
	cout << "out function c = " << c << endl;
	return 0;
}
```

结果是一样的：

```
in function c = 11
out function c = 11
```

**区别在于**考虑函数式编程（如std::bind）在使用时，是对参数直接拷贝，而不是引用 

```c++
#include <string>
#include <iostream>
#include<boost/function.hpp>
#include<boost/bind.hpp>

void f(int &a,int &b,int &c){
    cout<<"in function a = "<<a<<"  b = "<<b<<"  c = "<<c<<endl;
    a += 1;
    b += 10;
    c += 100;
}
 
int main(){
    int n1 = 1 ,n2 = 10,n3 = 100;
    function<void()> f1 = bind(f,n1,n2,ref(n3));
    f1();
    cout<<"out function a = "<<n1<<"  b = "<<n2<<"  c = "<<n3<<endl;
    f1();
    cout<<"out function a = "<<n1<<"  b = "<<n2<<"  c = "<<n3<<endl;
    return 0;
}
```

输出：

```
in function a = 1  b = 10  c = 100
out function a = 1  b = 10  c = 200
in function a = 2  b = 20  c = 200
out function a = 1  b = 10  c = 300
```

解释：使用ref实现了参数的引用（ 在用bind直接传参数时，如果不用ref时，调用函数是没有引用的 ）。

 不仅仅是在使用bind时，在使用thread进行编程时，也会发生这样的问题，thread的方法传递引用的时候，必须外层用ref来进行引用传递，否则会编译出错。 

```c++
void method(int & a){ a += 5;}
 
using namespace std;
int main()
{
    int a = 0;
    thread th(method,ref(a));
    th.join();
    cout << a <<endl;
    //thread th2(method,a);  //去掉注释会编译出错
    //th2.join();
    cout << a <<endl;
    return 0;
}
```

### operator重载运算符

 operator 是C++的一个关键字，它和运算符（如=、==、()）一起使用，表示一个**运算符重载**函数，在理解时可将operator和运算符（如operator=）视为一个函数名 。

 使用operator重载运算符，是C++扩展运算符功能的方法。使用operator扩展运算符功能的原因如下： 

- 使重载后的运算符的使用方法与重载前一致 

- 扩展运算符的功能只能通过函数的方式实现（实际上，C++中各种“功能”都是由函数实现的） 

**示例：**重载==运算符

```c++
#include <iostream>
using namespace std;
class person
{
private:
	int age;
public:
	person(int nAge)
	{
		this->age = nAge;
	}

	bool operator==(const person& ps)//重载==运算符
	{
		if (this->age == ps.age)
		{
			return true;
		}
		return false;
	}
};

int main()
{
	person p1(10);
	person p2(10);

	if (p1 == p2)
	{
		cout << "p1和p2相等" << endl;
	}
	else
	{
		cout << "p1和p2不相等" << endl;
	}
	return 0;
}
//结果：p1和p2相等
```

### std::for_each

 for_each有三个参数，前两个参数用来确定一个区间，第三个参数则是操作方式，lambda，函数对象或者普通函数都可以充当其第三个参数 。

```c++
#include <algorithm>
#include <iostream>
#include <vector>
#include <string>
using namespace std;

void helperFunction(string& str)
{
	str += ".cpp";
}

void print(vector<string> vec)
{
	for (vector<string>::iterator iter = vec.begin(); iter != vec.end(); iter++)
	{
		cout << *iter << "\t";
	}
	cout << endl;
}

int main(void)
{
	string vecVal[] = { "a", "b", "c", "d" };//string数组
	vector<string> vec(vecVal, vecVal + 4);//数组加载到vector
	print(vec);
	for_each(vec.begin(), vec.end(), helperFunction);
	//for_each会自动给helperFunction输入参数 *vec.begin()，（每次迭代vec.begin()++）
	print(vec);
	return 0;
}
//输出：
//a       b       c       d
//a.cpp   b.cpp   c.cpp   d.cpp
```

 for_each()有一个特殊的性质，那就是它能够返回其操作，利用这一特性，我们可以处理“置于该操作中的结果”直接看下面这个例子： 

```c++
#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

class MeanValue
{
private:
	long num;
	long sum;
public:
	MeanValue() : num(0), sum(0) {}//无参数的构造函数
	void operator() (int elem)//重载() (int elem)
	{
		num++;
		sum += elem;
	}
	operator double()//重载double
	{
		return static_cast<double>(sum) / static_cast<double>(num);
	}
};


int main()
{
	std::vector<int>v1{ 1,2,3,4,5,6,7,8 };
	double db = std::for_each(v1.begin(), v1.end(), MeanValue());
	//for_each不断迭代向MeanValue()传递int，迭代完成后执行执行隐式的int转换到double（也被重载了）
	std::cout << db;
	return 0;
}
//结果：4.5
```

double db = std::for_each(v1.begin(), v1.end(), MeanValue());通过观看源码，我们知道for_each的返回值是其第三个参数。而我们的第三个参数明明是一个class，为什么我们可以赋值给一个double类型？

这里我们就要注意了，在MeanValue类中我们有一个特殊的重载，operator double()｛...｝ ，这个重载就是为了提供该类隐式转换为double的方法，所以我们可以将该类隐式转换为double类型。

### vector转list

```c++
vector<Point2f> point_set(SampPoints.begin(),SampPoints.end());
```

### double转string

[参考](https://www.cnblogs.com/chorulex/p/7660187.html)

```c++
#include <iostream>
#include <sstream>

using namespace std;

std::string DoubleToString(const double value, unsigned int precisionAfterPoint = 6)
{
	std::ostringstream out;
	// 清除默认精度
	out.precision(std::numeric_limits<double>::digits10);
	out << value;

	std::string res = std::move(out.str());
	auto pos = res.find('.');
	if (pos == std::string::npos)
		return res;
	auto splitLen = pos + 1 + precisionAfterPoint;
	if (res.size() <= splitLen)
		return res;
	return res.substr(0, splitLen);
}

int main(int argc, char* argv[])
{
	std::cout << DoubleToString(0., 12) << std::endl;
	std::cout << DoubleToString(0.0, 12) << std::endl;
	std::cout << DoubleToString(.0, 12) << std::endl;
	std::cout << DoubleToString(1.0, 12) << std::endl;
	std::cout << DoubleToString(11234, 12) << std::endl;
	std::cout << DoubleToString(0.12345, 12) << std::endl;
	std::cout << DoubleToString(0.12345678, 12) << std::endl;
	std::cout << DoubleToString(0.12345678, 9) << std::endl;
	std::cout << DoubleToString(0.12345678, 8) << std::endl;
	std::cout << DoubleToString(0.12345678, 6) << std::endl;
	return 0;
}

//输出：
//0
//0
//0
//1
//11234
//0.12345
//0.12345678
//0.12345678
//0.12345678
//0.123456
```

### std::move避免内存搬迁拷贝

- C++ 标准库使用比如`vector::push_back `等这类函数时，会对参数的对象进行复制,连数据也会复制。这就会造成对象内存的额外创建，本来原意是想把参数push_back进去就行了，通过std::move，可以避免不必要的拷贝操作。
- `std::move`是**将对象的状态或者所有权从一个对象转移到另一个对象**，只是转移，没有内存的搬迁或者内存拷贝所以可以提高利用效率，改善性能。
- 对指针类型的标准库对象并不需要这么做。

**用法**

```c++
#include <iostream>
#include <utility>
#include <vector>
#include <string>
int main()
{
	std::string str = "Hello";
	std::vector<std::string> v;
	//调用常规的拷贝构造函数，新建字符数组，拷贝数据
	v.push_back(str);
	std::cout << "push_back后，str是：\"" << str << "\"\n";
	//调用移动构造函数，掏空str，掏空后，最好不要使用str
	v.push_back(std::move(str));
	std::cout << "move并push_back后，str是：\"" << str << "\"\n";
	std::cout << "vrctor内容是：\"" << v[0] << "\", \"" << v[1] << "\"\n";
	return 0;
}
```

输出：

```
push_back后，str是："Hello"
move并push_back后，str是：""
vrctor内容是："Hello", "Hello"
```

### accumulate累加

```c++
int sum = accumulate(vec.begin() , vec.end() , 0);
```

accumulate带有三个形参：前两个形参指定要累加的元素范围，第三个形参是累加的初值

### Lambda表达式

C++ 11 中的 Lambda 表达式用于定义并创建匿名的函数对象，以简化编程工作。形式如下：

```
[函数对象参数] (操作符重载函数参数) mutable 或 exception 声明 -> 返回值类型 {函数体}
```

[]：固定给函数输入的参数（不是调用时输入的，所以叫函数对象参数）

()：函数的输入参数

mutable：可以修改[]里输入的参数的拷贝

esception：声明抛出异常

-> 类型：函数的返回类型

**示例**

```c++
[] (int x, int y) { return x + y; } // 隐式返回类型
[] (int& x) { ++x; } // 没有 return 语句 -> Lambda 函数的返回类型是 'void'
[] () { ++global_x; } // 没有参数，仅访问某个全局变量
[] { ++global_x; } // 与上一个相同，省略了 (操作符重载函数参数)
```

**指定返回类型**

```c++
[] (int x, int y) -> int { int z = x + y; return z; }
```

**for_each结合Lambda表达式**

```c++
#include <vector>
#include <iostream>
#include <algorithm>

int main()
{
	std::vector<int> some_list;
	int total = 0;
	for (int i = 0; i < 5; ++i) some_list.push_back(i);
	std::for_each( begin(some_list), end(some_list),[&total](int x){total += x;} );
	std::cout << total;
	return 0;
}
//输出：10
//1+2+3+4=10
```

**类中使用this**

```c++
std::vector<int> some_list;
int total = 0;
int value = 5;
std::for_each(begin(some_list), end(some_list), [&, value, this](int x)
{
    total += x * value * this->some_func();
});
```

对 protect 和 private 成员来说，这个 Lambda 函数与创建它的成员函数有相同的访问控制。如果 this 被捕获了，不管是显式还是隐式的，那么它的类的作用域对 Lambda 函数就是可见的。访问 this 的成员不必使用 this-> 语法，可以直接访问。

### 拷贝构造函数

对于普通类型的对象来说，它们之间的复制是很简单的，例如：

```c++
int a=100;
int b=a;
```

对于类对象的拷贝，我们可以定义**拷贝构造函数**来实现类对象的拷贝：

```c++
#include<iostream>
using namespace std;
class CExample
{
private:
	int a;
public:
	//构造函数
	CExample(int b)
	{
		a = b;
		printf("调用构造函数\n");
	}
	//拷贝构造函数
	CExample(const CExample & c)
	{
		a = c.a;
		printf("调用拷贝构造函数\n");
	}
	//析构函数
	~CExample()
	{
		cout << "析构函数\n";
	}
	void Show()
	{
		cout << a << endl;
	}
};
int main()
{
	CExample A(100);//构造
	CExample B = A;	//拷贝构造
	B.Show();
	return 0;
}
//输出：100
```

CExample(const CExample& C)就是我们自定义的拷贝构造函数。可见，拷贝构造函数是一种特殊的**构造函数**，函数的名称必须和类名称一致，它必须的一个参数是本类型的一个**引用变量**。

### malloc 函数

**`malloc()`在运行期间从堆中动态分配分配内存，`free()`释放由其分配的内存。**

**malloc()可以用来在定义为止大小的数组。**

malloc()在分配用户传入的大小的时候，还分配的一个相关的用于管理的额外内存，不过，用户是看不到的。所以，实际的大小 = 管理空间 + 用户空间。

> 堆中的内存块总是成块分配的，并不是申请多少字节，就拿出多少个字节的内存来提供使用。堆中内存块的大小通常与内存对齐有关（8Byte(for 32bit system)或16Byte(for 64bit system)。

> 因此，在64位系统下，当(申请内存大小+sizeof(struct mem_control_block) )% 16 == 0的时候，刚好可以完成一次满额的分配，但是当其!=0的时候，就会多分配内存块。

**示例**

```c++
#include <stdio.h>
#include <malloc.h>

//功能：求1+2+ ... +n的值

int sum(int n)
{
	int ret = 0;//返回值

	// 定义n个int元素的数组（申请堆内存）
	// 直接用int intArry[n];不行，n必须为常量，这就是用malloc的意义
	int* intArray = (int*)malloc(n * sizeof(int));

	for (int i = 0; i < n; ++i)
	{
		intArray[i] = i + 1;//数组中存的1...n
	}

	for (int i = 0; i < n; i++)
	{
		ret += intArray[i];//累加1...n
	}

	free(intArray);//释放内存
	
	return ret;
}

int main()
{
	int n = 12;
	printf("%d\n", sum(n));
	return 0;
}
//输出：78
```

### calloc函数

**描述**

C 库函数 **void \*calloc(size_t nitems, size_t size)** 分配所需的内存空间，并返回一个指向它的指针。**malloc** 和 **calloc** 之间的不同点是，malloc 不会设置内存为零，而 calloc 会设置分配的内存为零。

**声明**

下面是 calloc() 函数的声明。

```
void *calloc(size_t nitems, size_t size)
```

**参数**

- **nitems** -- 要被分配的元素个数。

- **size** -- 元素的大小。

  ```c
  #include <stdio.h>
  #include <stdlib.h>
   
  int main()
  {
     int i, n;
     int *a;
   
     printf("要输入的元素个数：");
     scanf("%d",&n);
   
     a = (int*)calloc(n, sizeof(int));
     printf("输入 %d 个数字：\n",n);
     for( i=0 ; i < n ; i++ ) 
     {
        scanf("%d",&a[i]);
     }
   
     printf("输入的数字为：");
     for( i=0 ; i < n ; i++ ) {
        printf("%d ",a[i]);
     }
     free (a);  // 释放内存
     return(0);
  }
  ```

### memset设置内存

作用是将某一块内存中的内容全部设置为指定的值

void *memset(void *s, int ch, size_t n);

函数解释：将s中当前位置后面的n个字节用 ch 替换并返回 s 。

### vector排序

```c++
#include <iostream>
#include <vector>
#include <algorithm>

int main(int argc, char* argv[])
{
	int s[] = { 1,6,3,2,5 };
	std::vector<int> vec(s, s + 5);	/// 数组初始化vector
	//正向排序：按照从小到大的顺序排序
	std::sort(vec.begin(), vec.end());
	// 输出排序结果
	for (std::vector<int>::iterator it = vec.begin(); it != vec.end(); it++)
	{
		std::cout << *it << " ";
	}
	std::cout << std::endl;

	//逆向排序：按照从大到小的顺序进行排序
	sort(vec.rbegin(), vec.rend());/// 前面std::sort过了,可以不加std::
	for (std::vector<int>::iterator it = vec.begin(); it != vec.end(); it++) {
		std::cout << *it << " ";
	}
	std::cout << std::endl;
	return 0;
}
// 输出：
// 1 2 3 5 6
// 6 5 3 2 1
```

### vector截取

```c++
#include <iostream>
#include <vector>
using namespace std;
int main(int argc, char* argv[])
{
	vector<int> tmp = { 0,1,2,3,4,5 };

	// vector下标从0开始
	// 注意这里是<=。begin()到 begin() + n 表示前n+1个元素
	for (vector<int>::iterator iter = tmp.begin(); iter <= tmp.begin() + 3; ++iter)
		cout << *iter << "\t";
	cout << endl;

	// 截取vector。第0到第n-1个元素，共n个
	vector<int> tmp2(tmp.begin(), tmp.begin() + 3);
	for (auto iter : tmp2)
		cout << iter << "\t";
	cout << endl;

	return 0;
}
// 输出：
// 0 1 2 3
// 0 1 2
```

### 动态申请二维数组(c)

```c
int** malloc2d(int row, int col)
{
    int** ret = (int **) malloc(sizeof(int*) * row);	//指向每行的首地址
    int* p = (int*)malloc(sizeof(int) * row col);	// int指针类型就是int数组类型
    
    if(p && ret)
    {
        for(int i = 0; i < rpw; ++i)
        {
            ret[i] = p + i * col;	// 使ret的每个元素指向p中对应行的首地址
        }
    }
    else
    {
        free(ret);
        free(p);
        ret = NULL;
    }
    
    return ret;
}
```

### 排序

```c++
// 从小到大
#include<cstdio>
#include<algorithm>
using namespace std;
int main()
{
    int i,a[50]={2,3,5,1,-1};
    sort(a,a+5);//规定排序的范围
    for(i=0;i<5;i++)
        printf("%d ",a[i]);
    return 0;
}
```

```c++
// 从大到小
#include<cstdio>
#include<algorithm>
using namespace std;
bool cmp(int x,int y)
{
    return x>y;
}
int main()
{
    int i,a[50]={2,3,5,1,-1};
    sort(a,a+5,cmp);
    for(i=0;i<5;i++)
        printf("%d ",a[i]);
    return 0;
}
```

### 申请动态数组

```c++
#include<iostream>
using namespace std;
int main()
{
	int n;   //输入数组长度
	cin >> n;
	int *p;  //声明一个指针
	p = new int[n]; /*创建了一个长度为n的动态数组，并且返回这个数组的首地址给p，p就指向了这个动态数组，可以通过指针p
				  来操作数组，因为创建的动态数组并没有名字，只返回了首地址给p，所以可以把p看作是这个动态数组的名字 */
	for (int i = 0; i < n; i++)
		cin >> p[i];
	for (int i = 0; i < n; i++)
		cout << p[i] << " ";
	delete[]p;  //释放这个一维的动态数组，而不是释放指针p。用完以后要记得释放掉
	cout << p;    //输出指针p的地址
	return 0;
}
```

### 按行读取数据

```c++
// 未知个数
#include <iostream>
#include<algorithm>
using namespace std;
int main()
{
	int a[500]; int m = 0; int temp; char c;

	cin >> a[m++]; //读取输入行的第一个字符
	while ((c = getchar()) != '\n') //读取输入行的第二个字符(" "),之后循环
	{
		cin >> temp;//读取输入行的第三个字符
		a[m++] = temp;
	}
	return 0;
}
```

```c++
//读取
char name[20];
cin.getline(name, 20);

#include <string>
string name;
getline(cin, name);
```

### 字符串字符统计

```c++
#include <iostream>
#include <algotirhm>
#include <string>
using namespace std;
int main()
{
    string temp = "aaabcdaaa!!!";
    int num = count(temp.begin(),temp.end(),'a');
    cout <<"在字符串" << temp << "中，" <<"字母a出现的次数是" << num << endl;
    return 0 ；
}
```

## 其他

### .和::和:和->的区别

1、A.B则A为对象或者结构体；

2、A->B则A为指针，->是成员提取，A->B是提取A中的成员B，A只能是指向类、结构、联合的指针；

3、::是作用域运算符，A::B表示作用域A中的名称B，A可以是名字空间、类、结构；

4、:一般用来表示继承；

**.和->的区别：** ->是指针指向其成员的运算符 .是结构体的成员运算符。最大的区别是->前面放的是指针，而.前面跟的是结构体变量 

```c++
struct A
{
   int a;
   int b;
};
A *point = malloc(sizeof(struct A));//直接分配内存块，point作为A *的指针指向这个内存块
point->a = 1;
A object;
object.a = 1;
```

### 类和对象的关系

**C++ 类定义**

定义一个类，本质上是定义一个数据类型的蓝图。这实际上并没有定义任何数据，但它定义了类的名称意味着什么，也就是说，它定义了类的对象包括了什么，以及可以在这个对象上执行哪些操作。

类定义是以关键字 **class** 开头，后跟类的名称。类的主体是包含在一对花括号中。类定义后必须跟着一个分号或一个声明列表。例如，我们使用关键字 **class** 定义 Box 数据类型，如下所示

```c++
class Box
{
   public:
      double length;   // 盒子的长度
      double breadth;  // 盒子的宽度
      double height;   // 盒子的高度
};
```

 关键字 **public** 确定了类成员的访问属性。在类对象作用域内，公共成员在类的外部是可访问的。也可以指定类的成员为 **private** 或 **protected**。 

**定义 C++ 对象**

 类提供了对象的蓝图，所以基本上，对象是根据类来创建的。声明类的对象，就像声明基本类型的变量一样。下面的语句声明了类 Box 的两个对象： 

```c++
Box Box1;          // 声明 Box1，类型为 Box
Box Box2;          // 声明 Box2，类型为 Box
```

 对象 Box1 和 Box2 都有它们各自的数据成员。 

**访问类的成员**

```c++
#include <iostream>
using namespace std;
class Box
{
   public:
      double length;   // 长度
      double breadth;  // 宽度
      double height;   // 高度
};
int main( )
{
   Box Box1;        // 声明 Box1，类型为 Box
   Box Box2;        // 声明 Box2，类型为 Box
   double volume = 0.0;     // 用于存储体积
   // box 1 详述
   Box1.height = 5.0; 
   Box1.length = 6.0; 
   Box1.breadth = 7.0;
   // box 2 详述
   Box2.height = 10.0;
   Box2.length = 12.0;
   Box2.breadth = 13.0;
   // box 1 的体积
   volume = Box1.height * Box1.length * Box1.breadth;
   cout << "Box1 的体积：" << volume <<endl;
   // box 2 的体积
   volume = Box2.height * Box2.length * Box2.breadth;
   cout << "Box2 的体积：" << volume <<endl;
   return 0;
}
```

 当上面的代码被编译和执行时，它会产生下列结果 ：

```
Box1 的体积：210
Box2 的体积：1560
```

### 代码行数

```sh
find . -name "*.h" -or -name "*.cpp"|xargs wc -l
```

### 声明和定义

```c++
void sum(int a,int b); //这是函数的声明
void sum(int a,int b){} //这是函数定义(没有分号)
void sum(int a,int b){};//也可以同时声明和定义
//同时声明和定义空函数(空的构造函数和析构函数)
KltHomographyInit()=default;
~KltHomographyInit()=default;//=default相当于{}
```

### virtual关键字

在基类的成员函数前加**virtual**关键字，表示希望重载的成员函数，用一个 基类指针或引用  指向一个继承类对象的时候，调用一个虚函数时, 实际调用的是继承类的版本

### deque容器

deque容器为一个给定类型的元素进行线性处理，像向量一样，它能够快速地随机访问任一个元素，并且能够高效地插入和删除容器的尾部元素。但它又与vector不同，deque支持高效插入和删除容器的头部元素，因此也叫做双端队列

### .c_str()函数

```c++
#include <iostream>  
#include <cstring>  
using namespace std;

int main()
{  
	const char *c;
	string s = "1234";
	c = s.c_str();
	cout << c << endl;
	s = "abcde";
	cout << c << endl;
}
```

输出：

```c++
1234
abcde
```

### friend友元

friend关键字的作用：在一个类中指明其他的类（或者）函数能够直接访问该类中的private和protected成员

### 用class和struct关键字的区别

实际上，我们可以使用 class 关键字和 struct 关键字中的任意一个定义类。

唯一的一点区别就是，struct 和 class 的默认访问权限不太一样。

如果使用 struct 关键字，则定义在第一个访问说明符之前的所有成员都默认是 public 的；

但如果使用 class关键字，那么定义在第一个访问说明符之前的成员默认都是 private 的

### C++ 构造函数后加冒号

其实冒号后的内容是初始化成员列表，一般有三种情况：
**1、对含有对象成员的对象进行初始化**

例如，类line有两个私有对象成员startpoint、endpoint,line的构造函数写成：

```c++
line（int sx,int sy,int ex,int ey）：startpoint（sx,sy）,endpoint（ex,ey）{……}
```

初始化时按照类定义中对象成员的顺序分别调用各自对象的构造函数，再执行自己的构造函数
**2、对于不含对象成员的对象，初始化时也可以套用上面的格式**

例如，类rectangle有两个数据成员length、width,其构造函数写成：

```c++
rectangle():length(1),width(2)){}
rectangle(int x,int y):length(x),width(y)){}
```

**3、对父类进行初始化**

例如，CDlgCalcDlg的父类是MFC类CDialog,其构造函数写为：

```c++
CDlgCalcDlg(CWnd* pParent): CDialog(CDlgCalcDlg::IDD,pParent)
```

其中IDD是一个枚举元素，标志对话框模板的ID
使用初始化成员列表对对象进行初始化，有时是必须的，有时是出于提高效率的考虑

### boost::function和boost::bind

 http://www.xumenger.com/cpp-boost-bind-function-20180612/ 

**1、boost::function**

 boost::function是一个函数包装器，也即一个函数模板，可以用来代替拥有相同返回类型，相同参数类型，以及相同参数个数的各个不同的函数 

```c++
#include<boost/function.hpp>
#include<iostream>
using namespace std;
typedef boost::function<int(int ,char)> Func;
int test(int num,char sign)
{
   cout << num << sign << endl;
   return 0;
}
int main()
{
    Func f;
    f = &test;  //or f = test;
    f(1, 'A');
}
```

它也可以用下面的函数指针形式实现

```c++
#include<iostream>
using namespace std;
typedef int (*Func)(int, char);
int test(int num,char sign)
{
   cout << num << sign << endl;
   return 0;
}
int main()
{
    Func f;
    f = &test;  //or f = test;
    f(1, 'A');
}
```

但是为什么还要用boost::function呢？

> 如果没有boost::bind，那么boost::function就什么都不是；而有了boost::bind，同一个类的不同对象可以delegate给不同的实现，从而实现不同的行为，简直就是无敌了

**2、boost::bind**

boost::function就像C#中的delegate，可以指向任何函数，包括成员函数（这点就是普通的函数指针做不到的！）

当用bind把某个成员函数绑定到某个对象上的时候，就可以得到一个closure（闭包）

```c++
#include <string>
#include <iostream>
#include<boost/function.hpp>
#include<boost/bind.hpp>

using namespace std;

class Foo{
    public:
        void methodA() { cout << "Foo::methodA()" << endl; }
        void methodInt(int a) { cout << "Foo::methodInt(" << a << ")" << endl; }
        void methodString(const string &str) { cout << "Foo::methodString(" << str << ")" << endl; }
};

class Bar{
    public:
        void methodB() { cout << "Bar::methodB()" << endl; }
        int methodTest(int a, char b, int c) 
        { 
            cout << "Bar::methodTest(" << a << ", " << b << ", " << c << ")" << endl;
            return 0;
        }
};

int main()
{
    //无参数，无返回值
    boost::function<void()> fun1;

    //调用foo.methodA()
    Foo foo;
    fun1 = boost::bind(&Foo::methodA, &foo);
    fun1();

    //调用bar.methodB()
    Bar bar;
    fun1 = boost::bind(&Bar::methodB, &bar);
    fun1();

    //调用foo.methodInt(42)
    fun1 = boost::bind(&Foo::methodInt, &foo, 42);
    fun1();

    //调用foo.methodString("hello")
    //bind的时候直接传入实参，这不就是闭包吗
    fun1 = boost::bind(&Foo::methodString, &foo, "hello");
    fun1();

    cout << endl;
    //int参数，无返回值
    boost::function<void(int)> fun2;
    //bind的时候未传入实参，需要_1作为参数的占位
    fun2 = boost::bind(&Foo::methodInt, &foo, _1);
    fun2(100);

    cout << endl;
    boost::function<int(int, int)> func3;
    //bind的时候未传入实参，需要_1、_2、_3作为参数的占位
    //下面传入一个实参，其他的用_n做占位符，很明显是一个闭包
    func3 = boost::bind(&Bar::methodTest, &bar, _1, 'z', _2);
    func3(1, 2);
}
```

### 内联函数inline

```c++
inline int Max (int a, int b)
{
    if(a >b)
        return a;
    return b;
}
```

增加了 `inline `关键字的函数称为“内联函数”。内联函数和普通函数的区别在于：当编译器处理调用内联函数的语句时，不会将该语句编译成函数调用的指令，而是直接将整个函数体的代码插人调用语句处，就像整个函数体在调用处被重写了一遍一样 

### VS点本地调试无法运行

原因是VS调试时起始目录是源文件的存放目录，而生成的exe文件在源文件目录的..\x64\Release下，如果c++程序使用相对路径，容易产生路径的错误

### struct和class

 C++中的struct是对C中的struct进行了扩充，所以增加了很多功能，主要的区别如下图所示： 

![在这里插入图片描述](/images/C++学习/20181122191431245.png) 

 上面罗列了在声明时的区别，在使用的过程中也有区别： 

 在C中使用结构体时需要加上struct，而C++可直接使用，例如： 

```c++
结构体声明，C和C++使用同一个
struct Student
{
	int  iAgeNum;
	string strName;
}
struct  Student  stu1;	//C中使用
Student    stu3;		//C++使用
```

**C++中Struct与Class的区别**

 struct默认防控属性是public的，而class默认的防控属性是private 

```c++
struct A
{
	int iNum;
}
class B
{
	int iNum;
}
A a;
a.iNum = 2;		//没有问题，默认防控属性为public
B b;
b.iNum = 2;		//编译出错，默认防控属性为private
```

 在继承关系，同样：struct默认是public的，而class是private 

```c++
struct A
{
	int   iAnum；
}
struct B : A
{
	int   iBnum;
}
A a；
a.iAnum = 1;	//在struct情况下是正确的，在class情况下是错误的
//在struct的情况下B是默认public继承A的。如果将上面的struct改成class，那么B是private继承A的
```

 上面的列子都是struct继承struct，class继承class，那么class与struct继承会怎样呢？ 

 结论是：**默认的防控属性取决于子类而不是基类**，例如： 

```c++
struct A{};
class B : A {};	//默认为private继承
struct C : B{};	//默认为public继承
```

### Eigen动态Matrix

```c++
Matrix<double, 6, Dynamic, ColMajor> jacobian;
//数值类型为double，行数为6，Dynamic表示动态矩阵（其大小根据运算需要确定），ColMajor表示按列存储
```

### cout.setf()设置输出格式

通过flag对cout输出的格式进行调整。如 `ios_base::fixed`表示：用正常的记数方法显示浮点数(与科学计数法相对应)；`ios_base::floatfield`表示小数点后保留6位小数 。

setf()函数有两个原型：

```c++
fmtflags setf(fmtflage) //第一原型
fmtflags setf(fmtflags, fmtflags)  //第二原型
```

原型一举例：

```c++
cout.setf(ios_base::showpos);
cout << 66 << endl;
//输出: +66
```

常见标志及作用：

| fmtflags   | 作用                                                        |
| ---------- | ----------------------------------------------------------- |
| boolalpha  | 可以使用单词”true”和”false”进行输入/输出的布尔值.           |
| oct        | 用八进制格式显示数值.                                       |
| dec        | 用十进制格式显示数值.                                       |
| hex        | 用十六进制格式显示数值.                                     |
| left       | 输出调整为左对齐.                                           |
| right      | 输出调整为右对齐.                                           |
| scientific | 用科学记数法显示浮点数.                                     |
| fixed      | 用正常的记数方法显示浮点数(与科学计数法相对应).             |
| showbase   | 输出时显示所有数值的基数.                                   |
| showpoint  | 显示小数点和额外的零，即使不需要.                           |
| showpos    | 在非负数值前面显示”＋（正号）”.                             |
| skipws     | 当从一个流进行读取时，跳过空白字符(spaces, tabs, newlines). |
| unitbuf    | 在每次插入以后，清空缓冲区.                                 |
| internal   | 将填充字符回到符号和数值之间.                               |
| uppercase  | 以大写的形式显示科学记数法中的”e”和十六进制格式的”x”.       |
| floatfield | 输出时按浮点格式，默认为小数点后有6位数字                   |

注意这些flag加前缀，如`ios::fixed`，有的是`ios_base::fixed `

举例

```c++
cout.setf(ios::fixed,ios::floatfield);
cout.precision(8);
//正常的记数方法显示浮点数、输出是按浮点数显示，小数点精度为8
//cout.precision()返回当前的浮点数输出精度值
//cout.precision(val)设置浮点数输出的精度
```

### chrono计时（s、ms、ns）

```c++
#include<iostream>
#include <chrono>
#include<Windows.h>
using namespace std;

class Timer {
public:
	static constexpr double SECONDS = 1e-9;///秒
	static constexpr double MILLISECONDS = 1e-6;///毫秒
	static constexpr double NANOSECONDS = 1.0;///纳秒
	Timer(double scale = MILLISECONDS);//默认的时间单位是毫秒
	virtual ~Timer();
	void start();
	double stop();
private:
	std::chrono::high_resolution_clock::time_point start_t;///开始计时的时间
	bool started;
	double scale;
};

int main(int argc, char * argv[])
{
	Timer timer1;
	timer1.start();
	Sleep(1000);
	double time = timer1.stop();
	cout <<"持续时间："<< time<< "毫秒" << endl;
	system("pause");
	return 0;
}

Timer::Timer(double scale) : started(false), scale(scale) { }
Timer::~Timer() { }

void Timer::start() {
	started = true;
	start_t = std::chrono::high_resolution_clock::now();
}

double Timer::stop() {
	std::chrono::high_resolution_clock::time_point end_t = std::chrono::high_resolution_clock::now();
	if (!started)
		throw std::logic_error("[Timer] Stop called without previous start");
	started = false;
	std::chrono::duration<double, std::nano> elapsed_ns = end_t - start_t;
	return elapsed_ns.count()*scale;
}
```

### 内联函数inline

 inline是C++关键字，在函数声明或定义中，函数返回类型前加上关键字inline，即可以把函数指定为内联函数。这样可以解决一些频繁调用的函数大量消耗栈空间（栈内存）的问题。关键字inline必须与函数定义放在一起才能使函数成为内联函数，仅仅将inline放在函数声明前面不起任何作用 

### push_back()和emplace_back()

push_back()函数向容器中加入一个临时对象（右值元素）时， 首先会调用构造函数生成这个对象，然后条用拷贝构造函数将这个对象放入容器中， 最后释放临时对象。但是emplace_back()函数向容器中中加入临时对象， 临时对象原地构造，没有赋值或移动的操作。

### 异常处理：try、catch、throw

```c++
#include <iostream>
using namespace std;
int main()
{
	int a, b;
	cin >> a >> b;
	try
	{
		if (b == 0)
			throw runtime_error("除数不能为0");//throw完了会直接跳出try
		cout << a / b << endl;
	}
	catch (runtime_error err)
	{
		cout << err.what() << endl;
	}
	cin >> a;
}
```

### 终端颜色

```c++
//the following are UBUNTU/LINUX ONLY terminal color codes.

#include <iostream>
#define RESET   "\033[0m"
#define BLACK   "\033[30m"      /* Black */
#define RED     "\033[31m"      /* Red */
#define GREEN   "\033[32m"      /* Green */
#define YELLOW  "\033[33m"      /* Yellow */
#define BLUE    "\033[34m"      /* Blue */
#define MAGENTA "\033[35m"      /* Magenta */
#define CYAN    "\033[36m"      /* Cyan */
#define WHITE   "\033[37m"      /* White */
#define BOLDBLACK   "\033[1m\033[30m"      /* Bold Black */
#define BOLDRED     "\033[1m\033[31m"      /* Bold Red */
#define BOLDGREEN   "\033[1m\033[32m"      /* Bold Green */
#define BOLDYELLOW  "\033[1m\033[33m"      /* Bold Yellow */
#define BOLDBLUE    "\033[1m\033[34m"      /* Bold Blue */
#define BOLDMAGENTA "\033[1m\033[35m"      /* Bold Magenta */
#define BOLDCYAN    "\033[1m\033[36m"      /* Bold Cyan */
#define BOLDWHITE   "\033[1m\033[37m"      /* Bold White */
 
int main(int argc, const char * argv[])
{
 
    // insert code here...
    std::cout< <RED      <<"Hello, World! in RED\n";
    std::cout<<GREEN    <<"Hello, World! in GREEN\n";
    std::cout<<YELLOW   <<"Hello, World! in YELLOW\n";
    std::cout<<BLUE     <<"Hello, World! in BLUE\n";
    std::cout<<MAGENTA  <<"Hello, World! in MAGENTA\n";
    std::cout<<CYAN     <<"Hello, World! in CYAN\n";
    std::cout<<WHITE    <<"Hello, World! in WHITE\n";
    std::cout<<BOLDRED  <<"Hello, World! in BOLDRED\n";
    std::cout<<BOLDCYAN <<"Hello, World! in BOLDCYAN\n";
    return 0;
}
```

```c++
//windows需要api
#include "stdafx.h"
#include <iostream>
#include <windows .h>
 
using namespace std;
 
void SetColor(unsigned short forecolor =4 ,unsigned short backgroudcolor =0)
{
	HANDLE hCon =GetStdHandle(STD_OUTPUT_HANDLE); //获取缓冲区句柄
	SetConsoleTextAttribute(hCon,forecolor|backgroudcolor); //设置文本及背景色
}
 
int _tmain(int argc, _TCHAR* argv[])
{
	SetColor(40,30);
	std::cout < <"Colored hello world for windows!\n";
	SetColor(120,20);
	std::cout <<"Colored hello world for windows!\n";
	SetColor(10,50);
	std::cout <<"Colored hello world for windows!\n";
	return 0;
}
```

### 精确时间（微秒ms）

```c++
#include <windows.h>
#include<iostream>
#include <sstream>

// 获取系统的当前时间，单位微秒(us)
int64_t GetSysTimeMicros()
{
	// 从1601年1月1日0:0:0:000到1970年1月1日0:0:0:000的时间(单位100ns)
	#define EPOCHFILETIME   (116444736000000000UL)
	FILETIME ft;
	LARGE_INTEGER li;
	int64_t tt = 0;
	GetSystemTimeAsFileTime(&ft);
	li.LowPart = ft.dwLowDateTime;
	li.HighPart = ft.dwHighDateTime;
	// 从1970年1月1日0:0:0:000到现在的微秒数(UTC时间)
	tt = (li.QuadPart - EPOCHFILETIME) / 10;
	return tt;
}

std::string DoubleToString(const double value, unsigned int precisionAfterPoint = 3)
{
	std::ostringstream out;
	// 清除默认精度
	out.precision(std::numeric_limits<double>::digits10);
	out << value;

	std::string res = std::move(out.str());
	auto pos = res.find('.');
	if (pos == std::string::npos)
		return res;
	auto splitLen = pos + 1 + precisionAfterPoint;
	if (res.size() <= splitLen)
		return res;
	return res.substr(0, splitLen);
}

int main()
{
	double time;
	int i = 30;
	while (--i != 0)
	{
		Sleep(1000);
		time = (double)GetSysTimeMicros() / 1000000;
		std::cout << DoubleToString(time, 3) << "s" << std::endl;
	}
	return 0;
}

```

```c++
//通用版
#ifdef _WIN32
#include <windows.h>
#else
#include <time.h>
#endif  // _WIND32


// 定义64位整形
#if defined(_WIN32) && !defined(CYGWIN)
typedef __int64 int64_t;
#else
typedef long long int64t;
#endif  // _WIN32

// 获取系统的当前时间，单位微秒(us)
int64_t GetSysTimeMicros()
{
#ifdef _WIN32
	// 从1601年1月1日0:0:0:000到1970年1月1日0:0:0:000的时间(单位100ns)
#define EPOCHFILETIME   (116444736000000000UL)
	FILETIME ft;
	LARGE_INTEGER li;
	int64_t tt = 0;
	GetSystemTimeAsFileTime(&ft);
	li.LowPart = ft.dwLowDateTime;
	li.HighPart = ft.dwHighDateTime;
	// 从1970年1月1日0:0:0:000到现在的微秒数(UTC时间)
	tt = (li.QuadPart - EPOCHFILETIME) / 10;
	return tt;
#else
	timeval tv;
	gettimeofday(&tv, 0);
	return (int64_t)tv.tv_sec * 1000000 + (int64_t)tv.tv_usec;
#endif // _WIN32
	return 0;
}

#include<iostream>
int main()
{
	int i = 30;
	while (--i != 0)
	{
		Sleep(1000);
		std::cout << GetSysTimeMicros() << std::endl;
	}
	return 0;
}
```

### fork()函数

**linux系统**

一个进程，包括代码、数据和分配给进程的资源。fork()函数通过系统调用**创建一个与原来进程几乎完全相同的进程**，也就是**两个进程可以做完全相同的事**，但如果初始参数或者传入的变量不同，两个进程也可以做不同的事。
  一个进程调用fork（）函数后，系统先给新的进程分配资源，例如存储数据和代码的空间。然后把原来的进程的所有值都复制到新的新进程中，只有少数值与原来的进程的值不同。相当于**克隆了一个自己**。





## OpenCV

### 坐标对应关系

![image-20200108142255582](/images/C++学习/image-20200108142255582.png)

行列与坐标系对应关系 

- **行rows：Y (height)**
- **列cols：X (width)**

**注意：**

在Mat类型变量访问时下标是反着写的，即：按照(y, x)的关系形式访问

示例：

```c++
int main()
{
    Mat mat_src = Mat::eye(3, 4, CV_8UC1);
 
    cout << "mat_src :" << endl;
    cout << mat_src    << endl;
 
    cout << endl;
    cout << "Rows : " << mat_src.rows << endl;
    cout << "Cols : " << mat_src.cols << endl;
 
    //注: mat_src.at<float>(y, x), 下标关系为: y-x
    mat_src.at<float>(0, 2) = 2; 
    mat_src.at<float>(2, 0) = 4;
 
    cout << endl;
    cout << "mat_src :" << endl;
    cout << mat_src    << endl;
 
    return 0;
}
```

输入：

```yaml
mat_src :
[  1,   0,   0,   0;
   0,   1,   0,   0;
   0,   0,   1,   0]

Rows : 3
Cols : 4

mat_src :
[  1,   0,   0,   0;
   0,   1,   0,   0;
   0,   0, 128,  64]
```



### threshold灰度二值化

图像的二值化就是将图像上的像素点的灰度值设置为0或255，这样将使整个图像呈现出明显的黑白效果。在数字图像处理中，二值图像占有非常重要的地位，图像的二值化使图像中数据量大为减少，从而能凸显出目标的轮廓。OpenCV中提供了函数cv::threshold();

![img](/images/C++学习/20170810122723876.png)

参数说明：

| 参数： | src    | dst      | thresh | maxval          | type     |
| ------ | ------ | -------- | ------ | --------------- | -------- |
| 说明： | 源图像 | 输出图像 | 阈值   | dst图像中最大值 | 阈值类型 |

- 源图像可以为8位的灰度图，也可以为32位的彩色图像。

- 阈值的类型如下：

  | 编号 | 阈值类型枚举      | 注意       |
  | ---- | ----------------- | ---------- |
  | 1    | THRESH_BINARY     |            |
  | 2    | THRESH_BINARY_INV |            |
  | 3    | THRESH_TRUNC      |            |
  | 4    | THRESH_TOZERO     |            |
  | 5    | THRESH_TOZERO_INV |            |
  | 6    | THRESH_MASK       | 不支持     |
  | 7    | THRESH_OTSU       | 不支持32位 |
  | 8    | THRESH_TRIANGLE   | 不支持32位 |

  [具体说明](https://blog.csdn.net/u012566751/article/details/77046445)

  示例代码

  ```c++
  #include <opencv2/opencv.hpp>
  #include <iostream>
  
  using namespace cv;
  using namespace std;
  
  int main()
  {
  	Mat src = imread("C:\\lib\\pic\\img1.jpg");
  	Mat gray, binary;
  	cvtColor(src, gray, CV_BGR2GRAY);
  	int th = 100;
  	cv::Mat threshold1, threshold2, threshold3, threshold4, threshold5, threshold6, threshold7, threshold8;
  	cv::threshold(gray, threshold1, th, 255, THRESH_BINARY);
  	cv::threshold(gray, threshold2, th, 255, THRESH_BINARY_INV);
  	cv::threshold(gray, threshold3, th, 255, THRESH_TRUNC);
  	cv::threshold(gray, threshold4, th, 255, THRESH_TOZERO);
  	cv::threshold(gray, threshold5, th, 255, THRESH_TOZERO_INV);
  	//cv::threshold(gray, threshold6, th, 255, THRESH_MASK);
  	cv::threshold(gray, threshold7, th, 255, THRESH_OTSU);
  	cv::threshold(gray, threshold8, th, 255, THRESH_TRIANGLE);
  	cv::imshow("THRESH_BINARY", threshold1);
  	cv::imshow("THRESH_BINARY_INV", threshold2);
  	cv::imshow("THRESH_TRUNC", threshold3);
  	cv::imshow("THRESH_TOZERO", threshold4);
  	cv::imshow("THRESH_TOZERO_INV", threshold5);
  	//cv::imshow("THRESH_MASK", threshold6);
  	cv::imshow("THRESH_OTSU", threshold7);
  	cv::imshow("THRESH_TRIANGLE", threshold8);
  	cv::waitKey(0);
  	return 0;
  }
  ```

### distanceTransform距离变换函数

OpenCV中，函数distanceTransform()用于计算图像中每一个非零点像素与其最近的零点像素之间的距离，输出的是保存每一个非零点与最近零点的距离信息；

图像上越亮的点，代表了离零点的距离越远。

**用途：**

可以根据距离变换的这个性质，经过简单的运算，用于细化字符的轮廓和查找物体质心（中心）。

**distanceTransform()函数的使用**

该函数有两个初始化API

```c++
C++: void distanceTransform(InputArray src, OutputArray dst, int distanceType, int maskSize)
 
C++: void distanceTransform(
InputArray src, 
OutputArray dst, 
OutputArray labels, 
int distanceType, 
int maskSize, 
int labelType=DIST_LABEL_CCOMP )
```

- 参数说明
  src – 8-bit, 单通道（二值化）输入图片。

- dst – 输出结果中包含计算的距离，这是一个32-bit  float 单通道的Mat类型数组，大小与输入图片相同。

- src – 8-bit, 单通道（二值化）输入图片。

- dst – 输出结果中包含计算的距离，这是一个32-bit  float 单通道的Mat类型数组，大小与输入图片相同。

- distanceType – 计算距离的类型，可以是 CV_DIST_L1、CV_DIST_L2 、CV_DIST_C。

- maskSize – 距离变换掩码矩阵的大小，可以是

  1. 3（CV_DIST_L1、 CV_DIST_L2 、CV_DIST_C）
  2. 5（CV_DIST_L2 ）
  3. CV_DIST_MASK_PRECISE (这个只能在4参数的API中使用)

- labels – 可选的2D标签输出（离散 Voronoi 图），类型为 CV_32SC1 大小同输入图片。

- labelType – 输出标签的类型，这里有些两种。

**示例代码**

```c++
int main()
{
	Mat src = imread("C:\\lib\\pic\\img5.jpg");

	resize(src, src, Size(), 0.25, 0.25, 1);
	imshow("src", src);

	Mat bin;
	cvtColor(src, bin, CV_BGR2GRAY);
	threshold(bin, bin, 80, 255, CV_THRESH_BINARY);
	imshow("bin", bin);

	Mat Dist, Labels;
	distanceTransform(bin, Dist, CV_DIST_L1, 3);
	normalize(Dist, Dist, 0, 1, NORM_MINMAX);
	imshow("dist1", Dist);

	distanceTransform(bin, Dist, Labels, CV_DIST_L1, 3, DIST_LABEL_CCOMP);
	normalize(Dist, Dist, 0, 1, NORM_MINMAX);
	imshow("dist2", Dist);
	imshow("labels2", Labels);

	distanceTransform(bin, Dist, Labels, CV_DIST_L1, 3, DIST_LABEL_PIXEL);
	normalize(Dist, Dist, 0, 1, NORM_MINMAX);
	//normalize(Labels, Labels, 0, 255, NORM_MINMAX);
	imshow("dist3", Dist);
	imshow("labels3", Labels);

	waitKey();
	return 0;

}
```

### 直线拟合fitLine()

**作用：**根据已知点集，拟合一条直线。

**函数形式：**

```c++
  void cv::fitLine(
        cv::InputArray points, // 二维点的数组或vector
        cv::OutputArray line, // 输出直线,Vec4f (2d)或Vec6f (3d)的vector
        int distType, // 距离类型
        double param, // 距离参数
        double reps, // 径向的精度参数
        double aeps // 角度精度参数
    );
```

**参数：**

- **points**：是用于拟合直线的输入点集，可以是二维点的cv::Mat数组，也可以是二维点的 vector。

- **line**：输出的直线，对于二维直线而言类型为cv::Vec4f，对于三维直线类型则是cv::Vec6f，输出参数的前半部分给出的是直线的方向（归一化向量），而后半部分给出的是直线上的一点（即通常所说的点斜式直线）。

- **distType**：距离类型，拟合直线时，要使输入点到拟合直线的距离和最小化（即下面公式中的cost代价最小化），可供选的距离类型如下表所示，ri表示的是输入的点到直线的距离。

  ![img](/images/C++学习/fea8769831b4789e0d6cf78cdec0c121.png)

- **param**：距离参数，跟所选的距离类型有关，值可以设置为0，cv::fitLine()函数本身会自动选择最优化的值

- 参数5，6：用于表示拟合直线所需要的径向和角度精度，通常情况下两个值均被设定为0.01。

**示例程序：**

```c++
#include <opencv2/opencv.hpp>
#include <iostream>

using namespace cv;
using namespace std;

int main()
{
	//创建一个用于绘制图像的空白图
	Mat image = Mat::zeros(480, 640, CV_8UC3);
	//输入拟合点
	vector<Point> points;
	points.push_back(Point(48, 58));
	points.push_back(Point(105, 98));
	points.push_back(Point(155, 160));
	points.push_back(Point(212, 220));
	points.push_back(Point(248, 260));
	points.push_back(Point(320, 300));
	points.push_back(Point(350, 360));
	points.push_back(Point(412, 400));

	//将拟合点绘制到空白图上
	for (int i = 0; i < points.size(); i++)
	{
		circle(image, points[i], 5, Scalar(0, 0, 255), 2, 8, 0);
	}

	Vec4f line_para;
	fitLine(points, line_para, cv::DIST_L2, 0, 1e-2, 1e-2);
	cout << "line_para = " << line_para << std::endl;

	//获取点斜式的点和斜率
	Point point0;
	point0.x = line_para[2];//直线上的点
	point0.y = line_para[3];
	double k = line_para[1] / line_para[0]; //斜率

	//计算直线的端点(y = k(x - x0) + y0)
	Point point1, point2;
	point1.x = 48;
	point1.y = k * (point1.x - point0.x) + point0.y;
	point2.x = 412;
	point2.y = k * (point2.x - point0.x) + point0.y;

	line(image, point1, point2, cv::Scalar(0, 255, 0), 2, 8, 0);
	imshow("image", image);
	waitKey(0);
	return 0;
}
```

### 线段采样

```c++
//windows
#include <opencv2/opencv.hpp>
#include <iostream>
#include <vector>
#include <list>
#include <algorithm>

using namespace cv;
using namespace std;

const size_t PatchSize = 1;

//线段类型
class Line
{
public:
	Point2f spx;
	Point2f epx;
	double length;
	list<Point2f> SampPoints;
	Line(Point2f &spx_, Point2f &epx_) :spx(spx_), epx(epx_)
	{
		ReSampling();
	}
	void ReSampling()
	{
		SampPoints.clear();
		Point2f dif = epx - spx; /// 从起点到终点的差矢量
		length = sqrt(dif.x*dif.x + dif.y*dif.y);
		double tan_dir = min(fabs(dif.x), fabs(dif.y)) / max(fabs(dif.x), fabs(dif.y));///角度正切（取正值）
		double sin_dir = tan_dir / sqrt(1.0 + tan_dir * tan_dir);///角度正弦
		double correction = 2.0 * sqrt(1.0 + sin_dir * sin_dir);///校正
		size_t sampling_num = max(1.0, length / (2 * PatchSize*correction));///采样点的数量

		// 采样
		double x_inc = dif.x / sampling_num;
		double y_inc = dif.y / sampling_num;
		for (size_t i = 0; i <= sampling_num; i++)
		{
			///i=0时，SampPoints = spx
			///i=sampling_num时，ampPoints = epx
			double samp_ix = spx.x + i * x_inc;
			double samp_iy = spx.y + i * y_inc;
			SampPoints.emplace_back(Point2f(samp_ix, samp_iy));
		}
	}
};

//线段集
vector<Line> lines;


int main()
{
	string path = "C:\\Lib\\pic\\img5.jpg";
	Mat image = imread(path, IMREAD_GRAYSCALE);
	if (!image.data) {
		printf("could not load image...\n");
		return -1;
	}
	resize(image, image, Size(), 0.2, 0.2);

	Ptr<LineSegmentDetector> ls = createLineSegmentDetector(LSD_REFINE_STD);
	vector<Vec4f> lines_std;
	// 检测LSD直线段
	ls->detect(image, lines_std);
	// 采样并存储直线段
	for (auto line_std : lines_std)
	{
		lines.emplace_back(
			Point2f(line_std[0], line_std[1]),//起点
			Point2f(line_std[2], line_std[3]));//终点

	}

	// 画出直线段
	cvtColor(image, image, CV_GRAY2RGB);
	for (auto line : lines)
	{
		cv::line(image,
			line.spx,
			line.epx,
			Scalar(0, 0, 200), 1, CV_AA//RGB颜色、粗细、抗锯齿
		);
		for (auto point : line.SampPoints)
			cv::circle(image, point, 1, cv::Scalar(0, 200, 0), 1);
	}
	imshow("LSD", image);
	cv::waitKey(0);
	return 0;
}
```

### Sobel梯度计算

**内置函数计算**（整张图像）

```c++
#include <opencv2/opencv.hpp>
#include <iostream>
using namespace  std;
//使用OpenCV的命名空间
using namespace cv;
//
//频道改变
int main()
{
	//读取源影像
	Mat Src = imread("C:\\lib\\pic\\img5.jpg", IMREAD_COLOR);
	if (Src.empty())
	{
		return 0;
	}
	resize(Src, Src, Size(), 0.2, 0.2);
	//将彩色影像转换为灰色影像
	Mat Gray;
	cvtColor(Src, Gray, CV_BGR2GRAY);
	//X方向上边缘检测的结果
	Mat XBorder, YBorder, XYBorder;
	Sobel(Gray, XBorder, CV_16S, 1, 0, 3, 1.0, 0);
	Sobel(Gray, YBorder, CV_16S, 0, 1, 3, 1.0, 0);
	convertScaleAbs(XBorder, XBorder);
	convertScaleAbs(YBorder, YBorder);
    //void addWeighted(InputArray src1, double alpha, InputArray src2, double beta, double gamma, OutputArray dst, int dtype = -1);
    //dst = src1[i] * alpha + src2[i] * beta + gamma;
	//addWeighted()函数是将两张相同大小，相同类型的图片融合的函数。
	addWeighted(XBorder, 0.5, YBorder, 0.5, 0, XYBorder);
	namedWindow("Src", WINDOW_AUTOSIZE);
	namedWindow("XBorder", WINDOW_AUTOSIZE);
	namedWindow("YBorder", WINDOW_AUTOSIZE);
	namedWindow("XYBorder", WINDOW_AUTOSIZE);
	imshow("Src", Gray);
	imshow("XBorder", XBorder);
	imshow("YBorder", YBorder);
	imshow("XYBorder", XYBorder);
	waitKey(0);
	return 0;
}

```

**单个像素梯度**[参考链接](https://blog.csdn.net/qq_37124237/article/details/82183177)

```c++
#include<opencv2/opencv.hpp>
#include<iostream>
using namespace std;
using namespace cv;

int main()
{
	Mat m_img = imread("C:\\lib\\pic\\img5.jpg");
	resize(m_img, m_img, Size(), 0.2, 0.2);
	//blur(m_img, m_img, Size(3, 3));
	Mat src(m_img.rows, m_img.cols, CV_8UC1, Scalar(0));
	cvtColor(m_img, src, CV_RGB2GRAY);//原灰度图

	Mat dstImage(src.rows, src.cols, CV_8UC1, Scalar(0));//总的梯度大小

	for (int i = 1; i < src.rows - 1; i++)
	{
		for (int j = 1; j < src.cols - 1; j++)
		{
			dstImage.data[i*dstImage.step + j] = sqrt(
				(src.data[(i - 1)*src.step + j + 1]
					+ 2 * src.data[i*src.step + j + 1]
					+ src.data[(i + 1)*src.step + j + 1]
					- src.data[(i - 1)*src.step + j - 1]
					- 2 * src.data[i*src.step + j - 1]
					- src.data[(i + 1)*src.step + j - 1])
				*
				(src.data[(i - 1)*src.step + j + 1]
					+ 2 * src.data[i*src.step + j + 1]
					+ src.data[(i + 1)*src.step + j + 1]
					- src.data[(i - 1)*src.step + j - 1]
					- 2 * src.data[i*src.step + j - 1]
					- src.data[(i + 1)*src.step + j - 1])
				+
				(src.data[(i - 1)*src.step + j - 1]
					+ 2 * src.data[(i - 1)*src.step + j]
					+ src.data[(i - 1)*src.step + j + 1]
					- src.data[(i + 1)*src.step + j - 1]
					- 2 * src.data[(i + 1)*src.step + j]
					- src.data[(i + 1)*src.step + j + 1])
				*
				(src.data[(i - 1)*src.step + j - 1]
					+ 2 * src.data[(i - 1)*src.step + j]
					+ src.data[(i - 1)*src.step + j + 1]
					- src.data[(i + 1)*src.step + j - 1]
					- 2 * src.data[(i + 1)*src.step + j]
					- src.data[(i + 1)*src.step + j + 1]));

		}

	}
	Mat grad_y(src.rows, src.cols, CV_8UC1, Scalar(0));
	{
		for (int i = 1; i < src.rows - 1; i++)
		{
			for (int j = 1; j < src.cols - 1; j++)
			{
				grad_y.data[i*grad_y.step + j] = abs(
					src.data[(i - 1)*src.step + j + 1]
					+ 2 * src.data[i*src.step + j + 1]
					+ src.data[(i + 1)*src.step + j + 1]
					- src.data[(i - 1)*src.step + j - 1]
					- 2 * src.data[i*src.step + j - 1]
					- src.data[(i + 1)*src.step + j - 1]);
			}
		}
	}
	Mat grad_x(src.rows, src.cols, CV_8UC1, Scalar(0));
	{
		for (int i = 1; i < src.rows - 1; i++)
		{
			for (int j = 1; j < src.cols - 1; j++)
			{
				grad_x.data[i*grad_x.step + j] = abs(
					src.data[(i - 1)*src.step + j - 1]
					+ 2 * src.data[(i - 1)*src.step + j]
					+ src.data[(i - 1)*src.step + j + 1]
					- src.data[(i + 1)*src.step + j - 1]
					- 2 * src.data[(i + 1)*src.step + j]
					- src.data[(i + 1)*src.step + j + 1]);
			}
		}
	}

	imshow("原图", src);
	imshow("gradient", dstImage);
	imshow("Vertical gradient", grad_y);
	imshow("Horizontal gradient", grad_x);

	waitKey(0);
	return 0;
}
```

### 像素读写

```c++
#include <opencv2/opencv.hpp>
#include <iostream>
using namespace std;
using namespace cv;
void salt(Mat image, int n);
int main(int argv, char** argc)
{
	Mat src;
	src = imread("C:\\lib\\pic\\img5.jpg");
	resize(src, src, Size(), 0.2, 0.2);
	salt(src, 3000);
	imshow("input", src);

	waitKey(0);
	return 0;
}
// 添加椒盐噪声
void salt(Mat image, int n)
{
	int i, j;
	for (int k = 0; k < n; k++) {
		i = std::rand() % image.cols;
		j = std::rand() % image.rows;
		//像素操作--------------
		if (image.type() == CV_8UC1) {
			image.at<uchar>(j, i) = 255;
		}
		else if (image.type() == CV_8UC3) {
			image.at<Vec3b>(j, i)[0] = 255;
			image.at<Vec3b>(j, i)[1] = 255;
			image.at<Vec3b>(j, i)[2] = 255;
		}
		// -----------------------
	}
}
```

### 画箭头

```c++
#include "opencv2/core/core.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"
using namespace cv;

void drawArrow(cv::Mat& img, cv::Point pStart, cv::Point pEnd, int len, int alpha,
	cv::Scalar& color, int thickness = 1, int lintType = 8);

int main(int argc, char** argv)
{
	cv::Mat mat = imread("C:\\lib\\pic\\img5.jpg");
	resize(mat, mat, Size(), 0.2, 0.2);
	namedWindow("test");
	imshow("test", mat);

	Mat m(400, 400, CV_8UC3, Scalar(0, 0, 0));
	Point pStart(380, 100), pEnd(100, 250);
	Scalar lineColor(0, 255, 255);
	drawArrow(m, pStart, pEnd, 10, 45, lineColor);
	pStart = Point(100, 100);
	pEnd = Point(320, 190);
	lineColor = Scalar(0, 0, 255);
	drawArrow(m, pStart, pEnd, 25, 30, lineColor, 2, CV_AA);
	pStart = Point(200, 420);
	pEnd = Point(370, 170);
	lineColor = Scalar(255, 0, 255);
	drawArrow(m, pStart, pEnd, 17, 15, lineColor, 1, 4);
	imshow("draw arrow", m);

	waitKey();
	return 0;
}


void drawArrow(cv::Mat& img, cv::Point pStart, cv::Point pEnd, int len, int alpha, cv::Scalar& color, int thickness, int lineType)
{
	const double PI = 3.1415926;
	Point arrow;
	//计算 θ 角（最简单的一种情况在下面图示中已经展示，关键在于 atan2 函数，详情见下面）   
	double angle = atan2((double)(pStart.y - pEnd.y), (double)(pStart.x - pEnd.x));
	line(img, pStart, pEnd, color, thickness, lineType);
	//计算箭角边的另一端的端点位置（上面的还是下面的要看箭头的指向，也就是pStart和pEnd的位置） 
	arrow.x = pEnd.x + len * cos(angle + PI * alpha / 180);
	arrow.y = pEnd.y + len * sin(angle + PI * alpha / 180);
	line(img, pEnd, arrow, color, thickness, lineType);
	arrow.x = pEnd.x + len * cos(angle - PI * alpha / 180);
	arrow.y = pEnd.y + len * sin(angle - PI * alpha / 180);
	line(img, pEnd, arrow, color, thickness, lineType);
}
```

### 两图合并显示

```c++
#include <opencv2/opencv.hpp>

using namespace std;
using namespace cv;

void main()
{
	Mat img1 = imread("C:\\lib\\pic\\img5.jpg");
	Mat img2 = imread("C:\\lib\\pic\\img2.jpg");
	int height = img1.rows;//高度
	int width1 = img1.cols;//左图宽度
	int width2 = img2.cols;//右图宽度
	// 将高图像等比缩放与低图像《高度》一致,（因为要左右分布）
	if (img1.rows > img2.rows)
	{//左图更宽
		height = img2.rows;
		width1 = img1.cols * ((float)img2.rows / (float)img1.rows);//高度一定，保持长宽比
		resize(img1, img1, Size(width1, height));
	}
	else if (img1.rows < img2.rows)
	{//右图更宽
		width2 = img2.cols * ((float)img1.rows / (float)img2.rows);
		resize(img2, img2, Size(width2, height));
	}
	//创建目标Mat
	Mat img(height, width1 + width2, img1.type());
	Mat r1 = img(Rect(0, 0, width1, height));//创建矩形
	img1.copyTo(r1);//图像拷贝到矩形
	Mat r2 = img(Rect(width1, 0, width2, height));//创建矩形
	img2.copyTo(r2);//图像拷贝到矩形
	imshow("des", img);
	waitKey(0);
}
```

### 显示文字

#### 显示文字（不支持中文）

函数原型：

```c++
void cv::putText(
	cv::Mat& img, // 待绘制的图像
	const string& text, // 待绘制的文字
	cv::Point origin, // 文本框的左下角
	int fontFace, // 字体 (如cv::FONT_HERSHEY_PLAIN)
	double fontScale, // 尺寸因子，值越大文字越大
	cv::Scalar color, // 线条的颜色（RGB）
	int thickness = 1, // 线条宽度
	int lineType = 8, // 线型（4邻域或8邻域，默认8邻域）
	bool bottomLeftOrigin = false //true='原点在左下方'，false='原点在左上方'，为ture文字会倒过来
);
```

另外，我们在实际绘制文字之前，还可以使用cv::getTextSize()接口先获取待绘制文本框的大小，以方便放置文本框。具体调用形式如下：

```c++
cv::Size cv::getTextSize(
	const string& text,
	cv::Point origin,
	int fontFace,
	double fontScale,
	int thickness,
	int* baseLine
);
```

示例

```c++
#include <opencv2/opencv.hpp>

using namespace cv;
using namespace std;

int main()
{

	//创建空白图用于绘制文字
	cv::Mat image = cv::Mat::zeros(cv::Size(640, 480), CV_8UC3);
	//设置蓝色背景
	image.setTo(cv::Scalar(100, 0, 0));

	//设置绘制文本的相关参数
	std::string text = "Hello World!";
	int font_face = cv::FONT_HERSHEY_COMPLEX;
	double font_scale = 1;
	int thickness = 1;
	int baseline;
	//获取文本框的长宽
	cv::Size text_size = cv::getTextSize(text, font_face, font_scale, thickness, &baseline);

	//将文本框居中绘制
	cv::Point origin;
	origin.x = image.cols / 2 - text_size.width / 2;
	origin.y = image.rows / 2 + text_size.height / 2;
	origin.x = 0;
	origin.y = text_size.height;
	cv::putText(image, text, origin, font_face, font_scale, cv::Scalar(0, 255, 255), thickness, 8, false);

	//显示绘制解果
	cv::imshow("image", image;
	cv::waitKey(0);
	return 0;
}
```

#### 显示中文（windows）

```c++

#include <opencv2/opencv.hpp>
#include "windows.h"

void putTextZH(cv::Mat &dst, const char* str, cv::Point org, cv::Scalar color, int fontSize,
	const char *fn = "Arial", bool italic = false, bool underline = false);

int main()
{
	using namespace cv;
	cv::Mat srcImage = cv::Mat(240, 320, CV_8UC3, cv::Scalar::all(0));
	putTextZH(srcImage, "OpenCV欢迎你", Point(0, 0), Scalar(255, 0, 0), 30, "微软雅黑");
	cv::imshow("显示中文", srcImage);
	cv::waitKey(0);
	cv::destroyAllWindows();
	return 0;
}

void GetStringSize(HDC hDC, const char* str, int* w, int* h)
{
	SIZE size;
	GetTextExtentPoint32A(hDC, str, strlen(str), &size);
	if (w != 0) *w = size.cx;
	if (h != 0) *h = size.cy;
}

void putTextZH(cv::Mat &dst, const char* str, cv::Point org, cv::Scalar color, int fontSize, const char* fn, bool italic, bool underline)
{
	CV_Assert(dst.data != 0 && (dst.channels() == 1 || dst.channels() == 3));
	int x, y, r, b;
	if (org.x > dst.cols || org.y > dst.rows) return;
	x = org.x < 0 ? -org.x : 0;
	y = org.y < 0 ? -org.y : 0;
	LOGFONTA lf;
	lf.lfHeight = -fontSize;
	lf.lfWidth = 0;
	lf.lfEscapement = 0;
	lf.lfOrientation = 0;
	lf.lfWeight = 5;
	lf.lfItalic = italic;   //斜体
	lf.lfUnderline = underline; //下划线
	lf.lfStrikeOut = 0;
	lf.lfCharSet = DEFAULT_CHARSET;
	lf.lfOutPrecision = 0;
	lf.lfClipPrecision = 0;
	lf.lfQuality = PROOF_QUALITY;
	lf.lfPitchAndFamily = 0;
	strcpy_s(lf.lfFaceName, fn);
	HFONT hf = CreateFontIndirectA(&lf);
	HDC hDC = CreateCompatibleDC(0);
	HFONT hOldFont = (HFONT)SelectObject(hDC, hf);
	int strBaseW = 0, strBaseH = 0;
	int singleRow = 0;
	char buf[1 << 12];
	strcpy_s(buf, str);
	char *bufT[1 << 12];  // 这个用于分隔字符串后剩余的字符，可能会超出。
	//处理多行
	{
		int nnh = 0;
		int cw, ch;
		const char* ln = strtok_s(buf, "\n", bufT);
		while (ln != 0)
		{
			GetStringSize(hDC, ln, &cw, &ch);
			strBaseW = max(strBaseW, cw);
			strBaseH = max(strBaseH, ch);
			ln = strtok_s(0, "\n", bufT);
			nnh++;
		}
		singleRow = strBaseH;
		strBaseH *= nnh;
	}
	if (org.x + strBaseW < 0 || org.y + strBaseH < 0)
	{
		SelectObject(hDC, hOldFont);
		DeleteObject(hf);
		DeleteObject(hDC);
		return;
	}
	r = org.x + strBaseW > dst.cols ? dst.cols - org.x - 1 : strBaseW - 1;
	b = org.y + strBaseH > dst.rows ? dst.rows - org.y - 1 : strBaseH - 1;
	org.x = org.x < 0 ? 0 : org.x;
	org.y = org.y < 0 ? 0 : org.y;
	BITMAPINFO bmp = { 0 };
	BITMAPINFOHEADER& bih = bmp.bmiHeader;
	int strDrawLineStep = strBaseW * 3 % 4 == 0 ? strBaseW * 3 : (strBaseW * 3 + 4 - ((strBaseW * 3) % 4));
	bih.biSize = sizeof(BITMAPINFOHEADER);
	bih.biWidth = strBaseW;
	bih.biHeight = strBaseH;
	bih.biPlanes = 1;
	bih.biBitCount = 24;
	bih.biCompression = BI_RGB;
	bih.biSizeImage = strBaseH * strDrawLineStep;
	bih.biClrUsed = 0;
	bih.biClrImportant = 0;
	void* pDibData = 0;
	HBITMAP hBmp = CreateDIBSection(hDC, &bmp, DIB_RGB_COLORS, &pDibData, 0, 0);
	CV_Assert(pDibData != 0);
	HBITMAP hOldBmp = (HBITMAP)SelectObject(hDC, hBmp);
	//color.val[2], color.val[1], color.val[0]
	SetTextColor(hDC, RGB(255, 255, 255));
	SetBkColor(hDC, 0);
	//SetStretchBltMode(hDC, COLORONCOLOR);
	strcpy_s(buf, str);
	const char* ln = strtok_s(buf, "\n", bufT);
	int outTextY = 0;
	while (ln != 0)
	{
		TextOutA(hDC, 0, outTextY, ln, strlen(ln));
		outTextY += singleRow;
		ln = strtok_s(0, "\n", bufT);
	}
	uchar* dstData = (uchar*)dst.data;
	int dstStep = dst.step / sizeof(dstData[0]);
	unsigned char* pImg = (unsigned char*)dst.data + org.x * dst.channels() + org.y * dstStep;
	unsigned char* pStr = (unsigned char*)pDibData + x * 3;
	for (int tty = y; tty <= b; ++tty)
	{
		unsigned char* subImg = pImg + (tty - y) * dstStep;
		unsigned char* subStr = pStr + (strBaseH - tty - 1) * strDrawLineStep;
		for (int ttx = x; ttx <= r; ++ttx)
		{
			for (int n = 0; n < dst.channels(); ++n) {
				double vtxt = subStr[n] / 255.0;
				int cvv = vtxt * color.val[n] + (1 - vtxt) * subImg[n];
				subImg[n] = cvv > 255 ? 255 : (cvv < 0 ? 0 : cvv);
			}
			subStr += 3;
			subImg += dst.channels();
		}
	}
	SelectObject(hDC, hOldBmp);
	SelectObject(hDC, hOldFont);
	DeleteObject(hf);
	DeleteObject(hBmp);
	DeleteDC(hDC);
}
```

### Zed相机转OpenCV

```c++

// ZED includes
#include <sl_zed/Camera.hpp>

// OpenCV includes
#include <opencv2/opencv.hpp>

using namespace sl;

cv::Mat slMat2cvMat(Mat& input);

int main(int argc, char **argv) {

	// 创建ZED相机对象
	Camera zed;

	// 设置配置参数
	InitParameters init_params;
	init_params.camera_resolution = RESOLUTION_HD1080;			// 分辨率：1080
	init_params.depth_mode = DEPTH_MODE_PERFORMANCE;			// 深度模式性能
	init_params.coordinate_units = UNIT_METER;					// 坐标单位：米
	if (argc > 1) init_params.svo_input_filename.set(argv[1]);	//如果有配置文件，就加载

	// 打开相机
	ERROR_CODE err = zed.open(init_params);
	if (err != SUCCESS)
	{
		printf("%s\n", toString(err).c_str());
		zed.close();
		return 1; // 如果打开失败退出
	}


	// 打开相机后设置运行时参数
	RuntimeParameters runtime_parameters;
	runtime_parameters.sensing_mode = SENSING_MODE_STANDARD;

	// 准备新的图像大小以检索半分辨率图像
	Resolution image_size = zed.getResolution();	//分辨率
	int new_width = image_size.width / 2;
	int new_height = image_size.height / 2;

	// 存储sl:Mat格式的图像
	Mat image_zed(new_width, new_height, MAT_TYPE_8U_C4);		// 存储彩色图
	Mat depth_image_zed(new_width, new_height, MAT_TYPE_8U_C4);	// 存储深度图
	Mat point_cloud;											// 存储点云

	// cv:Mat到sl:Mat映射
	cv::Mat image_ocv = slMat2cvMat(image_zed);
	cv::Mat depth_image_ocv = slMat2cvMat(depth_image_zed);


	// 输入q结束
	char key = ' ';
	while (key != 'q') {

		if (zed.grab(runtime_parameters) == SUCCESS)
		{

			// 检索左图像
			zed.retrieveImage(image_zed, VIEW_LEFT, MEM_CPU, new_width, new_height);			//读取左边图像
			//zed.retrieveImage(depth_image_zed, VIEW_DEPTH, MEM_CPU, new_width, new_height);		//读取深度图像
			//zed.retrieveMeasure(point_cloud, MEASURE_XYZRGBA, MEM_CPU, new_width, new_height);	//读取点云

			// 用cv:Mat显示（cv:Mat和sl:Mat是共享内存的）
			cv::imshow("Image", image_ocv);
			cv::imshow("Depth", depth_image_ocv);

			// Handle key event
			key = cv::waitKey(10);
		}
	}
	zed.close();
	return 0;
}


//sl::Mat转cv::Mat
cv::Mat slMat2cvMat(Mat& input) {
	/// MAT_TYPE和CV_TYPE之间映射
	int cv_type = -1;
	switch (input.getDataType()) {
	case MAT_TYPE_32F_C1: cv_type = CV_32FC1; break;
	case MAT_TYPE_32F_C2: cv_type = CV_32FC2; break;
	case MAT_TYPE_32F_C3: cv_type = CV_32FC3; break;
	case MAT_TYPE_32F_C4: cv_type = CV_32FC4; break;
	case MAT_TYPE_8U_C1: cv_type = CV_8UC1; break;
	case MAT_TYPE_8U_C2: cv_type = CV_8UC2; break;
	case MAT_TYPE_8U_C3: cv_type = CV_8UC3; break;
	case MAT_TYPE_8U_C4: cv_type = CV_8UC4; break;
	default: break;
	}

	/// 因为cv:Mat数据需要一个uchar*指针，所以我们通过sl::Mat (getPtr<T>())得到uchar1的指针
	/// cv::Mat和sl::Mat共享一个内存结构
	return cv::Mat(input.getHeight(), input.getWidth(), cv_type, input.getPtr<sl::uchar1>(MEM_CPU));
}
```

保存数据集

```c++

// ZED includes
#include <sl_zed/Camera.hpp>

// OpenCV includes
#include <opencv2/opencv.hpp>

using namespace sl;

cv::Mat slMat2cvMat(Mat& input);

int main(int argc, char **argv) {

	// 创建ZED相机对象
	Camera zed;

	// 设置配置参数
	InitParameters init_params;
	init_params.camera_resolution = RESOLUTION_HD720;			// 分辨率
	init_params.depth_mode = DEPTH_MODE_NONE;					// 深度模式
	init_params.coordinate_units = UNIT_METER;					// 坐标单位：米
	if (argc > 1) init_params.svo_input_filename.set(argv[1]);	//如果有配置文件，就加载

	// 打开相机
	ERROR_CODE err = zed.open(init_params);
	if (err != SUCCESS)
	{
		printf("%s\n", toString(err).c_str());
		zed.close();
		return 1; // 如果打开失败退出
	}


	// 打开相机后设置运行时参数
	RuntimeParameters runtime_parameters;
	runtime_parameters.sensing_mode = SENSING_MODE_STANDARD;

	// 准备新的图像大小以检索半分辨率图像
	Resolution image_size = zed.getResolution();//分辨率
	int new_width = image_size.width * 2;
	int new_height = image_size.height;

	Mat image_zed(new_width, new_height, MAT_TYPE_8U_C4);
	cv::Mat image_ocv = slMat2cvMat(image_zed);

	cv::Mat leftMat(image_size.width, image_size.height, CV_8UC4);
	cv::Mat rightMat(image_size.width, image_size.height, CV_8UC4);
	
	cv::Range leftWidth(0, image_size.width);
	cv::Range rightWidth(image_size.width, image_size.width * 2);
	cv::Range Higth(0, image_size.height);

	std::string leftPath = "C:\\dataset\\left\\";
	std::string rightPath = "C:\\dataset\\right\\";

	// 输入q结束
	char key = ' ';
	while (key != 'q')
	{
		if (zed.grab(runtime_parameters) == SUCCESS)
		{

			// 检索左图像
			zed.retrieveImage(image_zed, VIEW_SIDE_BY_SIDE, MEM_CPU, new_width, new_height);
			sl::timeStamp  tt = zed.getCameraTimestamp();//时间戳
			std::cout << "timeStamp:" << tt << std::endl;

			leftMat = image_ocv(Higth,leftWidth);
			rightMat = image_ocv(Higth,rightWidth);

			cv::imwrite(leftPath + std::to_string(tt) + ".png", leftMat);
			cv::imwrite(rightPath + std::to_string(tt) + ".png", rightMat);
			// 用cv:Mat显示（cv:Mat和sl:Mat是共享内存的）
			cv::imshow("leftImage", leftMat);
			cv::imshow("rightImage", rightMat);

			// Handle key event
			key = cv::waitKey(10);
		}
	}
	zed.close();
	return 0;
}


//sl::Mat转cv::Mat
cv::Mat slMat2cvMat(Mat& input) {
	/// MAT_TYPE和CV_TYPE之间映射
	int cv_type = -1;
	switch (input.getDataType()) {
	case MAT_TYPE_32F_C1: cv_type = CV_32FC1; break;
	case MAT_TYPE_32F_C2: cv_type = CV_32FC2; break;
	case MAT_TYPE_32F_C3: cv_type = CV_32FC3; break;
	case MAT_TYPE_32F_C4: cv_type = CV_32FC4; break;
	case MAT_TYPE_8U_C1: cv_type = CV_8UC1; break;
	case MAT_TYPE_8U_C2: cv_type = CV_8UC2; break;
	case MAT_TYPE_8U_C3: cv_type = CV_8UC3; break;
	case MAT_TYPE_8U_C4: cv_type = CV_8UC4; break;
	default: break;
	}

	/// 因为cv:Mat数据需要一个uchar*指针，所以我们通过sl::Mat (getPtr<T>())得到uchar1的指针
	/// cv::Mat和sl::Mat共享一个内存结构
	return cv::Mat(input.getHeight(), input.getWidth(), cv_type, input.getPtr<sl::uchar1>(MEM_CPU));
}
```

### 打开相机

```c++
#include <opencv2/opencv.hpp>
using namespace cv;
using namespace std;

int main()
{
	//读取视频或摄像头
	VideoCapture capture(0);
	while (true)
	{
		Mat frame;
		capture >> frame;
		imshow("读取视频", frame);
		waitKey(30);	//延时30
	}
	return 0;
}
```

```c++
//逐帧显示
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include <iostream>
using namespace cv;

int main()
{
	namedWindow("cameraLive", WINDOW_AUTOSIZE);
	VideoCapture cap;
	cap.open(0);
	//VideoCapture cap(0);这句话可以替代上面两个语句，效果是一致的。
	if (!cap.isOpened())
	{
		std::cerr << "Couldn't open capture." << std::endl;
		return -1;
	}

	Mat frame;
	while (1)
	{
		cap >> frame;
		if (frame.empty()) break;
		imshow("cameraLive", frame);
		if (waitKey(33) >= 0) break;
	}
	return 0;
}
```

### OpenCV打开zed相机

```c++
#include <stdio.h>
#include <string>
#include <opencv2/opencv.hpp>
#include <chrono> 

class StereoCamera
{
public:	//参数：设备名	分辨率	帧率
	StereoCamera(int resolution, double frame_rate)
	{
		camera_ = new cv::VideoCapture(0);
		setResolution(resolution);
		setFrameRate(frame_rate);
	}

	~StereoCamera()
	{
		delete camera_;
	}

	void setResolution(int type)
	{
		switch (type)
		{
		case 0://RESOLUTION_HD2K
			width_ = 4416;
			height_ = 1242;
			break;
		case 1://RESOLUTION_HD1080
			width_ = 3840;
			height_ = 1080;
			break;
		case 2://RESOLUTION_HD720
			width_ = 2560;
			height_ = 720;
			break;
		case 3://RESOLUTION_VGA
			width_ = 1344;
			height_ = 376;
			break;
		default:
			width_ = 1344;
			height_ = 376;
		}

		camera_->set(cv::CAP_PROP_FRAME_WIDTH, width_);
		camera_->set(cv::CAP_PROP_FRAME_HEIGHT, height_);
		// 确保从硬件设置的数字正确
		width_ = camera_->get(cv::CAP_PROP_FRAME_WIDTH);
		height_ = camera_->get(cv::CAP_PROP_FRAME_HEIGHT);
	}

	void setFrameRate(double frame_rate)
	{
		camera_->set(cv::CAP_PROP_FPS, frame_rate);
		frame_rate_ = camera_->get(cv::CAP_PROP_FPS);
	}

	bool getImages(cv::Mat& left_image, cv::Mat& right_image)
	{
		cv::Mat raw;
		if (camera_->grab())
		{
			camera_->retrieve(raw);
			cv::Rect left_rect(0, 0, width_ / 2, height_);//Rect参数：左下角x，左下角y，宽度，高度
			cv::Rect right_rect(width_ / 2, 0, width_ / 2, height_);
			left_image = raw(left_rect);
			right_image = raw(right_rect);
			cv::waitKey(10);
			return true;
		}
		else
		{
			return false;
		}
	}

private:
	cv::VideoCapture* camera_;
	int width_;
	int height_;
	double frame_rate_;
};

//分辨率枚举(没有用到)
enum RESOLUTION
{
	RESOLUTION_HD2K, /**< 2208*1242, available framerates: 15 fps.*/
	RESOLUTION_HD1080, /**< 1920*1080, available framerates: 15, 30 fps.*/
	RESOLUTION_HD720, /**< 1280*720, available framerates: 15, 30, 60 fps.*/
	RESOLUTION_VGA, /**< 672*376, available framerates: 15, 30, 60, 100 fps.*/
};

int main()
{
	StereoCamera zed(1, 60);
	cv::Mat left_image, right_image;
	std::string leftPath = "C:\\dataset\\left\\";
	std::string rightPath = "C:\\dataset\\right\\";
	clock_t tt;

	while (true)
	{
		if (!zed.getImages(left_image, right_image))
		{
			std::cout << "打不开" << std::endl;
			break;

		}
		zed.getImages(left_image, right_image);
		tt = clock();

		//cv::imwrite(leftPath + std::to_string(tt) + ".png", left_image);
		//cv::imwrite(rightPath + std::to_string(tt) + ".png", right_image);

		cv::imshow("left", left_image);
		cv::imshow("right", right_image);
		cv::waitKey(10);
	}
	
	return 0;
}

```

### 线段检测

```c++
#include <iostream>
#include <fstream>
#include <opencv2/opencv.hpp>
#include <opencv2/core/core.hpp>
#include "CannyLine.h"
#include "EDLib.h"

#include<chrono>

using namespace cv;
using namespace std;


int main()
{	
	cv::Mat img = imread("..\\test.png", IMREAD_GRAYSCALE);
	imshow("原图", img);

	//CannyLine检测
	CannyLine detector;
	std::vector<std::vector<float> > lines;
	std::chrono::steady_clock::time_point t0 = std::chrono::steady_clock::now();
	detector.cannyLine( img, lines );
	std::chrono::steady_clock::time_point t1 = std::chrono::steady_clock::now();

	//LSD线段检测
	Ptr<LineSegmentDetector> ls = createLineSegmentDetector(LSD_REFINE_STD);
	double start = double(getTickCount());
	vector<Vec4f> lines_std;
	std::chrono::steady_clock::time_point t2 = std::chrono::steady_clock::now();
	ls->detect(img, lines_std);
	std::chrono::steady_clock::time_point t3 = std::chrono::steady_clock::now();

	//EDLines线段检测
	
	std::chrono::steady_clock::time_point t4 = std::chrono::steady_clock::now();
	EDLines testEDLines = EDLines(img);
	std::chrono::steady_clock::time_point t5 = std::chrono::steady_clock::now();
	Mat lineImg = testEDLines.getLineImage();


	// 显示CannyLine
	cv::Mat imgShow( img.rows, img.cols, CV_8UC3, cv::Scalar( 255, 255, 255 ) );//纯白背景
	for ( int m=0; m<lines.size(); ++m )
	{
		cv::line( imgShow, cv::Point( lines[m][0], lines[m][1] ), cv::Point( lines[m][2], lines[m][3] ), cv::Scalar(0,0,0), 1, CV_AA );//纯黑线段
	}
	imshow("CannyLine",imgShow);

	//显示LSD
	Mat only_lines(img.rows, img.cols, CV_8UC3, cv::Scalar(255, 255, 255));//纯白背景
	ls->drawSegments(only_lines, lines_std);
	imshow("LSD", only_lines);

	//显示EDLines
	imshow("EDLines", lineImg);

	double t_canny = std::chrono::duration_cast<std::chrono::duration<double>>(t1 - t0).count();
	cout << "CannyLine提取时间为：" << t_canny << "s" << endl;
	double t_lsd = std::chrono::duration_cast<std::chrono::duration<double>>(t3 - t2).count();
	cout << "LSD提取时间为：" << t_lsd << "s" << endl;
	double t_ed = std::chrono::duration_cast<std::chrono::duration<double>>(t5 - t4).count();
	cout << "EDLines提取时间为：" << t_ed << "s" << endl;

	cv::waitKey(0);
}
```

### IplImage和Mat

[参考](https://blog.csdn.net/qq_37764129/article/details/81271660)

OpenCV1基于C接口定义的图像存储格式IplImage*，直接暴露内存，如果忘记释放内存，就会造成内存泄漏。从OpenCV2开始，开始使用Mat类存储图像，其新的C++接口，cv::Mat代替了原来c风格的CvMat和IplImage。

```c
// IplImage*的使用

#include "opencv/cv.h"
#include "opencv/cxcore.h"
#include "opencv/highgui.h"
#include "stdio.h"

int main(void)
{
	IplImage* Image;
	IplImage* Image_Gray;
	Image = cvLoadImage("..\\test.png", 1);							// 载入图片，1-彩色
	Image_Gray = cvCreateImage(cvGetSize(Image), Image->depth, 1);	// 创建内存
	cvCvtColor(Image, Image_Gray, CV_BGR2GRAY);						// 彩色图->灰度图
	cvShowImage("Image", Image);
	cvShowImage("Image_Gray", Image_Gray);
	cvWaitKey(0);
	cvReleaseImage(&Image);// 需要手动释放内存
	cvReleaseImage(&Image_Gray);
	return 0;
}
```



## SLAM

### L-K跟踪

```c++
//linux
#include <opencv2/opencv.hpp>
#include <iostream>
#include <list>
#include <vector>
#include <chrono>
#include <string>

using namespace cv;
using namespace std;
int main()
{
    std::string img_dir = "/mnt/hgfs/dataset/EuRoC/MH_01_easy/mav0/cam0/data";

    std::vector<cv::String> image_files;
    cv::glob(img_dir, image_files);
    if (image_files.empty())
    {
        std::cout << "No image files" << std::endl;
        return 0;
    }

    Mat image,last_image;
    list< cv::Point2f > keypoints;
    for (size_t frame = 0; frame < image_files.size(); ++frame)
    {
        image = cv::imread(image_files[frame]);
        // 对第一帧提取FAST特征点
        if(frame==0)
        {
            vector<cv::KeyPoint> kps;
            cv::Ptr<cv::FastFeatureDetector> detector = cv::FastFeatureDetector::create();
            detector->detect(image, kps);
            for (auto kp:kps)
                keypoints.push_back(kp.pt);
            last_image = image;
            continue;
        }
        // 对其他帧用LK跟踪特征点
        vector<cv::Point2f> next_keypoints;
        vector<cv::Point2f> prev_keypoints;
        for (auto kp:keypoints)
            prev_keypoints.push_back(kp);
        vector<unsigned char> status;/// 点的跟踪状态
        vector<float> error;
        chrono::steady_clock::time_point t1 = chrono::steady_clock::now();
        cv::calcOpticalFlowPyrLK(// LK跟踪
                last_image,
                image,
                prev_keypoints, ///要跟踪的点
                next_keypoints, ///跟踪成功的点
                status,
                error);
        chrono::steady_clock::time_point t2 = chrono::steady_clock::now();
        chrono::duration<double> time_used = chrono::duration_cast<chrono::duration<double>>(t2 - t1);
        cout << "LK Flow use time：" << time_used.count() << " seconds." << endl;
        // 把跟丢的点删掉（跟踪成功的点）
        int i = 0;
        for (auto iter = keypoints.begin(); iter != keypoints.end(); i++)
        {
            if (status[i] == 0)///跟踪失败
            {
                iter = keypoints.erase(iter);///跟踪失败，就将keypoints列表中对应的元素删掉
                continue;
            }
            *iter = next_keypoints[i];///跟踪成功，把跟踪成功的点存到keypoints列表中对应的位置上（点的位置会更新）
            iter++;///（如果跟踪失败就continue了，跟踪成功才会执行到这一步）
        }
        cout << "tracked keypoints: " << keypoints.size() << endl;
        if (keypoints.size() == 0)
        {
            cout << "all keypoints are lost." << endl;
            break;
        }
        // 画出 keypoints
        cv::Mat img_show = image.clone();
        for (auto kp:keypoints)
            cv::circle(img_show, kp, 5, cv::Scalar(0, 240, 0), 1);
        cv::imshow("corners", img_show);
        cv::waitKey(1);
        last_image = image;

    }
}
```

### LSD线段

```c++
#include <opencv2/opencv.hpp>
#include <iostream>
//注意：需要opencv3.4.6以前的版本
using namespace cv;
using namespace std;
int main()
{
	string path = "C:\\lib\\pic\\img5.jpg";
	Mat image = imread(path, IMREAD_GRAYSCALE);//注意必须指明IMREAD_GRAYSCALE，否则无法检测
	//blur(image, image, Size(3, 3)); // 使用3x3内核来降噪
	resize(image, image, Size(), 0.2, 0.2);
	//Canny(image, image, 50, 200, 3); // Apply canny edge

 // Create and LSD detector with standard
	/*
	LSD_REFINE_NONE，没有改良的方式；
	LSD_REFINE_STD，标准改良方式，将带弧度的线（拱线）拆成多个可以逼近原线段的直线度；
	LSD_REFINE_ADV，进一步改良方式，计算出错误警告数量，通过增加精度，减少尺寸进一步精确直线。
	*/
	Ptr<LineSegmentDetector> ls = createLineSegmentDetector(LSD_REFINE_STD);
	vector<Vec4f> lines_std;
	// 检测直线
	ls->detect(image, lines_std);
	// 直线叠加到图像中
	Mat drawnLines(image);
	ls->drawSegments(drawnLines, lines_std);
	// 只画出直线
	Mat only_lines(image.size(), image.type(), CV_32F);//灰度图转彩色
	ls->drawSegments(only_lines, lines_std);
	imshow("【包含原图】", drawnLines);
	imshow("【仅直线】", only_lines);
	waitKey(0);
	return 0;
}
```

### 加载图像序列并提取FAST

```c++

#include <opencv2/opencv.hpp>
#include <iostream>
#include <vector>
#include <string>
#include <fstream>
//#pragma comment( linker, "/subsystem:\"windows\" /entry:\"mainCRTStartup\"" )

using namespace cv;
using namespace std;
int main()
{
	std::string img_dir = "D:\\SLAM\\dataset\\EuRoC\\MH_01_easy\\mav0\\cam0\\data\\*.png";

	std::vector<cv::String> image_files;
	cv::glob(img_dir, image_files);
	if (image_files.size() == 0)
	{
		std::cout << "No image files" << std::endl;
		system("pause");
		return 0;
	}

	vector<cv::KeyPoint> kps;
	cv::Ptr<cv::FastFeatureDetector> detector = cv::FastFeatureDetector::create();

	for (unsigned int frame = 0; frame < image_files.size(); ++frame)
	{
		Mat image = cv::imread(image_files[frame], IMREAD_GRAYSCALE);
		detector->detect(image, kps);

		cvtColor(image, image, COLOR_GRAY2RGB);
		for (auto kp : kps)
		{
			cv::circle(image, kp.pt, 3, cv::Scalar(0, 240, 0), 1);
		}
		cv::imshow("corners", image);
		cv::waitKey(100);
	}
}
```





