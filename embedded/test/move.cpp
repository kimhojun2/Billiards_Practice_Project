#include <iostream>
#include <fstream>
#include <vector>
#include <opencv2/opencv.hpp>
#include "json/json.h"
#include <vector>
#include <opencv2/imgproc.hpp>
#include <opencv2/highgui.hpp>


using namespace cv;
using namespace std;
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
struct HSV  //필요 없을듯
{
    int H;
    int S;
    int V;
};

//벡터에 넣으면 됨
void store_Point(int color, cv::Point center, std::vector<std::vector<cv::Point>>& circles_log)  //좌표 저장-> 방법 바꿔야될듯
{
    cout << "1111111111" << endl;
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

void transformImage(cv::Mat& img, cv::Mat& hsv, std::vector<cv::Vec3f>& circles) //이미지 변환, 원 검출
{
    cout << "2222222222" << endl;
    //img = cv::imread("startpoint1.png");
    cv::Mat gray;
    cv::cvtColor(img, hsv, cv::COLOR_RGB2HSV);//hsv변환
    cv::GaussianBlur(hsv, hsv, cv::Size(5, 5), 0);//노이즈 제거 Size 클수록 더 흐릿
    cv::cvtColor(hsv, gray, cv::COLOR_BGR2GRAY);//그레이변환 
    cv::HoughCircles(gray, circles, cv::HOUGH_GRADIENT, 1, 9, 100, 30, 9, 30);  //동그라미 검출
    //입력 이미지, 검출한 원 출력 벡터 , 변환 메소드 , // 해상도 , 원 사이 최소 거리 // 임계값 //최소 반지름 , 최대 반지름
}

void checkColor(cv::Vec3b& colorHSV, BallColor& ball)
{
    cout << "3333333333" << endl;
    //h 0~180 s 0~255 v 0~255
    int H = colorHSV[0];
    int S = colorHSV[1];
    int V = colorHSV[2];
    //std::cout << H << " " << S << " " << V << std::endl;
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
{//검출한 원 색 파악
    cout << "444444444444" << endl;
    BallColor ball;
    cout << circles.size() << endl;  //공 개수 확인
    for (size_t i = 0; i < circles.size(); i++) {  //circles ,,hsv 
        ball.red_ball = 0;  //각 공의 색을 파악하기 위함 -> 9개의 point에서 색을 파악하고, 가장 빈도수가 높은 색을 그 공의 색으로 지정한다.
        ball.white_ball = 0;
        ball.yellow_ball = 0;
        cv::Vec3f circl = circles[i]; //각각의 공의 정보를 받는다 
        cv::Point center = cv::Point(circl[0], circl[1]); //xy  //공의 중심
        int radius = circl[2]; //공의 반지름

        cv::Vec3b colorHSV;  //어차피 최대가 255
        std::cout << "좌표" << circl[0] << " " << circl[1] << std::endl;
        colorHSV = hsv.at<cv::Vec3b>(center.y, center.x);
        checkColor(colorHSV, ball);

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
        std::cout << std::endl;
        // 원의 중심
        cv::circle(img, center, 1, cv::Scalar(0, 100, 100), 3, cv::LINE_AA);
        // 원의 외곽
        cv::circle(img, center, radius, cv::Scalar(255, 0, 255), 3, cv::LINE_AA);
    }
}
void setNum(int color, std::vector<std::vector<cv::Point>>& circles_log)
{
    cout << "555555555555" << endl;
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
    cout << "6666666666666" << endl;
    //노란색이나 흰색이 움직이면 됨
    //노란색[2]
    // vec.erase(vec.begin()) -> 3개 다 하기
    int len = circles_log[2].size();
    for (int j = 1; j < 4; j++)  //흰색
    {
        if (circles_log[1][len - j].y == circles_log[1][len - j - 1].y) //같으면 안움직이는거임
        {
            for (int i = 1; i < 4; i++) //노란색
            {
                if (circles_log[2][len - i].y == circles_log[2][len - i - 1].y) //같으면 안움직이는거임
                    return 0;
            }
        }
    }
    //5개 다르면
    return 1;  //움직인다.
}
int checkStop(std::vector<std::vector<cv::Point>>& circles_log)
{
    cout << "77777777777" << endl;
    
    //vec.erase(vec.begin())
    for (int c = 0; c < 3; c++)
    {
        int len = circles_log[c].size();
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
    cout << "88888888888888fasdgvdfvbbhmnjghfdsa" << endl;
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
}
void checkMovement(int &moving , std::vector<std::vector<cv::Point>>& circles_log)
{
    cout << "999999999999999999" << endl;
    int red_size=circles_log[0].size();
    int white_size = circles_log[1].size();
    int yellow_size = circles_log[2].size();
    if (red_size>0 && white_size>0 && yellow_size>0) //계산 됐을 때
    {///원래 한번에 3개의 공을 다 받아야하는데, 못받는 상황이 생길 수 있어서 그 전의 공의 위치로 넣어줌
        if (red_size >= yellow_size) {  ///
            if (red_size >= white_size)
                setNum(1,circles_log);//빨간색-> 값 못받은게 있을 수 있어서 그 전 값이랑 개수 맞춰주는거
            else
                setNum(2,circles_log);//흰색
        }
        else {
            if (yellow_size >= white_size)
                setNum(3,circles_log);//노란색
            else
                setNum(2,circles_log);//흰색
        }
    }//개수 맞춰주기
    if (moving == 1) //움직일 때 -> 멈췄는 지 알아야함
    {
        //5개 다 같으면
        if (checkStop(circles_log) == 1)//멈춰서 녹화 끝남
        {
            makeFile(circles_log);  //파일 만들어야됨
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
int main()
{
    cv::VideoCapture cap(0);//카메라 받음

    //double fps = cap.get(CAP_PROP_FPS);
    //int delay = cvRound(1000 / fps);
    //cap.set(CAP_PROP_FRAME_WIDTH, 1920);
    //cap.set(CAP_PROP_FRAME_HEIGHT, 1080);
    Mat frame;
    namedWindow("Display", WINDOW_NORMAL); 
    //setWindowProperty("FullDisplay", WND_PROP_FULLSCREEN, WINDOW_FULLSCREEN);
    std::vector<std::vector<cv::Point>> circles_log;///값 저장
    circles_log.resize(3); //red, white, yellow

    circles_log[2].push_back(Point(0, 0));
    circles_log[2].push_back(Point(0, 0));
    circles_log[2].push_back(Point(0, 0));  //노트북 캠으로 노란색 인식 안돼서 잠깐 -> 다른것도 하나씩 해둘까?
    int iii=1;  ////화면 몇번 돌았나
    int moving = 0;//0은 안움직임,  1은 움직여서 기록중
    while (true) {
        cap >> frame;  //영상을 프레임으로 받음
        if (frame.empty())
            break;
        cout << "-----------" << iii++ << " "<<endl;
        cv::Mat img;
        cv::Mat hsv;
        std::vector<cv::Vec3f> circles;  //원 좌표, 반지름 정보 저장
        transformImage(frame, hsv, circles);  //이미지 변환해서 원 검출
        checkAverageColor(frame, hsv, circles, circles_log);  //검출한 원 색 파악
        checkMovement(moving, circles_log);
        imshow("Display", frame);

        if (waitKey(200) == 27) {  //200ms마다
            break;
        }
    }
    return 0;
    //만들기
}
///vb