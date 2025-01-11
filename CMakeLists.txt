
#1.项目基本信息
cmake_minimum_required(VERSION 3.16)  # 指定CMake的最低版本要求
project(smart-cycling-computers VERSION 0.1 LANGUAGES CXX)  # 定义项目名称和版本，指定使用C++语言

# 启用详细的CMake输出
set(CMAKE_VERBOSE_MAKEFILE ON)

# 2.设置Qt版本和路径
set(CMAKE_PREFIX_PATH "/opt/Qt/6.5.2/gcc_64")

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
# MOC (Meta-Object Compiler)：是 Qt 的一部分，负责处理 Qt 特有的功能，比如信号与槽机制、Qt 的元对象系统等。
set(CMAKE_AUTORCC ON)
#自动处理资源文件：当开启这个选项后，CMake 会在构建过程中自动处理项目中的 Qt 资源文件。它会调用 Qt 的 rcc（Qt Resource Compiler）工具来编译这些资源文件。
# set(CMAKE_AUTOUIC ON) # 开启UI文件编译

# 查找Qt包
find_package(Qt6 6.5 REQUIRED COMPONENTS 
    Core
    Quick 
    Multimedia 
    WebEngineCore 
    WebEngineQuick
)

#3. 添加源文件
# 添加可执行文件
qt_add_executable(scc-app
    src/main.cpp
    src/network/httputils.cpp
    qml.qrc
    res.qrc
)

# 4.链接Qt库
target_link_libraries(scc-app PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::Multimedia
    Qt6::WebEngineCore
    Qt6::WebEngineQuick
)

# 其他
# 调试信息
message("CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")
message("Qt6_DIR: ${Qt6_DIR}")

# 包含qt的头文件 资源文件 UI文件
# include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)

# 自定义构建
# add_library(httputils SHARED src/network/httputils.cpp)
# target_link_libraries(httputils PRIVATE Qt6::Core)

# 安装和部署
# install(TARGETS scc-app DESTINATION bin)
# install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/src/network/httputils.h DESTINATION include/network)
# install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/src/network/httputils.cpp DESTINATION src/network)


