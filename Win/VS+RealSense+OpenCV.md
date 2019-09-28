1. ##### 新建空的c++项目

   设置文Release x64

2. ##### 添加C++包含目录

   ```
   C:\Program Files (x86)\Intel RealSense SDK 2.0\include
   C:\Users\liuly\opencv3\build\include
   ```

3. ##### 添加C++库目录

   ```
   C:\Users\liuly\opencv3\build\x64\vc15\lib
   C:\Program Files (x86)\Intel RealSense SDK 2.0\lib\x64
   ```

4. ##### 添加lib的链接

   链接器>输入>附加依赖项：`opencv_world347.lib`、`realsense2.lib`

5. ##### 测试im-show程序

   ```c++
   
   #include <librealsense2/rs.hpp> //包括RealSense跨平台API
   #include <opencv2/opencv.hpp>   //包含penCV API
   
   int main(int argc, char * argv[]) try // 有个try
   {
   
   	rs2::colorizer color_map;// 声明depth colorizer以实现深度数据的可视化
   	rs2::pipeline pipe;// 声明RealSense pipeline，用来封装实际设备和传感器
   	pipe.start();// 使用默认的推荐配置开始流式传输
   
   	using namespace cv;
   	const auto window_name = "显示深度图像";
   	namedWindow(window_name, WINDOW_AUTOSIZE);
   
   	// 循环读取数据并显示
   	while (waitKey(1) < 0 && getWindowProperty(window_name, WND_PROP_AUTOSIZE) >= 0)
   	{
   		rs2::frameset data = pipe.wait_for_frames(); // 等待相机的下一组帧
   		rs2::frame depth = data.get_depth_frame().apply_filter(color_map);//从data中取出着色深度数据
   
   																		  // 查询帧大小（宽度和高度）
   		const int w = depth.as<rs2::video_frame>().get_width();
   		const int h = depth.as<rs2::video_frame>().get_height();
   
   		// 从着色深度数据创建大小为(w,h)的opencv矩阵
   		Mat image(Size(w, h), CV_8UC3, (void*)depth.get_data(), Mat::AUTO_STEP);
   
   		// 更新窗口
   		imshow(window_name, image);
   	}
   
   	return EXIT_SUCCESS;
   }
   // 执行失败的话
   catch (const rs2::error & e)
   {
   	std::cerr << "RealSense error calling " << e.get_failed_function() << "(" << e.get_failed_args() << "):\n    " << e.what() << std::endl;
   	return EXIT_FAILURE;
   }
   catch (const std::exception& e)
   {
   	std::cerr << e.what() << std::endl;
   	return EXIT_FAILURE;
   }
   ```

   