#include <opencv2/opencv.hpp>
#include <iostream>
#include <vector>

using namespace cv;
using namespace std;

void connectCamera()//카메라 연결
{

}

void checkStartGesture()//제스처 인식
{
	while (1)
	{
		//제스처 인식하는 코드
		//제스처 인식하면 return으로 빠져나와서 다음 코드 진행
	}

}

void Startserver() //서버 연결
{
	
}

int getFile() //정보 받기
{
	//파일 받았는지 return 
}

void makeVideo()//영상 생성
{

}
void project()//프로젝터 투사
{

}
void makeImage()//시작점 이미지 제작
{

}
void sameBallPoint()//주어진 좌표랑 같은 곳이 두었는지 판단
{
	//-> 언제까지 판단하는지? 사람들이 놓고있는 중인데 다른곳에 놓았다고 판단하면 안되니까
}
void makeFile()  //파일 만들기
{

}
void sendFile()  //파일 서버에 전송
{

}
void getInfo()
{

}
void recording() //녹화시작
{
	if (1)//모든 공이 사라지거나 2분 경과
	{

	}
	else if (1)//모든 공 정지
	{
		makeFile(); //파일 만들기
		sendFile(); //파일 서버에 전송
	}
	else
	{

	}

}

void checkInfoType()  
{
	if (1)//시작좌표 없는 게임 실행
	{
		if (getFile())//파일이 들어오면
			checkInfoType();  //파일 정보 체크
		else //파일 안들어오면
		{

		}

		
	}
	else if (1) //시작좌표 있는 게임 실행
	{

		if (getFile())//파일이 들어오면
			checkInfoType();  //파일 정보 체크
		else //파일 안들어오면
		{

		}



		makeImage(); //시작좌표 이미지 만들어서 
		project(); //투사
		sameBallPoint();//주어진 좌표랑 같은 곳이 두었는지 판단
		if (getFile())//파일이 들어오면
			checkInfoType();  //파일 정보 체크
		else //파일 안들어오면
		{

		}
	}
	else if (1) //경로 보기
	{
		makeVideo(); //경로 이미지 만들어서
		project();  //투사
		if (getFile())//파일이 들어오면
		{
			////블랙으로 project();  //투사
			checkInfoType();  //파일 정보 체크
		}
	}
	
}



int main() {

	//전원 연결하면 카메라 연결
	//CAM, Projector 초기화
	connectCamera();

	//사용자 제스처 대기모드 진입

	//제스처 인식
	checkStartGesture();

	//제스처 인식해야 함수 빠져나옴
	//소켓 통신 시작
	Startserver();

	while (1)
	{
		//서버로부터 정보 수신
		//서버에서 파일 받기??????????
		if(getFile())//파일이 들어오면
		checkInfoType();  //파일 정보 체크
	}
}


/*
공을 치기 전에 시작 제스처 필요한지?
시작 좌표 주어진 것일때, 다른 위치에 공을 두는 경우
-> 우리가 공을 두는 중인지 판단하기 어렵다?
-> 그냥 이런 상황이면 항상 그 위치에서 공은 친다고 생각하고
만약 다른 위치에 두고 싶으면 창을 나가는걸로 하자-> 시작좌표 없는 게임 실행 창으로


서버랑은 json파일만 받는건지???
어떤 모드에 들어갔는지에 대한 정보도 json파일로????



좌표는 어디에 저장하는지?
항상 저장하고있는지?
언제부터 시작한건지 데이터에서 구분을 어떻게 할 것인지?

빔은 언제 안쏠건지? 

*/