# README

# 🎱Do! 당구당

## 📢 프로젝트 소개

---

- 개발 기간 : 2024년 1월 8일 [월] ~ 2024년 2월 14일 [목]
- 주제 : 초보자를 위한 당구게임 보조 **IoT**와  **웹** 커뮤니티 서비스
- 개발 인원 : 김호준, 박모은, 박세준, 유혜림
- 역할 [팀명 : IoT (Improved, our Team) ]

![Untitled](README%20d75b9919ec5b4461a98525deff191724/Untitled.png)

# **🌏 Project**

---

 높은 접근성에도 불구하고, 체육 도장이나 골프 연습장과 같은 다양한 체육 시설이 증가하는 반면, 당구장의 수는 감소하는 추세입니다. 이러한 현상의 원인으로는 당구의 상대적으로 높은 입문 장벽, 여러 사람과 함께 해야 한다는 인식, 그리고 PC방과 같은 업종과의 경쟁을 들 수 있습니다. 

 이 문제를 해결하기 위해 반복 연습을 위한 위치 표시 기능, 자신이 친 공의 경로를 복기할 수 있는 기능, 질문과 답변이 이루어지는 커뮤니티, 그리고 초보자를 위한 연습 문제 제공공하여 당구 입문과 실력 향상을 돕는 Do! 당구당 서비스를 기획하였습니다.

## **주요 기능**

---

![KakaoTalk_20240215_130922668.png](README%20d75b9919ec5b4461a98525deff191724/KakaoTalk_20240215_130922668.png)

### 연습하기

- 최근 공 시작 좌표 확인
- 최근 공 경로 확인

![KakaoTalk_20240215_130531114.png](README%20d75b9919ec5b4461a98525deff191724/KakaoTalk_20240215_130531114.png)

![KakaoTalk_20240215_130531114_03.png](README%20d75b9919ec5b4461a98525deff191724/KakaoTalk_20240215_130531114_03.png)

![KakaoTalk_20240215_130531114_01.png](README%20d75b9919ec5b4461a98525deff191724/KakaoTalk_20240215_130531114_01.png)

### 질문답변

![Untitled](README%20d75b9919ec5b4461a98525deff191724/Untitled%201.png)

‘질문하기‘ 버튼을 선택하여 커뮤니티 페이지에 해당 공 배치를 질문 가능

![Untitled](README%20d75b9919ec5b4461a98525deff191724/Untitled%202.png)

### 답변하기

![Untitled](README%20d75b9919ec5b4461a98525deff191724/Untitled%203.png)

질문글의 상세 페이지에서 ‘풀어보기’ 버튼을 눌러 질문에 배치된 좌표와 동일한 좌표를 앱에 표시

![Untitled](README%20d75b9919ec5b4461a98525deff191724/Untitled%204.png)

같은 위치에 공을 두고 친 후 답변에 첨부할 경로를 선택하여 답글 작성

![Untitled](README%20d75b9919ec5b4461a98525deff191724/Untitled%205.png)

![Untitled](README%20d75b9919ec5b4461a98525deff191724/Untitled%206.png)

3구에서 자주 볼 수 있는 공 배치, 미리보기를 제공

공 배치 기능, 내가 친 공 경로확인, 정답확인 기능 제공

![Untitled](README%20d75b9919ec5b4461a98525deff191724/Untitled%207.png)

![Untitled](README%20d75b9919ec5b4461a98525deff191724/Untitled%208.png)

## 모바일 앱

![Untitled](README%20d75b9919ec5b4461a98525deff191724/Untitled%209.png)

질문글 조회, 잡담글 작성/수정

![Untitled](README%20d75b9919ec5b4461a98525deff191724/Untitled%2010.png)

프로필 수정, 로그아웃 기능

최근 내가 친 경로 확인

내가 작성한 게시글 확인

## **주요 기술**

---

OpenCV를 이용한 당구공의 좌표 인식

### 당구공 인식

1. 원본 이미지
2. GaussianBlur를 이용해 노이즈를 제거합니다.

![Untitled](README%20d75b9919ec5b4461a98525deff191724/Untitled%2011.png)

![Untitled](README%20d75b9919ec5b4461a98525deff191724/Untitled%2012.png)

1. 이미지 색상 공간을 BGR에서 HSV로 변환해 색 인식을 용이하게 합니다.
2. 파란색 범위를 흰색, 다른 색상은 검은색으로 처리한 후 Contour를 진행합니다.
3. Canny를 통해 edge를 검출합니다.

![Untitled](README%20d75b9919ec5b4461a98525deff191724/Untitled%2013.png)

![Untitled](README%20d75b9919ec5b4461a98525deff191724/Untitled%2014.png)

![Untitled](README%20d75b9919ec5b4461a98525deff191724/Untitled%2015.png)

1. 가장 큰 사각형인 당구대를 찾았습니다. 이 당구대의 꼭짓점의 좌표를 이용한 Homography변환을 통해 직사각형의 당구대를 얻었습니다. 
2. Canny한 이미지에서도 직사각형의 당구대를 찾을 수 있었습니다. 이 이미지에서 HoughCircle을 이용해 원을 찾습니다.

![Untitled](README%20d75b9919ec5b4461a98525deff191724/Untitled%2016.png)

![Untitled](README%20d75b9919ec5b4461a98525deff191724/Untitled%2017.png)

**최종 공의 색 탐지 영상**

### 서버 통신 방법

Nginx + gunicorn + django + (socket server) 를 활용해서 bakcend 서버를 구축하고

Flutter 와 django 는 Rest API를 활용한 HTTP프로토콜 통신으로 구성되어 있고, 디바이스와 django는 socket통신을 이용한 multi thread 방식으로 통신하였습니다.

### 좌표데이터 시각화

Flutter 내장 Custom Painter 라이브러리 사용

좌표, 당구대 크기, 당구공 크기 정보를 받아 화면 비율에 맞게 조절하여

당구공의 이동경로좌표를 시각화