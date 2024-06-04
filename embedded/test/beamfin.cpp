#include <iostream>
#include <fstream>
#include <vector>
#include <opencv2/opencv.hpp>
#include "json/json.h"

using namespace cv;
using namespace std;
using namespace Json;


struct BillInfo {
    float board_y;
    float board_x;
    float ball_diameter;
};

struct Position {
    float y;
    float x;
};

struct Positions {
    Position white;
    Position yellow;
    Position red;
};

struct Message {
    string device_info;
    string unix_time;
    unsigned int num_of_frames;
    float sampling_rate;
    BillInfo bill_info;
    std::vector<Positions> positions;

    Message() : positions(std::vector<Positions>()) {}
};

void openFile(Message &data) //json 파일 값 받기
{
    ifstream stream;
    stream.open("input.json");
    Value root;
    stream >> root;//읽어온 데이터를 root에 넣기
    
    Value billiard_info = root["billiard_info"];
    Value positions = root["positions"];
    Value white = positions["white"];
    Value yellow = positions["yellow"];
    Value red = positions["red"];

    data.unix_time = root["unix_time"].asString();
    data.device_info = root["device_info"].asString();
    data.num_of_frames = root["num_of_frames"].asUInt(); //프레임 개수
    data.sampling_rate = root["sampling_rate"].asFloat() * 5;
    data.bill_info.ball_diameter = billiard_info["ball_diameter"].asFloat() * 5;
    data.bill_info.board_y = billiard_info["board_y"].asFloat()* 5;
    data.bill_info.board_x = billiard_info["board_x"].asFloat() * 5;
    
    for (int i = 0; i < data.num_of_frames; i++)
    {
        data.positions.push_back({ {white[i][0].asFloat() * 5,white[i][1].asFloat() * 5} ,
                                    {yellow[i][0].asFloat() * 5,yellow[i][1].asFloat() * 5},
                                    {red[i][0].asFloat() * 5,red[i][1].asFloat() * 5} });//흰색, 노란색, 빨간색, yx 순서
    }
}

void makeImage(Message &data)  //이미지, 영상 만들기
{
    Mat image(data.bill_info.board_y, data.bill_info.board_x, CV_8UC3, Scalar(0,0,0));//이미지 생성
   //YX 순서
    //시작 이미지 생성
    circle(image, Point(data.positions[0].white.x, data.positions[0].white.y), 10, Scalar(255, 255, 255), -1); //흰색
    circle(image, Point(data.positions[0].yellow.x,  data.positions[0].yellow.y), 10, Scalar(10, 255, 255), -1);  //노란색
    circle(image, Point(data.positions[0].red.x,  data.positions[0].red.y), 10, Scalar(0, 0, 255), -1); //빨간색
    
    //POINT XY 순서
    imwrite("startpoint1.png", image);
    
    if (data.num_of_frames > 1) //영상일 때
    {
        VideoWriter video("output.avi", VideoWriter::fourcc('M', 'J', 'P', 'G'), 10, Size(data.bill_info.board_x, data.bill_info.board_y)); //XY
        video.write(image);
        for (int i = 0; i < data.num_of_frames-1 ; i++) {
            
            line(image, Point(data.positions[i].white.x,  data.positions[i].white.y), Point(data.positions[i + 1].white.x,  data.positions[i + 1].white.y), Scalar(255, 255, 255), 1);//흰색
            line(image, Point(data.positions[i].red.x , data.positions[i].red.y), Point(data.positions[i+1].red.x, data.positions[i+1].red.y), Scalar(0, 0, 255), 1);//빨간색
            line(image, Point(data.positions[i].yellow.x, data.positions[i].yellow.y), Point(data.positions[i+1].yellow.x,  data.positions[i+1].yellow.y), Scalar(10, 255, 255), 1);//노란색
            if(i==0)imwrite("midimg.png", image);
            else if(i==1)imwrite("midimg2.png", image);

            if (i == data.num_of_frames - 2)//마지막 위치 찍어주기
            {
                circle(image, Point(data.positions[i + 1].white.x, data.positions[i + 1].white.y), 5, Scalar(255, 255, 255), -1);
                circle(image, Point(data.positions[i + 1].red.x, data.positions[i + 1].red.y), 5, Scalar(0, 0, 255), -1);
                circle(image, Point(data.positions[i + 1].yellow.x, data.positions[i + 1].yellow.y), 5, Scalar(10, 255, 255), -1);
            }
            //data.bill_info.board_y - 
            // 현재 이미지 프레임을 동영상에 추가
            video.write(image);
        }
        imwrite("endpoint1.png", image);
    }
}

void showImage(Message& data)  //이미지, 영상 출력하기
{

    if (data.num_of_frames == 1) //사진일 때
    {
        Mat start_img;
        start_img = imread("startpoint1.png");
        namedWindow("FullDisplay", WINDOW_NORMAL);
        setWindowProperty("FullDisplay", WND_PROP_FULLSCREEN, WINDOW_FULLSCREEN);
        imshow("FullDisplay", start_img);
        waitKey(0);
    }
    if (data.num_of_frames > 1) //영상일 때
    {
        VideoCapture cap("output.avi");

        //double fps = cap.get(CAP_PROP_FPS);
        //int delay = cvRound(1000 / fps);
        //cap.set(CAP_PROP_FRAME_WIDTH, 1920);
        //cap.set(CAP_PROP_FRAME_HEIGHT, 1080);
        Mat frame;
        namedWindow("FullDisplay", WINDOW_NORMAL);
        setWindowProperty("FullDisplay", WND_PROP_FULLSCREEN, WINDOW_FULLSCREEN);
        while (true) {
            cap >> frame;
            if (frame.empty())
                break;
            imshow("FullDisplay", frame);

            if (waitKey(200) == 27) {
                break;
            }
        }
    }
}
int main()
{
    Message input_data;
    openFile(input_data);
    makeImage(input_data);
    showImage(input_data);
    return 0;
    //만들기
}