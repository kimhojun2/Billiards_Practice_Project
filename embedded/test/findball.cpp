#include <iostream>
#include <fstream>
#include <vector>
#include <opencv2/opencv.hpp>
#include "json/json.h"
#include <vector>
#include <opencv2/imgproc.hpp>
#include <opencv2/highgui.hpp>
#include <string>


using namespace std;
using namespace cv;
using namespace Json;

float dyst[4] = { 0,0,0.5,-0.5 };//straight
float dxst[4] = { 0.5,-0.5,0,0 };
float dysi[4] = { 0.3, 0.3,-0.3,-0.3 };//side
float dxsi[4] = { 0.3,-0.3,-0.3,0.3 };
struct Position {
    float y;
    float x;
};
struct BallColor {
    int red_ball;
    int yellow_ball;
    int white_ball;
};

const int fwidth = 640;
const int fheight = 480;
const double fps = 10.0;

bool compareContourAreas(vector<Point> contour1, vector<Point> contour2) {
    double i = fabs(contourArea(Mat(contour1)));
    double j = fabs(contourArea(Mat(contour2)));
    return (i > j);
}

cv::VideoCapture initCamera() {
    cv::VideoCapture cap(0);
    if (!cap.isOpened()) {
        std::cerr << "[ERROR] VideoCapture opening failed.\n";
        exit(1);
    }

    cap.set(cv::CAP_PROP_FRAME_WIDTH, ::fwidth);
    cap.set(cv::CAP_PROP_FRAME_HEIGHT, ::fheight);
    cap.set(cv::CAP_PROP_FPS, ::fps);

    return cap;
}

inline int transform(cv::Mat& image, cv::Mat& homo) {
    //cv::Mat hsv;
    //cv::cvtColor(src, dst, cv::COLOR_RGB2HSV);//hsv변환
    //cv::GaussianBlur(hsv, hsv, cv::Size(5, 5), 0);//노이즈 제거 Size 클수록 더 흐릿
    //cv::cvtColor(hsv, gray, cv::COLOR_BGR2GRAY);//그레이변환
    //Mat original;
    Mat contour2;
    image.copyTo(contour2);
    //기본 이미지 출력
    imshow("Original", image);

    Mat gray;
    Mat blur;
    Mat hsv;
    GaussianBlur(image, blur, Size(5, 5), 0);  //노이즈 제거
    cvtColor(blur, hsv, cv::COLOR_BGR2HSV);//hsv변환
    Mat binary;
    cv::inRange(hsv, cv::Scalar(90, 100, 10), cv::Scalar(140, 255, 230), gray);
    //threshold(hsv, binary, 200, 255, THRESH_BINARY);  //바이너리 변환
    //cvtColor(binary, gray, COLOR_BGR2GRAY);  // 컨투어 찾기 위해 gray 변환  gray만 컨투어에 들어감
    //Edge 출력
    //imshow("Canny", edge);
    //imshow("binary",binary);

    vector<vector<Point>> contours;
    vector<Vec4i> hierarchy;
    //그레이가 파랑 변환된거
    findContours(gray, contours, hierarchy, RETR_CCOMP, CHAIN_APPROX_TC89_KCOS);
    //검색방법, 근사화방법
    sort(contours.begin(), contours.end(), compareContourAreas);  //면적 큰 순서대로 정렬
    drawContours(contour2, contours, -1, Scalar(255, 0, 0), 1);  //컨투어 그리기
    // << contours.size() << endl << endl << endl;  //컨투어 크기 보기
    //경계선 출력
    imshow("ContourImage", contour2);

    vector<Point> contours_approx; //컨투어한거 받을거
    //제일 큰 면적부터 보니까 가장 처음 나오는 사각형을 찾아 그게 당구대임
    for (int i = 0; i < contours.size(); i++) {
        double length = arcLength(contours[i], true);  //윤곽의 둘레 길이 계산
        approxPolyDP(contours[i], contours_approx, 0.1 * length, true); //윤곽을 근사화해 contours_approx벡터에 저장
        //둘레의 10%만큼 오차 허용
        //cout << i<<"                     "<<contours_approx.size() << endl;
        if (contours_approx.size() == 4) {//꼭짓점 4개면 끝
            std::vector<cv::Point2f> points; //사각형의 꼭짓점 받음
            for (Point i : contours_approx) {
                points.push_back(i);
                //cout << i << endl;
            }

            // 변환 후 영상의 네 모서리 좌표-> 수정?->이거 순서가 위에랑 같아야하는듯
            std::vector<cv::Point2f> dstPoints = {

                // cv::Point2f(639, 0),
                 
                 cv::Point2f(639, 336),
                 cv::Point2f(639, 0),
				 cv::Point2f(0, 0),
                 cv::Point2f(0, 336)
            };
            /*
                    cv::Point2f(0, 0),
                    cv::Point2f(533, 0),
                    cv::Point2f(533, 283),

            */
            // 호모그래피 행렬 계산
            cv::Mat h = cv::getPerspectiveTransform(points, dstPoints);

            // 호모그래피 적용
            //cv::Mat result;
            cv::warpPerspective(image, homo, h, image.size());   //호모그래피 변환 -> homo 원본 변환 , image : 파랑변환
            cv::warpPerspective(gray, image, h, image.size());
            //호모는 원래 이미지
            //image는 파란색 변환된거
            cv::imshow("Transformed Image", image);  //파란색
            //변환 처음에 한번만 하면 될듯

            ///////여기까지가 변환
            //result를 저장해서 다음 공 찾는 거에 저장하면 될듯
            //변환했을 때 사각형 또 찾아야되나
            return 1;
        }
        contours_approx.clear();  //다시 받을거라 클리어해줌
    }
    return 0;

}
void store_Point(int color, cv::Point center, std::vector<std::vector<cv::Point>>& circles_log)  //좌표 저장-> 방법 바꿔야될듯
{
    //cout << "1111111111" << endl;
    if (color == 1)  ///빨간색
    {
        std::cout << "red" << std::endl;
        circles_log[0].push_back(center);

    }
    else if (color == 2) //흰색
    {
        std::cout << "white" << std::endl;
        circles_log[1].push_back(center);
    }
    else if (color == 3)   //노란색
    {
        std::cout << "yellow" << std::endl;
        circles_log[2].push_back(center);
    }
}

void transformImage(cv::Mat& blue, cv::Mat& img, cv::Mat& hsv, std::vector<cv::Vec3f>& circles) //이미지 변환, 원 검출
{  //파란색, 원래 , 컬러homo를 hsv로 변환
    //cout << "2222222222" << endl;
    cv::Mat edge;

    cv::cvtColor(img, hsv, cv::COLOR_BGR2HSV);//hsv변환
    cv::GaussianBlur(hsv, hsv, cv::Size(5, 5), 0);//노이즈 제거 Size 클수록 더 흐릿
    //-> 색 구분하기 위해 씀

    //cv::cvtColor(hsv, gray, cv::COLOR_BGR2GRAY);//그레이변환 
    //imshow("hsv",hsv);
    //imshow("gray",gray);
	Canny(blue,edge,100,200);
    cv::HoughCircles(edge, circles, cv::HOUGH_GRADIENT, 1, 8,150, 20, 10, 0);   //동그라미 검출
    //입력 이미지, 검출한 원 출력 벡터 , 변환 메소드 , // 해상도 , 원 사이 최소 거리 // 임계값 //최소 반지름 , 최대 반지름
}  //파란거에서 원 검출하고 그 점이 circle이니까 그걸 hsv위에서 판단

void checkColor(cv::Vec3b& colorHSV, BallColor& ball)
{
    //cout << "3333333333" << endl;
    //h 0~180 s 0~255 v 0~255
    int H = colorHSV[0];
    int S = colorHSV[1];
    int V = colorHSV[2];
    std::cout << "hsv "<<H << " " << S << " " << V << std::endl;
    if ((H <= 20 || (H >= 110 && H <= 130)) && S > 115 && V > 210) { ///빨간색
        ball.red_ball++;
        //std::cout << "빨";
    }
    // 노란색 판별
    else if ((H >= 85 && H <= 100) && S > 120 && V > 240) {  ////노란색
        ball.yellow_ball++;
        //std::cout << "노";
    }
    // 흰색 판별
    else if ((H >= 90 && H <= 130) && S < 90 && V > 220) { /////흰색
        ball.white_ball++;
        //std::cout << "흰";
    }
}

inline void checkAverageColor(cv::Mat& img, cv::Mat& hsv, std::vector<cv::Vec3f>& circles, std::vector<std::vector<cv::Point>>& circles_log)
{//검출한 원 색 파악       //원 위치 확인하기 위함, hsv 변환
    //cout << "444444444444" << endl;
    BallColor ball;
    //cout << circles.size() << endl << endl << endl << endl << endl << endl << endl << endl;  //공 개수 확인
    for (size_t i = 0; i < circles.size(); i++) {  //circles ,,hsv 
        ball.red_ball = 0;  //각 공의 색을 파악하기 위함 -> 9개의 point에서 색을 파악하고, 가장 빈도수가 높은 색을 그 공의 색으로 지정한다.
        ball.white_ball = 0;
        ball.yellow_ball = 0;
        cv::Vec3f circl = circles[i]; //각각의 공의 정보를 받는다 
        cv::Point center = cv::Point(circl[0], circl[1]); //xy  //공의 중심
        int radius = circl[2]; //공의 반지름

        cv::Vec3b colorHSV;  //어차피 최대가 255
        std::cout << "pointttt" << " " << circl[0] << " " << circl[1] << " " << circl[2] << std::endl;
        colorHSV = hsv.at<cv::Vec3b>(center.y, center.x);
        checkColor(colorHSV, ball);
        //cout << colorHSV[0] << " " << colorHSV[1] << " " << colorHSV[2] << endl;

        for (int i = 0; i < 4; i++) //가로세로
        {
            //std::cout << "점"<<center.y<<" "<< dyst[i]<<" "<<center.y + dyst[i] * radius << std::endl;
            colorHSV = hsv.at<cv::Vec3b>(center.y + dyst[i] * radius, center.x + dxst[i] * radius);
            checkColor(colorHSV, ball);
        }
        for (int i = 0; i < 4; i++) //대각선
        {
            colorHSV = hsv.at<cv::Vec3b>(center.y + dysi[i] * radius, center.x + dysi[i] * radius);
            checkColor(colorHSV, ball);
        }

        //셋 중에 가장큰것의 파일 저장 
        if (ball.red_ball + ball.yellow_ball + ball.white_ball != 0) //계산 됐을 때
        {
            if (ball.red_ball >= ball.yellow_ball) {  ///숫자로 함수 받아서 거기서 처리
                if (ball.red_ball >= ball.white_ball)
                    store_Point(1, center, circles_log);//빨간색
                else
                    store_Point(2, center, circles_log);//흰색
            }
            else {
                if (ball.yellow_ball >= ball.white_ball)
                    store_Point(3, center, circles_log);//노란색
                else
                    store_Point(2, center, circles_log);//흰색
            }
        }
        //그림그리기
        //std::cout << std::endl;
        // 원의 중심
        cv::circle(img, center, 1, cv::Scalar(0, 100, 100), 3, cv::LINE_AA);
        // 원의 외곽
        cv::circle(img, center, radius, cv::Scalar(255, 0, 255), 3, cv::LINE_AA);
    }
    imshow("circleimg", img);
}
void setNum(int color, std::vector<std::vector<cv::Point>>& circles_log)
{
    //cout << "555555555555" << endl;
    if (color == 1) //빨간색이 제일 많다
    {
        while (circles_log[0].size() != circles_log[1].size()) //빨간색이랑 흰색 크기 같을 때까지
        {
            circles_log[1].push_back(circles_log[1].back()); //제일 뒤에꺼 복붙
        }
        while (circles_log[0].size() != circles_log[2].size()) //빨간색이랑 노란색
        {
            circles_log[2].push_back(circles_log[2].back());
        }
    }
    else if (color == 2)//흰색
    {
        while (circles_log[1].size() != circles_log[0].size())
        {
            circles_log[0].push_back(circles_log[0].back());
        }
        while (circles_log[1].size() != circles_log[2].size())
        {
            circles_log[2].push_back(circles_log[2].back());
        }
    }
    else if (color == 3)//노란색
    {
        while (circles_log[2].size() != circles_log[1].size())
        {
            circles_log[1].push_back(circles_log[1].back());
        }
        while (circles_log[2].size() != circles_log[0].size())
        {
            circles_log[0].push_back(circles_log[0].back());
        }
    }//개수 맞추기
}
int checkMove(std::vector<std::vector<cv::Point>>& circles_log)
{
    //cout << "6666666666666" << endl;

    //노란색[2]
    // vec.erase(vec.begin()) -> 3개 다 하기
    int leny = circles_log[2].size();
    int lenw = circles_log[1].size();
    if (leny > 5 && lenw > 5)
    {
        for (int i = 1; i < 4; i++)  //흰색
        {
            if (circles_log[1][leny - i].y == circles_log[1][leny - i - 1].y) //같으면 안움직이는거임
                return 0;
        }

        for (int i = 1; i < 4; i++) //노란색
        {
            if (circles_log[2][lenw - i].y == circles_log[2][lenw - i - 1].y) //같으면 안움직이는거임
                return 0;
        }
    }

    //5개 다르면
    return 1;  //움직인다.
}
int checkStop(std::vector<std::vector<cv::Point>>& circles_log)
{
    //cout << "77777777777" << endl;

    //vec.erase(vec.begin())
    for (int c = 0; c < 3; c++)

    {
        int len = circles_log[c].size();
        if (len > 5)
            for (int i = 1; i < 5; i++)
            {
                if (circles_log[c][len - i].y != circles_log[c][len - i - 1].y)//그 전이랑 다른게 있으면
                    return 0;//다를 때
            }
    }
    //다 같으니까
    return 1; //멈춤
    //같을 때
}
void makeFile(std::vector<std::vector<cv::Point>>& circles_log)
{
    //cout << "88888888888888fasdgvdfvbbhmnjghfdsa" << endl;
    //cout << "88888888888888fasdgvdfvbbhmnjghfdsa" << endl;
    //cout << "88888888888888fasdgvdfvbbhmnjghfdsa" << endl;
    //cout << "88888888888888fasdgvdfvbbhmnjghfdsa" << endl;
    //값 다 바꿔야함
    Value root;        // json의 메인 객체이다.
    root["device_info"] = "";    // device_info를 키값으로 가지는 ""이라는 값을 생성
    root["unix_time"] = "";
    root["num_of_frames"] = 1;
    root["sampling_rate"] = 60.0;

    Value billiard_info;            //객체
    billiard_info["board_y"] = 60.0;
    billiard_info["board_x"] = 120.0;
    billiard_info["ball_diameter"] = 5.60;
    root["billiard_info"] = billiard_info;

    Value positions;
    Value white; //배열

    for (int i = 0; i < circles_log[1].size(); i++)
    {
        Value w1;//배열
        w1.append(circles_log[1][i].y);
        w1.append(circles_log[1][i].x);
        white.append(w1);
    }

    positions["white"] = white;

    Value yellow;
    for (int i = 0; i < circles_log[2].size(); i++)
    {
        Value y1;
        y1.append(circles_log[2][i].y);
        y1.append(circles_log[2][i].x);
        yellow.append(y1);
    }

    positions["yellow"] = yellow;
    Value red;
    for (int i = 0; i < circles_log[0].size(); i++)
    {
        Value r1;
        r1.append(circles_log[0][i].y);
        r1.append(circles_log[0][i].x);
        red.append(r1);
    }
    positions["red"] = red;
    root["positions"] = positions;
    StyledWriter writer;
    string str = writer.write(root);    // str에 만들어진 json을 넘긴다.

    ofstream stream;
    stream.open("mov.json");
    stream << str;                // json을 파일로 출력
	//cout<<"adnvsjiopjnvbrnwojnsdvmpoebniwfmordfk"<<endl<<endl<<endl<<endl<<endl<<endl;
}

void checkMovement(int& moving, std::vector<std::vector<cv::Point>>& circles_log)
{
    //cout << "999999999999999999" << endl;
    int red_size = circles_log[0].size();
    int white_size = circles_log[1].size();
    int yellow_size = circles_log[2].size();
    if (red_size > 0 && white_size > 0 && yellow_size > 0) //계산 됐을 때
    {///원래 한번에 3개의 공을 다 받아야하는데, 못받는 상황이 생길 수 있어서 그 전의 공의 위치로 넣어줌
        if (red_size >= yellow_size) {  ///
            if (red_size >= white_size)
                setNum(1, circles_log);//빨간색-> 값 못받은게 있을 수 있어서 그 전 값이랑 개수 맞춰주는거
            else
                setNum(2, circles_log);//흰색
        }
        else {
            if (yellow_size >= white_size)
                setNum(3, circles_log);//노란색
            else
                setNum(2, circles_log);//흰색
        }
    }//개수 맞춰주기
    if (moving == 1) //움직일 때 -> 멈췄는 지 알아야함
    {
        //5개 다 같으면
        if (checkStop(circles_log) == 1)//멈춰서 녹화 끝남
        {
            ///cout << "공 멈춤!!!" << endl;
            //makeFile(circles_log);  //파일 만들어야됨
            moving = 0;  //이제 멈췄다
        }
    }
    else if (moving == 0)// 안움직일 때 -> 움직이는 지 알아야함 + 5개 넘으면 pop
    {
        if (circles_log[2].size() >= 5)//5개 이상 쌓이면 -> 위에서 처리해줘서 크기는 다 같음
        {
            //같은 지 체크
            //다르다면 pop하기
            if (checkMove(circles_log) == 1) //움직인다!-> moving 1로 바꿔줘 움직인다 인식해두기
                moving = 1;
            else  //안움직이면 5개만!!! 쓸모없는 값은 버림 
            {
                while (circles_log[0].size() != 5)///5될 때까지 줄임
                {
                    for (int i = 0; i < 3; i++) {
                        circles_log[i].erase(circles_log[i].begin());
                    }//맨 앞 없애기
                }
            }
        }
    }
    //5개까지하기
    //5개부터 다르면 시작이다!!-> flag정하기
}

int main(int argc, char* argv[]) {
    cv::VideoCapture cap = initCamera();
    std::vector<std::vector<cv::Point>> circles_log;///값 저장
    circles_log.resize(3); //red, white, yellow

    int moving = 0;//0은 안움직임,  1은 움직여서 기록중

    while (true) {
        cv::Mat frame, homo, hsv;
        if (!cap.grab()) {
            std::cerr << "[ERROR] Camera grabbing failed.\n";
            break;
        }
        else if (!cap.retrieve(frame)) {
            std::cerr << "[ERROR] Retrieving frame failed.\n";
            break;
        }
        else {
            if (transform(frame, homo) == 1)  //frame은 파랑 호모 변환, homo는 원래 이미지 호모 변환
            {//변환 성공해야
                std::vector<cv::Vec3f> circles;  //원 좌표, 반지름 정보 저장
                transformImage(frame, homo, hsv, circles);  //이미지 변환해서 원 검출 frame 파랑 변환, homo 원본 변환
                ///이제 hsv가 homo에서 hsv 변환한것
                
                checkAverageColor(homo, hsv, circles, circles_log);  //검출한 원 색 파악
                checkMovement(moving, circles_log);
                //imshow("Display", homo);
                if (waitKey(100) == 27)  //200ms마다
                    break;
            }
            //cv::imshow("Image", frame);
            //cv::imshow("LIVE", trsf);
            //if (cv::waitKey(1) >= 0) break;
        }
    }
    cap.release();

    return 0;
}