#include <opencv2/opencv.hpp>
#include <iostream>
#include <vector>

using namespace cv;
using namespace std;

int main() {
    vector<Point> points;
    points.push_back(Point(10, 10));
    vector<Point> pointsr;
    pointsr.push_back(Point(10, 100));
    vector<Point> pointsy;
    pointsy.push_back(Point(100, 80));

    Mat image(600, 1024, CV_8UC3, Scalar(0, 0, 0));
    circle(image, points[0], 10, Scalar(255, 255, 255), 2);
    circle(image, pointsr[0], 10, Scalar(0, 0, 255), 2);
    circle(image, pointsy[0], 10, Scalar(10, 255, 255), 2);
    imwrite("img.png", image);



    Mat start_img = imread("img.png", IMREAD_COLOR);
    namedWindow("FullDisplay", WINDOW_NORMAL);
    setWindowProperty("FullDisplay", WND_PROP_FULLSCREEN, WINDOW_FULLSCREEN);
    imshow("FullDisplay", start_img);
    waitKey(0);

    return 0;
}