#pragma once

#include <array>
#include <atomic>
#include <chrono>
#include <condition_variable>
#include <cstdint>
#include <mutex>
#include <thread>
#include <unordered_set>

#include <jsoncpp/json/json.h>
#include <opencv2/opencv.hpp>

// #define DEVELOP
#define DEBUG

#ifdef DEVELOP
#ifndef DEBUG
#define DEBUG
#endif
#endif

#ifdef DEBUG
#include <chrono>
#include <iostream>
#include <string>
#include <thread>
#define LOG(...)                                                        \
	{                                                                   \
		using namespace std;                                            \
		using namespace std::chrono;                                    \
		stringstream ss;                                                \
		size_t tid = hash<thread::id>{}(this_thread::get_id()) % 96797; \
		auto now = system_clock::to_time_t(system_clock::now());        \
		cout << "[ " << tid << " ";                                     \
		cout << put_time(localtime(&now), "%T ");                       \
		cout << __LINE__ << ":" << __func__ << " ] ";                   \
		cout __VA_OPT__(<<) __VA_ARGS__ << endl;                        \
	}
#else
#include <iostream>
#include <string>
#define LOG(...)                                      \
	{                                                 \
		cout << "[ " << tid << " ";                   \
		cout << put_time(localtime(&now), "%T ");     \
		cout << __LINE__ << ":" << __func__ << " ] "; \
		cout __VA_OPT__(<<) __VA_ARGS__ << endl;      \
	}
#endif

// START OF DECLARATIONS AND INLINE FUNCTION DEFINITIONS
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Coordinate system
// O--------x---------->
// |
// |       Notation order:
// y       (y, x) for image
// |       OpenCV general format for the rest
// |
// V

// Mode
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
namespace bill {
	enum Mode {
		DEFAULT = -2,
		TERM,
		FREE,
		PRAC,
		SHOW
	};
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Mode

// BillInfo
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
namespace bill {
	struct BillInfo {
		float board_y;
		float board_x;
		float ball_diameter;
		float cushion_len;

		BillInfo();
		BillInfo(const float, const float, const float, const float);
	};
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// BillInfo

// Position
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
namespace bill {
	struct Position {
		float y;
		float x;

		Position();
		Position(float y, float x);
		Position(const Position& p);
		friend Position operator+(const Position&, const Position&);
		friend Position operator-(const Position&, const Position&);
		friend Position operator/(const Position&, const Position&);
		Position& operator+=(const Position& p);
		Position& operator-=(const Position& p);
		Position& operator/=(const Position& p);
	};

	Position operator+(const Position&, const Position&);
	Position operator-(const Position&, const Position&);
	Position operator/(const Position&, const Position&);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Position

// Trajectory
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
namespace bill {
	using Trajectory = std::deque<Position>;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Trajectory

// Positions
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
namespace bill {
	struct Positions {
		Position white;
		Position yellow;
		Position red;
	};
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Positions

// Message
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
namespace bill {
	struct Message {
		bool valid;
		uint64_t device_info;
		std::string unix_time;
		unsigned int num_of_frames;
		float sampling_rate;
		BillInfo bill_info;
		Trajectory trj_w;
		Trajectory trj_y;
		Trajectory trj_r;

		Message();
		Message& operator<<(Json::Value&);
		friend Message operator>>(const Message&, Json::Value&);
	};

	Message operator>>(const Message&, Json::Value&);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Message

// Timer
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
namespace bill {
	class Timer {
	private:
		std::chrono::time_point<std::chrono::system_clock> start_time;
		std::chrono::time_point<std::chrono::system_clock> end_time;
		int64_t dur;
		std::atomic<bool> cont;
		std::atomic<uint8_t> iteration;
		uint64_t total_iteration;
		const uint8_t interval;
		std::atomic<float> fps;
		std::thread t_calc;
		bool f_print;

		void calculate();

	public:
		Timer(const uint8_t, bool = true);
		~Timer();
		inline void start();
		inline void print();
		inline void mute();
		inline void count();
		inline int64_t duration();
		inline double avgfps();
		inline void terminate();
	};
}

// DECLARATION
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// INLINE FUNCTION DEFINITIONS

void bill::Timer::start() {
	using namespace std;
	using namespace std::chrono;
	this->cont = true;
	this->t_calc = thread(&Timer::calculate, this);
	this->start_time = system_clock::now();
}

void bill::Timer::print() {
	this->f_print = true;
}

void bill::Timer::mute() {
	this->f_print = false;
}

void bill::Timer::count() {
	++this->iteration;
	++this->total_iteration;
}

int64_t bill::Timer::duration() {
	using namespace std::chrono;

	time_point<system_clock> cur_time;

	if (this->cont) {
		cur_time = system_clock::now();
	}
	else {
		cur_time = end_time;
	}

	return duration_cast<seconds>(cur_time - this->start_time).count();
}

double bill::Timer::avgfps() {
	using namespace std::chrono;

	time_point<system_clock> cur_time;

	if (this->cont) {
		cur_time = system_clock::now();
	}
	else {
		cur_time = end_time;
	}

	this->dur = duration_cast<seconds>(cur_time - this->start_time).count();

	return (double)this->total_iteration / (double)this->dur;
}

void bill::Timer::terminate() {
	using namespace std::chrono;

	this->end_time = system_clock::now();
	this->cont = false;
	this->t_calc.join();
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Timer

// Visualizer
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
namespace bill {
	class Visualizer {
	private:
		const BillInfo billinfo;
		const BillInfo frameinfo;
		uint16_t prj_w;
		uint16_t prj_h;
		uint16_t dp_w;
		uint16_t dp_h;
		cv::Mat mat_hom_inv; // pool to image
		cv::Mat mat_hom_prj; // contour to dp
		const unsigned char timeout;
		const float ratio;
		const float fps;
		std::atomic<bool> f_running;
		std::mutex mut_thread;
		std::thread t_running;
		pthread_t th_running;
		std::atomic<bool> f_terminate;

		inline cv::Point2f tr(const cv::Point2f& src) {
			LOG("[ DEBUG ] Perspective transform.");
			using namespace std;
			using namespace cv;
			vector<Point2f> srcs(1, src);
			vector<Point2f> auxs;
			cv::perspectiveTransform(srcs, auxs, this->mat_hom_inv);
			vector<Point2f> dsts;
			cv::perspectiveTransform(auxs, dsts, this->mat_hom_prj);
			return dsts[0];
		}

		void vistrj(const Message& msg) {
			LOG("[ INFO ] Core visualizer.");
			using namespace std;
			using namespace cv;

			this->f_running = true;
			namedWindow("FullDisplay", WINDOW_NORMAL);
			setWindowProperty("FullDisplay", WND_PROP_FULLSCREEN, WINDOW_FULLSCREEN);

			Mat frame(this->dp_h, this->dp_w, CV_8UC3, Scalar(0, 0, 0));
			imshow("FullDisplay", frame);

			LOG("[ INFO ] Start rendering image.");
			Point pos_prev_white(tr({msg.trj_w[0].x, msg.trj_w[0].y}));
			Point pos_prev_yellow(tr({msg.trj_y[0].x, msg.trj_y[0].y}));
			Point pos_prev_red(tr({msg.trj_r[0].x, msg.trj_r[0].y}));
			for (int i = 1; i < msg.num_of_frames; ++i) {
				Point pos_white(tr({msg.trj_w[i].x, msg.trj_w[i].y}));
				Point pos_yellow(tr({msg.trj_y[i].x, msg.trj_y[i].y}));
				Point pos_red(tr({msg.trj_r[i].x, msg.trj_r[i].y}));

				line(frame, pos_prev_white, pos_white, Scalar(255, 255, 255), 10); // 흰색
				line(frame, pos_prev_yellow, pos_yellow, Scalar(0, 0, 255), 10);   // 빨간색
				line(frame, pos_prev_red, pos_red, Scalar(10, 255, 255), 10);      // 노란색

				imshow("FullDisplay", frame);

				pos_prev_white = pos_white;
				pos_prev_yellow = pos_yellow;
				pos_prev_red = pos_red;
			}

			circle(frame, pos_prev_white, 10, Scalar(255, 255, 255), -1); // 흰색
			circle(frame, pos_prev_yellow, 10, Scalar(10, 255, 255), -1); // 노란색
			circle(frame, pos_prev_red, 10, Scalar(0, 0, 255), -1);       // 빨간색

			imshow("FullDisplay", frame);

			LOG("[ INFO ] Rendering done.");
			this->f_running = false;
			// cv::waitKey(0);
		}

		void vispos(const Message& msg) {
			using namespace std;
			using namespace cv;

			this->f_running = true;
			namedWindow("FullDisplay", WINDOW_NORMAL);
			setWindowProperty("FullDisplay", WND_PROP_FULLSCREEN, WINDOW_FULLSCREEN);

			Point pos_white(tr({msg.trj_w[0].x, msg.trj_w[0].y}));
			Point pos_yellow(tr({msg.trj_y[0].x, msg.trj_y[0].y}));
			Point pos_red(tr({msg.trj_r[0].x, msg.trj_r[0].y}));

			Mat frame(this->frameinfo.board_y, this->frameinfo.board_x, CV_8UC3, Scalar(0, 0, 0));
			circle(frame, pos_white, 10, Scalar(255, 255, 255), -1); // 흰색
			circle(frame, pos_yellow, 10, Scalar(10, 255, 255), -1); // 노란색
			circle(frame, pos_red, 10, Scalar(0, 0, 255), -1);       // 빨간색

			imshow("FullDisplay", frame);
			this->f_running = false;
			// wait indefinitely
			// waitKey(0);
		}

		void visblk() {
			using namespace std;
			using namespace cv;

			this->f_running = true;
			namedWindow("FullDisplay", WINDOW_NORMAL);
			setWindowProperty("FullDisplay", WND_PROP_FULLSCREEN, WINDOW_FULLSCREEN);

			Mat frame(this->dp_h, this->dp_w, CV_8UC3, Scalar(0, 0, 0));
			imshow("FullDisplay", frame);

			this->f_running = false;
			// wait indefinitely
			// waitKey(0);
		}

		void handleBackgroundThread() {
			if (this->f_running) {
				std::lock_guard<std::mutex> lg(this->mut_thread);
				LOG("[ INFO ] Terminating running thread.");
				cv::destroyWindow("FullDisplay");
				LOG("[ INFO ] Window destroyed.");
				pthread_cancel(this->th_running);
				LOG("[ INFO ] Thread canceled.");
				if (t_running.joinable())
					t_running.join();
				this->f_running = false;
				LOG("[ INFO ] Terminated running thread.");
			}
			else {
				LOG("[ INFO ] No backgound running thread found.");
			}
		}

	public:
		Visualizer(
		    const BillInfo& billinfo,
		    const float ratio,
		    const float fps,
		    const cv::Mat& mat_hom_inv,
		    const cv::Mat& mat_hom_prj,
		    const unsigned char timeout = 2)
		    : billinfo(billinfo),
		      ratio(ratio),
		      frameinfo({billinfo.board_y * ratio,
		                 billinfo.board_x * ratio,
		                 billinfo.ball_diameter * ratio,
		                 billinfo.cushion_len * ratio}),
		      dp_w(1280),
		      dp_h(720),
		      mat_hom_inv(mat_hom_inv),
		      mat_hom_prj(mat_hom_prj),
		      timeout(timeout),
		      fps(fps) {
			LOG("[ INFO ] Initializing visualizer");
			this->f_running = false;

			std::vector<cv::Point> srcp(4), dstp(4);
			srcp[0] = (cv::Point(0, 0));
			srcp[1] = (cv::Point(billinfo.board_x, 0));
			srcp[2] = (cv::Point(0, billinfo.board_y));
			srcp[3] = (cv::Point(billinfo.board_x, billinfo.board_y));

			for (int i = 0; i < 4; ++i) {
				dstp[i] = srcp[i] * this->ratio;
			}

			LOG("[ INFO ] Calculating perspective matrix.");
			this->mat_hom_prj = cv::findHomography(srcp, dstp);
			LOG("[ INFO ] Calculed perspective matrix.");
		}

		// BLOCKING FUNCTION
		void showTrajectories(const Message& msg) {
			LOG();
			this->handleBackgroundThread();
			this->vistrj(msg);
		}

		// NONBLOCKING FUNCTION
		void showPositions(const Message& msg) {
			LOG();
			this->handleBackgroundThread();
			{
				std::lock_guard<std::mutex> lg(this->mut_thread);
				this->t_running = std::thread(&Visualizer::vispos, this, std::ref(msg));
				this->th_running = t_running.native_handle();
				t_running.detach();
			}
		}

		// NONBLOCKING FUNCTION
		void showBlankScreen() {
			LOG();
			this->handleBackgroundThread();
			{
				std::lock_guard<std::mutex> lg(this->mut_thread);
				this->t_running = std::thread(&Visualizer::visblk, this);
				this->th_running = t_running.native_handle();
				t_running.detach();
			}
		}

		void setHomMat(const cv::Mat& mat) {
			this->mat_hom_inv = mat.clone();
		}
	};
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Visualizer

// Analyzer
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
namespace bill {
	class Analyzer {
	private:
		const BillInfo billinfo;
		const cv::Scalar hsv_lb;
		const cv::Scalar hsv_ub;
		cv::VideoCapture& cam;
		const uint32_t n_buffers;
		uint64_t n_frames;
		cv::Mat frame;
		cv::Mat frame_hsv;
		cv::Mat frame_mask;
		cv::Mat frame_transformed;
		cv::Mat frame_mask_trsfmd;
		cv::Mat frame_trsfmd_canny;
		bool f_hom_valid;
		cv::Mat mat_hom;
		cv::Mat mat_hom_inv;
		const float ratio;
		const BillInfo frame_info;
		bool f_pca_valid;
		bool f_moving;
		std::array<cv::Point, 3> poss;             // WHITE, YELLOW, RED order
		std::array<std::deque<cv::Point>, 3> trjs; // WHITE, YELLOW, RED order

		enum Color {
			WHITE,
			YELLOW,
			RED,
			UNDEF
		};

		struct SortPointY {
			bool operator()(const cv::Point&, const cv::Point&) const;
		};

		struct SortPointX {
			bool operator()(const cv::Point&, const cv::Point&) const;
		};

		inline void retrieve();
		inline int getPositions();
		inline bool cond1(const cv::Vec3b&);
		inline bool cond2(const cv::Vec3b&);
		inline Color colorAt(const cv::Vec3b&);
		inline Color getBallColor(const cv::Mat&, const cv::Vec3f&);

	public:
		Analyzer(
		    const BillInfo&,
		    cv::VideoCapture&,
		    const cv::Vec3b&,
		    const cv::Vec3b&,
		    const uint8_t = 30,
		    const float = 6.0);
		void init(const uint8_t = 120);
		inline void fill(int&, bool&);
		inline void update(int&);
		inline void append(int&);
		inline void areMoving(int&, const float = 1.0);
		inline void atPositions(int&);
		inline void reset();
		bool getHomMat(cv::Mat&);
		inline void show();
		void collect();
	};
}

// DECLARATION
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// INLINE FUNCTION DEFINITIONS

void bill::Analyzer::retrieve() {
	this->cam >> this->frame;
	cv::waitKey(1);
}

int bill::Analyzer::getPositions() {
	using namespace std;
	using namespace cv;

	this->retrieve();

	// GAUSSIAN -> HSV
	cvtColor(this->frame, this->frame_hsv, COLOR_BGR2HSV);
	// HSV -> MASK
	inRange(this->frame_hsv, this->hsv_lb, this->hsv_ub, this->frame_mask);

	// ORIGINAL -> WARPED ORIGINAL
	warpPerspective(
	    this->frame, this->frame_transformed,
	    this->mat_hom, Size(this->frame_info.board_x, this->frame_info.board_y));
	// MASK -> WARPED MASK
	warpPerspective(
	    this->frame_mask, this->frame_mask_trsfmd,
	    this->mat_hom, Size(this->frame_info.board_x, this->frame_info.board_y));

	vector<Vec3f> circles; // (x, y, radius)
	vector<vector<Point>> contours;
	vector<Scalar> colors;
	float ball_diam = this->frame_info.ball_diameter;
	float ball_radi = this->frame_info.ball_diameter / 2;
	double dp = 1;
	double min_dist = ball_diam * 0.8;
	double thrs_high = 50;
	double thrs_low = 20;
	int min_radi = ball_radi * 0.5;
	int max_radi = ball_radi * 1.5;

	// WARPED MASK -> WARPED CANNY
	Canny(this->frame_mask_trsfmd, this->frame_trsfmd_canny, 100, 200);
	// WARPED CANNY -> BLURRED WARPED CANNY
	GaussianBlur(this->frame_trsfmd_canny, this->frame_trsfmd_canny, Size(3, 3), 1);
	// WARPED CANNY: HOUGH CIRCLES
	HoughCircles(this->frame_trsfmd_canny, circles, HOUGH_GRADIENT, dp, min_dist, thrs_high, thrs_low, min_radi, max_radi);

	for (int i = 0; i < circles.size(); ++i) {
		Color color = getBallColor(this->frame_transformed, circles[i]);
		if (color == RED) {
			colors.push_back(Scalar(0, 0, 255));
			this->poss[2].x = circles[i][0];
			this->poss[2].y = circles[i][1];
		}
		else if (color == YELLOW) {
			colors.push_back(Scalar(0, 255, 255));
			this->poss[1].x = circles[i][0];
			this->poss[1].y = circles[i][1];
		}
		else if (color == WHITE) {
			colors.push_back(Scalar(255, 255, 255));
			this->poss[0].x = circles[i][0];
			this->poss[0].y = circles[i][1];
		}
		else {
			colors.push_back(cv::Scalar(255, 0, 0));
		}
	}
	for (int i = 0; i < circles.size(); ++i) {
		circle(this->frame_transformed, Point(circles[i][0], circles[i][1]), circles[i][2], colors[i], 2);
	}

#ifdef DEBUG
	imshow("circle", this->frame_transformed);
	waitKey(1);
#endif

	return circles.size();
}

bool bill::Analyzer::cond1(const cv::Vec3b& bgr) {
	unsigned char b = bgr[0];
	unsigned char g = bgr[1];
	unsigned char r = bgr[2];

	return r >= g * 1.5 && r >= b * 1.5;
}

bool bill::Analyzer::cond2(const cv::Vec3b& bgr) {
	unsigned char b = bgr[0];
	unsigned char g = bgr[1];
	unsigned char r = bgr[2];

	return r >= b * 1.5 && g >= b * 1.5;
}

bill::Analyzer::Color bill::Analyzer::colorAt(const cv::Vec3b& bgr) {
	bool c1 = cond1(bgr);
	bool c2 = cond2(bgr);

	if (c1)
		return RED;
	else if (c2)
		return YELLOW;
	else
		return WHITE;
}

bill::Analyzer::Color bill::Analyzer::getBallColor(const cv::Mat& img, const cv::Vec3f& circle) {
	float delta = circle[2] / 4;
	float d[] = {-delta * 2, -delta, 0, delta, delta * 2};

	int v_red = 0;
	int v_yellow = 0;
	int v_white = 0;
	for (int i = 0; i < 5; ++i) {
		for (int j = 0; j < 5; ++j) {
			cv::Vec3b bgr = img.at<cv::Vec3b>(circle[1] + d[i], circle[0] + d[j]);
			Color color = colorAt(bgr);

			switch (color) {
			case RED:
				++v_red;
				break;
			case YELLOW:
				++v_yellow;
				break;
			case WHITE:
				++v_white;
				break;
			default:
				LOG("[ ERROR ] Logic error.");
				exit(1);
				break;
			}
		}
	}

	if (v_yellow >= v_red && v_yellow >= v_white) return YELLOW;
	else if (v_white >= v_yellow && v_white >= v_red) return WHITE;
	else return RED;
}

void bill::Analyzer::fill(int& n_balls, bool& success) {
	n_balls = this->getPositions();

	if (this->n_frames == 0 && n_balls != 3) {
		this->f_pca_valid = success = false;
		return;
	}

	for (int c = 0; c < 3; ++c) {
		this->trjs[c][n_frames].y = this->poss[c].y;
		this->trjs[c][n_frames].x = this->poss[c].x;
	}

	if (++n_frames == n_buffers) this->f_pca_valid = success = true;
	else this->f_pca_valid = success = false;

	return;
}

void bill::Analyzer::update(int& n_balls) {
	n_balls = this->getPositions();

	for (int c = 0; c < 3; ++c) {
		this->trjs[c].pop_front();
		this->trjs[c].push_back(this->poss[c]);
	}

	return;
}

void bill::Analyzer::append(int& n_balls) {
	n_balls = this->getPositions();

	for (int c = 0; c < 3; ++c) {
		this->trjs[c].push_back(this->poss[c]);
	}

	++this->n_frames;

	return;
}

void bill::Analyzer::areMoving(int& n_balls, const float det) {
	if (this->f_pca_valid) {
		double det_sq = det * det * this->ratio * this->ratio;
		n_balls = 0;

		// Do PCA for each ball
		for (int c = 0; c < 3; ++c) {
			cv::Mat prev_points(this->n_buffers, 2, CV_64F);

			//
			for (int i = 0, f = this->n_frames - this->n_buffers; f < this->n_frames; ++i, ++f) {
				prev_points.at<double>(i, 0) = this->trjs[c][f].x;
				prev_points.at<double>(i, 1) = this->trjs[c][f].y;
			}

			cv::PCA pca(prev_points, cv::Mat(), cv::PCA::DATA_AS_ROW);

			cv::Point center(
			    static_cast<int>(pca.mean.at<double>(0, 0)),
			    static_cast<int>(pca.mean.at<double>(0, 1)));

			std::vector<cv::Point2d> eigenvecs(2);
			std::vector<double> eigenvals(2);
			for (int e = 0; e < 2; ++e) {
				eigenvecs[e] = cv::Point(
				    pca.eigenvectors.at<double>(e, 0),
				    pca.eigenvectors.at<double>(e, 1));
				eigenvals[e] = pca.eigenvalues.at<double>(e);
			}

			if (eigenvals[0] > det_sq) ++n_balls;
		}
	}
	else {
		n_balls = -1;
	}

	return;
}

void bill::Analyzer::atPositions(int& n_balls) {

	return;
}

void bill::Analyzer::reset() {
	this->n_frames = 0;
	this->f_pca_valid = false;
	this->f_moving = false;

	this->poss = std::array<cv::Point, 3>();
	this->trjs = std::array<std::deque<cv::Point>, 3>(
	    {std::deque<cv::Point>(this->n_buffers, cv::Point()),
	     std::deque<cv::Point>(this->n_buffers, cv::Point()),
	     std::deque<cv::Point>(this->n_buffers, cv::Point())});
	return;
}

void bill::Analyzer::show() {
#ifdef DEBUG
	// cv::imshow("Original", this->frame);
	// cv::imshow("Transformed", this->frame_transformed);
	// cv::imshow("Mask Transformed", this->frame_mask_trsfmd);
#endif
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Analyzer

// BillAssist
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
namespace bill {
	class BillAssist {
	private:
		Analyzer analyzer;
		Timer timer;
		Visualizer& visualizer;
		const Mode mode;
		cv::Mat mat_hom;
		const uint32_t undet_lim;
		uint32_t undet_cnt;
		std::atomic<bool> f_shot;
		std::atomic<bool> f_fail;
		std::unordered_set<pthread_t> t_handles;

		enum State {
			UNANALYZABLE,
			ANALYZABLE,
			READY,
			RECORDING,
			SEND,
			TERM
		};

		inline State accumulateData();   // Analyzer::fill()
		inline State areBallsReady();    // Analyzer::update()
		inline State detectUserShot();   // Analyzer::update()
		inline State recordTrajectory(); // Analyzer::append()
		void requestToSendMessage();
		void assist(const Message&, std::mutex&, std::condition_variable&,
		            Message&, std::mutex&, std::condition_variable&);

	public:
		BillAssist(
		    const Mode, const BillInfo&, cv::VideoCapture&,
		    Visualizer&,
		    const cv::Vec3b&, const cv::Vec3b&,
		    const uint8_t,
		    const uint32_t = 120);
		void detect(
		    Message&, std::mutex&, std::condition_variable&,
		    Message&, std::mutex&, std::condition_variable&);
	};
}

// DECLARATION
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// INLINE FUNCTION DEFINITIONS

bill::BillAssist::State bill::BillAssist::accumulateData() {
	int n_balls;
	bool accu_success;
	this->analyzer.fill(n_balls, accu_success);
	this->undet_cnt += 3 - n_balls;

	if (this->undet_cnt < this->undet_lim) {
		if (accu_success) {
			LOG("[ INFO ] Entering analyzable state.");
			return State::ANALYZABLE;
		}
		else return State::UNANALYZABLE;
	}
	else {
		LOG("[ INFO ] Failed to accumulate data. Waiting for 1 seconds and restart.");
		this->undet_cnt = 0;
		this->analyzer.reset();
		std::this_thread::sleep_for(std::chrono::seconds(1));
		return State::UNANALYZABLE;
	}
}

bill::BillAssist::State bill::BillAssist::areBallsReady() {
	int n_balls;
	this->analyzer.update(n_balls);
	this->undet_cnt += 3 - n_balls;

	if (this->undet_cnt < this->undet_lim) {
		int n_mov_balls;
		this->analyzer.areMoving(n_mov_balls);

		if (n_mov_balls == 0) {
			if (this->mode == Mode::FREE) {
				LOG("[ INFO ] All balls stopped. Now waiting for user shot.");
				return State::READY;
			}
			else if (this->mode == Mode::PRAC) {
				int n_pos_balls;
				this->analyzer.atPositions(n_pos_balls);

				if (n_pos_balls == 3) {
					LOG("[ INFO ] All balls stopped and at the right positions. Now waiting for user shot.");
					return State::READY;
				}
				else {
					return State::ANALYZABLE;
				}
			}
		}
		else return State::ANALYZABLE;
	}
	else {
		LOG("[ INFO ] Failed to detect balls. Waiting for 1 seconds and restart.");
		this->undet_cnt = 0;
		this->analyzer.reset();
		std::this_thread::sleep_for(std::chrono::seconds(1));
		return State::UNANALYZABLE;
	}
}

bill::BillAssist::State bill::BillAssist::detectUserShot() {
	int n_balls;
	this->analyzer.update(n_balls);
	// this->undet_cnt += 3 - n_balls;

	int n_mov_balls;
	this->analyzer.areMoving(n_mov_balls);

	if (n_mov_balls == 0) {
		return State::READY;
	}
	else if (n_mov_balls == 1) {
		LOG("[ INFO ] Shot detected. Start recording trajectories.");
		this->f_shot = true;
		return State::RECORDING;
	}
	else {
		LOG("[ INFO ] More than one ball is moving. Fall back to analyzable state.");
		return State::ANALYZABLE;
	}
}

// STRICT TIMEOUT FEATURE REQUIRED.
// BECAUSE THERE IS NO WAY TO TERMINATE THIS THREAD
// WHEN THIS METHOD IS CONSTANTLY BEING CALLED
bill::BillAssist::State bill::BillAssist::recordTrajectory() {
	int n_balls;
	this->analyzer.append(n_balls);
	this->undet_cnt += 3 - n_balls;

	if (this->undet_cnt < this->undet_lim) {
		int n_mov_balls;
		this->analyzer.areMoving(n_mov_balls);

		if (n_mov_balls == 0) {
			LOG("[ INFO ] Turn ended. Start creating data.");
			return State::SEND;
		}
		else return State::RECORDING;
	}
	else {
		LOG("[ WARN ] Detection failed. Terminating billiard assistant. Trajectory data not created.");
		return State::TERM;
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// BillAssist

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// END OF DECLARATIONS AND INLINE FUNCTION DEFINITIONS