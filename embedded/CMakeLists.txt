cmake_minimum_required(VERSION 3.11)

project(
    DoBilliard
    VERSION 0.1
    DESCRIPTION "DOBILL ALPHA"
    LANGUAGES CXX)

find_package(Threads REQUIRED)
find_package(OpenCV REQUIRED)
find_package(PkgConfig REQUIRED)

pkg_check_modules(JSONCPP jsoncpp)

add_executable(DoBilliard ${CMAKE_SOURCE_DIR}/dobilliard/main.cpp)

add_subdirectory(${CMAKE_SOURCE_DIR}/lib)

target_include_directories(
    DoBilliard PUBLIC
    ${CMAKE_SOURCE_DIR}/include
    ${OpenCV_INCLUDE_DIRS}
    ${JSONCPP_INCLUDE_DIRS})

target_link_libraries(
    DoBilliard
    dobill
    socket
    device
    Threads::Threads
    ${OpenCV_LIBS}
    ${JSONCPP_LIBRARIES})
