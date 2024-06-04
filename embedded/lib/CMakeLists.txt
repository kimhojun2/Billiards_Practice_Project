add_library(dobill ${CMAKE_SOURCE_DIR}/lib/dobilliard.cpp)
add_library(socket ${CMAKE_SOURCE_DIR}/lib/connection.cpp)
add_library(device ${CMAKE_SOURCE_DIR}/lib/devices.cpp)

target_include_directories(dobill PUBLIC
    ${CMAKE_SOURCE_DIR}/include
    ${OpenCV_INCLUDE_DIRS}
    ${JSONCPP_INCLUDE_DIRS})
target_include_directories(socket PUBLIC
    ${CMAKE_SOURCE_DIR}/include
    ${OpenCV_INCLUDE_DIRS}
    ${JSONCPP_INCLUDE_DIRS})
target_include_directories(device PUBLIC
    ${CMAKE_SOURCE_DIR}/include
    ${OpenCV_INCLUDE_DIRS}
    ${JSONCPP_INCLUDE_DIRS})

target_compile_options(dobill PUBLIC -Wall)
target_compile_options(socket PUBLIC -Wall)
target_compile_options(device PUBLIC -Wall)