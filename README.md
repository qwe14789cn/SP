# MATLAB信号处理工具箱 Signal Processing(SP)
原radar_tools工具箱重新整理，因为里面有好多重复，废弃的函数，解释说明功能也不统一，因此重新整理了一下改名发布

* 删除了一些无意义的函数
* 重新统一了函数注释
* 更新了几个新的常用函数
* 开始加入一些通信算法功能


## 使用方法
如要要用雷达信号处理工具箱 例如+sp,将 "+sp"文件夹放在调用目录下.运行时命令直接输入 sp.[函数名] 即可


## Radar Toolbox
|函数名|说明|
|---|---|
|ad_analyzer                |ADC性能分析工具(仍然需要完善，功能不全)
|array_pattern              |天线方向图绘制函数
|auto_fusion                |二进制图像中的最大连通域
|auto_scale                 |将输入数据的最大值按照ADC的位宽进行量化
|b2d                        |有符号2进制转10进制
|cfar_alpha                 |计算cfar阈值因子alpha
|cfar_detector              |奈曼皮尔逊检测器
|complex2vector             |复数矢量可视化
|d2b                        |有符号10进制转2进制
|d2h                        |有符号10进制转16进制
|data_reshape               |沿着列方向reshape，多余的尾巴切掉或者填0
|dbm2vpp                    |dbm 单位转化为电压值
|exp_wave                   |复数点频信号生成器
|filter_w                   |矢量滤波器与矢量信号卷积
|frac_deg2bin               |十进制小数到二进制小数
|h2d                        |有符号16进制转10进制
|hlagr2                     |拉格朗日分数延迟滤波器
|iq_data                    |1/4 生成IQ数据
|kalmus_filter              |卡尔玛斯滤波器
|L_norm_array_pattern       |一维线阵天线方向图快速绘制
|LinsiFFT                   |某个AD测试复制过来的ADC性能分析代码(未完成)
|lms                        |LMS自适应滤波器
|lms2                       |LMS自适应滤波器 带通道时延
|matrix_ml                  |频率因子阵，矩阵形式的傅里叶变换
|nlm_wave                   |非线性调频信号脉冲压缩生成工具
|p3                         |复信号绘制画图工具
|pc_factor                  |频域加窗生成脉冲压缩频域因子
|pow2cfar                   |奈曼皮尔逊检测器，matlab自带官方版
|radar_eq                   |雷达方程
|randn_complex              |复噪声高斯分布随机生成器
|read_bin                   |读取bin文件数据
|spec                       |信号频谱分析工具
|steering_vector            |空间传播方法计算导向矢量
|T_mailoux                  |零陷加深扩张矩阵
|udp_Rx                     |udp数据接收函数
|vpp2dbm                    |电压转换为dbm
|word                       |正交投影加宽零陷抗干扰
|write_bin                  |写入bin文件数据
|write_data                 |写入matrix 数据 到 *.txt 或者 *.dat 格式
|nm                         |单纯型优化算法，等价于matlab自带的fminsearch
|pso                        |粒子群优化算法，等价于matlab自带的particleswarm

## Optimization Toolbox
|函数名|说明|
|---|---|
|nm                         |单纯型优化算法，等价于matlab自带的fminsearch
|pso                        |粒子群优化算法，等价于matlab自带的particleswarm

## Camera Toolbox
|函数名|说明|
|---|---|
|fov2vector                 |相机的fov角度转换为光路的矢量坐标系
|picking                    |判断射线与三角形面是否有交点
|pixel2vector               |小数像素转换光线的vector相对于相机坐标系
|points2plane               |最小二乘法从点集合求解平面方程
|ray_plane_intersection     |计算射线与平面的交点以及射线的距离
|rotate_2d                  |二维向量旋转矩阵,对列向量左乘进行旋转操作
|rotate_ad                  |绕着某个轴旋转特定角度的旋转矩阵
|rotate_xd                  |绕X方向的旋转矩阵
|rotate_yd                  |绕Y方向的旋转矩阵
|rotate_zd                  |绕Z方向的旋转矩阵
|show_vector                |二维与三维列向量可视化
|undistortImage2            |图像畸变矫正还原(张正友畸变还原算法)
|vector_angle               |计算两个矢量的夹角