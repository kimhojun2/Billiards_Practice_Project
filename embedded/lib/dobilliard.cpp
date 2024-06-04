#include "dobilliard.hpp"

// DOBILLIARD_CPP
// FUNCTION DEFINITIONS OF DOBILIIARD_HPP
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// BillInfo
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bill::BillInfo::BillInfo() : board_y(0.0f),
                             board_x(0.0f),
                             ball_diameter(0.0f),
                             cushion_len(0.0f) {}

bill::BillInfo::BillInfo(
    const float board_y,
    const float board_x,
    const float ball_diameter,
    const float cushion_len)
    : board_y(board_y),
      board_x(board_x),
      ball_diameter(ball_diameter),
      cushion_len(cushion_len) {}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// BillInfo

// Position
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bill::Position::Position() : y(0.0), x(0.0) {}

bill::Position::Position(float y, float x) : y(y), x(x) {}

bill::Position::Position(const bill::Position& p) : y(p.y), x(p.x) {}

bill::Position& bill::Position::operator+=(const bill::Position& p) {
	this->y += p.y;
	this->x += p.x;

	return *this;
}

bill::Position& bill::Position::operator-=(const bill::Position& p) {
	this->y -= p.y;
	this->x -= p.x;

	return *this;
}

bill::Position& bill::Position::operator/=(const bill::Position& p) {
	this->y /= p.y;
	this->x /= p.x;

	return *this;
}

bill::Position bill::operator+(const bill::Position& posl, const bill::Position& posr) {
	bill::Position sum(posl.y + posr.y, posl.x + posr.x);
	return sum;
}

bill::Position bill::operator-(const bill::Position& posl, const bill::Position& posr) {
	bill::Position diff(posl.y - posr.y, posl.x - posr.x);
	return diff;
}

bill::Position bill::operator/(const bill::Position& posl, const bill::Position& posr) {
	bill::Position div(posl.y / posr.y, posl.x / posr.x);
	return div;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Position

// Message
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bill::Message::Message() : valid(false) {}

bill::Message& bill::Message::operator<<(Json::Value& json) {
	Json::Value pos = json["positions"];
	int len = pos["num_of_frames"].isInt();
	for (int i = 0; i < len; ++i) {
		this->trj_w.emplace_back(pos["white"][i][1].asFloat(), pos["white"][i][0].asFloat());
		this->trj_y.emplace_back(pos["yellow"][i][1].asFloat(), pos["yellow"][i][0].asFloat());
		this->trj_r.emplace_back(pos["red"][i][1].asFloat(), pos["red"][i][0].asFloat());
	}

	this->bill_info = {json["billiard_info"]["board_y"].asFloat(),
	                   json["billiard_info"]["board_x"].asFloat(),
	                   json["billiard_info"]["ball_diameter"].asFloat(),
	                   json["billiard_info"]["cushion_len"].asFloat()};

	this->device_info = json["device_info"].asUInt64();
	this->unix_time = json["unix_time"].asString();
	this->num_of_frames = json["num_of_frames"].asInt();
	this->sampling_rate = json["sampling_rate"].asFloat();

	return *this;
}

bill::Message bill::operator>>(const bill::Message& msg, Json::Value& json) {
	Json::Value trj_w_val;
	Json::Value trj_y_val;
	Json::Value trj_r_val;

	int n_frames = msg.trj_w.size();
	for (int i = 0; i < n_frames; ++i) {
		Json::Value pos_w_val;
		Json::Value pos_y_val;
		Json::Value pos_r_val;

		pos_w_val.append(msg.trj_w[i].x);
		pos_w_val.append(msg.trj_w[i].y);

		pos_y_val.append(msg.trj_y[i].x);
		pos_y_val.append(msg.trj_y[i].y);

		pos_r_val.append(msg.trj_r[i].x);
		pos_r_val.append(msg.trj_r[i].y);

		trj_w_val.append(pos_w_val);
		trj_y_val.append(pos_y_val);
		trj_r_val.append(pos_r_val);
	}

	Json::Value trj_val;
	trj_val["white"] = trj_w_val;
	trj_val["yellow"] = trj_y_val;
	trj_val["red"] = trj_r_val;

	Json::Value bi_val;
	bi_val["board_y"] = msg.bill_info.board_y;
	bi_val["board_x"] = msg.bill_info.board_x;
	bi_val["ball_diameter"] = msg.bill_info.ball_diameter;
	bi_val["cushion_len"] = msg.bill_info.cushion_len;

	json["device_info"] = msg.device_info;
	json["unix_time"] = msg.unix_time;
	json["num_of_frames"] = msg.num_of_frames;
	json["sampling_rate"] = msg.sampling_rate;
	json["billiard_info"] = bi_val;
	json["positions"] = trj_val;

	return msg;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Position

// Timer
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void bill::Timer::calculate() {
	using namespace std::this_thread;
	using namespace std::chrono;

	while (this->cont) {
		this->iteration = 0;

		sleep_for(seconds(this->interval));

		uint8_t l_iteration = this->iteration;
		float l_fps = (float)l_iteration / this->interval;
		this->fps = l_fps;

		if (this->f_print) {
			std::cout << l_fps << " frames/second" << std::endl;
			LOG(l_fps << " frames/second");
		}
	}
}

bill::Timer::Timer(
    const uint8_t interval,
    bool print_every)
    : total_iteration(0),
      interval(interval),
      t_calc(),
      f_print(print_every) {
	this->cont = false;
	this->iteration = 0;
	this->fps = 0.0;
	this->total_iteration = 0;
}

bill::Timer::~Timer() {
	this->cont = false;
	this->t_calc.join();
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Timer

// Analyzer
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bool bill::Analyzer::SortPointY::operator()(const cv::Point& p1, const cv::Point& p2) const {
	return p1.y < p2.y;
}

bool bill::Analyzer::SortPointX::operator()(const cv::Point& p1, const cv::Point& p2) const {
	return p1.x < p2.x;
}

bill::Analyzer::Analyzer(
    const bill::BillInfo& billinfo,
    cv::VideoCapture& cam,
    const cv::Vec3b& hsv_lb,
    const cv::Vec3b& hsv_ub,
    const uint8_t n_buffers,
    const float ratio)
    : billinfo(billinfo),
      cam(cam),
      hsv_lb(hsv_lb),
      hsv_ub(hsv_ub),
      n_buffers(n_buffers),
      f_hom_valid(false),
      f_pca_valid(false),
      f_moving(false),
      ratio(ratio),
      frame_info(
          ratio * billinfo.board_y,
          ratio * billinfo.board_x,
          ratio * billinfo.ball_diameter,
          ratio * billinfo.cushion_len) {
	LOG("[ INFO ] Initializing analyzer.");
	this->init();
}

void bill::Analyzer::init(const uint8_t n_init_frames) {
	using namespace std;
	using namespace cv;

	LOG("[ INFO ] Starting finding pool table.");

	this->reset();
	this->f_hom_valid = false;

	vector<Point> dst_points;
	dst_points.push_back(Point(0, 0));
	dst_points.push_back(Point(this->frame_info.board_x, 0));
	dst_points.push_back(Point(0, this->frame_info.board_y));
	dst_points.push_back(Point(this->frame_info.board_x, this->frame_info.board_y));

	LOG("[ INFO ] Waiting for camera to get ready.");
	for (int i = 0; i < 30; ++i) {
		this->retrieve();
	}

	LOG("[ INFO ] Camera ready. Detecting pool table.");
	int cnt = 0;
	vector<Point> avgpoints(4, {0, 0});
	while (cnt < n_init_frames) {
		this->retrieve();
		GaussianBlur(this->frame, this->frame, Size(3, 3), 0.0);
		cvtColor(this->frame, this->frame_hsv, COLOR_BGR2HSV);
		inRange(this->frame_hsv, this->hsv_lb, this->hsv_ub, this->frame_mask);

		double max_area = 0;
		int max_area_idx = 0;
		vector<vector<Point>> contours;
		findContours(this->frame_mask, contours, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE);
		for (int i = 0; i < contours.size(); ++i) {
			double area = contourArea(contours[i]);

			if (max_area < area) {
				max_area = area;
				max_area_idx = i;
			}
		}

		if (contours.size() < 1) {
			LOG("[ WARN ] Failed to detect any object. Retrying in 1 seconds.");
			waitKey(1000);
			continue;
		}

		SortPointY sort_y;
		SortPointX sort_x;
		vector<Point> table_points;

		double arclen = arcLength(contours[max_area_idx], true);
		approxPolyDP(contours[max_area_idx], table_points, 0.1 * arclen, true);

		if (table_points.size() != 4) {
			LOG("[ WARN ] Failed to detect pool table. Retrying in 1 seconds.");
			waitKey(1000);
			continue;
		}

		/* Point Order:
		   1        2
		   3        4
		*/
		sort(table_points.begin(), table_points.end(), sort_y);
		sort(table_points.begin(), table_points.begin() + 2, sort_x);
		sort(table_points.begin() + 2, table_points.end(), sort_x);

#ifdef DEBUG
		Mat temp_mat_hom = findHomography(table_points, dst_points);
		Mat tmp;
		warpPerspective(this->frame, tmp, temp_mat_hom, Size(this->frame_info.board_x, this->frame_info.board_y));
		imshow("tmp", tmp);
		waitKey(1);
#endif

		for (int i = 0; i < 4; ++i)
			avgpoints[i] += table_points[i];

		cout << (++cnt % 10) << "\r" << flush;
	}

	for (int i = 0; i < 4; ++i)
		avgpoints[i] /= cnt;

	this->mat_hom = findHomography(avgpoints, dst_points);
	this->mat_hom_inv = findHomography(dst_points, avgpoints);

#ifdef DEBUG
	destroyWindow("tmp");
#endif

	LOG("[ DEBUG ] Homography matrix: " << this->mat_hom);

	this->f_hom_valid = true;

	LOG("[ INFO ] Homography transformation matrix successfully calculated.");
	return;
}

bool bill::Analyzer::getHomMat(cv::Mat& mat_hom) {
	mat_hom = this->mat_hom_inv.clone();
	return this->f_hom_valid;
}

void bill::Analyzer::collect() {
	cv::destroyAllWindows();
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Analyzer

// BillAssist
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void bill::BillAssist::requestToSendMessage() {
}

void bill::BillAssist::assist(
    const bill::Message& msg_recv,
    std::mutex& mut_msg_recv,
    std::condition_variable& cv_prnt_itrp,
    bill::Message& msg_send,
    std::mutex& mut_msg_send,
    std::condition_variable& cv_sock_send) {
	LOG("[ DEBUG ] Core assistant started.");

	if (this->mode == Mode::SHOW) {
		this->visualizer.showTrajectories(msg_recv);
		LOG("[ DEBUG ] Visualizing done. Waiting for 1 seconds.");
		std::this_thread::sleep_for(std::chrono::seconds(1));
		{
			mut_msg_recv.lock();
			this->f_shot = true;
			mut_msg_recv.unlock();
		}
		cv_prnt_itrp.notify_all();
		return;
	}

	bill::BillAssist::State state = bill::BillAssist::State::UNANALYZABLE;
	LOG("[ INFO ] Currently in unanalyzable state.");
	this->timer.start();

	this->undet_cnt = 0;

	if (this->mode == Mode::PRAC) {
		this->visualizer.showPositions(msg_recv);
	}

	while (state == State::UNANALYZABLE || state == State::ANALYZABLE || state == State::READY) {
		timer.count();
		// NO SUFFICIENT DATA
		if (state == State::UNANALYZABLE) {
			state = this->accumulateData();
		}
		// SUFFICIENT DATA, BUT BALLS ARE MOVING AROUND
		// WAIT UNTIL BALLS STOP
		else if (state == State::ANALYZABLE) {
			state = this->areBallsReady();
		}
		// SUFFICIENT DATA, BALLS ARE STATIONARY
		// WAIT FOR USER SHOT
		else if (state == State::READY) {
			state = this->detectUserShot();
		}
	}

	if (this->mode == Mode::PRAC) {
		this->visualizer.showBlankScreen();
	}

	// NOTIFY PARENT THREAD
	cv_prnt_itrp.notify_all();

	while (state == State::RECORDING) {
		// AFTER USER SHOT. RECORDING BALL TRAJECTORIES
		// PARENT THREAD CANNOT KILL THIS THREAD FROM HERE
		state = this->recordTrajectory();
	}

#ifdef DEBUG
	cv::destroyWindow("circle");
#endif

	// SEND REQUEST TO SOCKET FUNCTION
	if (state == State::SEND) {
		this->requestToSendMessage();
	}

	// TERMINATE CURRENT THREAD
	LOG("[ INFO ] Terminating core assistant.");

	return;
}

bill::BillAssist::BillAssist(
    const Mode mode,
    const BillInfo& billinfo,
    cv::VideoCapture& cam,
    Visualizer& visualizer,
    const cv::Vec3b& hsv_lb,
    const cv::Vec3b& hsv_ub,
    const uint8_t n_buffers,
    const uint32_t undet_lim)
    : undet_lim(undet_lim),
      undet_cnt(0),
      mode(mode),
      visualizer(visualizer),
      analyzer(billinfo, cam, hsv_lb, hsv_ub, n_buffers),
      timer(1) {
	LOG("[ INFO ] Starting assistant.");

	this->f_shot = false;
	this->f_fail = false;

	switch (this->mode) {
	case Mode::FREE:
		LOG("[ INFO ] Free mode started.");
		break;
	case Mode::PRAC:
		LOG("[ INFO ] Practice mode started.");
		break;
	case Mode::SHOW:
		LOG("[ INFO ] Show mode started.");
		break;
	default:
		LOG("[ ERROR ] Logic error.");
		exit(1);
		break;
	}

	while (!this->analyzer.getHomMat(this->mat_hom)) {
		LOG("[ INFO ] Failed to calculate homography transformation matrix. Trying again in 1 seconds.");
		std::this_thread::sleep_for(std::chrono::seconds(1));
		this->analyzer.init();
	}

	this->visualizer.setHomMat(this->mat_hom);

	LOG("[ INFO ] Obtained homography transformation matrix.");
}

void bill::BillAssist::detect(
    Message& msg_recv, std::mutex& mut_msg_recv, std::condition_variable& cv_this_itrp,
    Message& msg_send, std::mutex& mut_msg_send, std::condition_variable& cv_sock_send) {
	LOG("[ INFO ] Starting billiard assistant.");

	this->f_shot = false;
	this->f_fail = false;

	LOG("[ INFO ] Calling core assistant on new thread.");
	std::thread t_assist(
	    &BillAssist::assist, this,
	    std::ref(msg_recv), std::ref(mut_msg_recv), std::ref(cv_this_itrp),
	    std::ref(msg_send), std::ref(mut_msg_send), std::ref(cv_sock_send));
	pthread_t th_assist = t_assist.native_handle();

	{
		LOG("[ INFO ] Detector waiting for an alarm from socket receiver or core assistant. Start sleeping.");
		std::unique_lock<std::mutex> ul(mut_msg_recv);
		cv_this_itrp.wait(ul, [&]() { return msg_recv.valid || this->f_shot || this->f_fail; });
		LOG("[ DEBUG ] Detector woke up.");
		msg_recv.valid = false;
	}

	if (this->f_shot) {
		LOG("[ INFO ] Waiting for the core assistant to terminate.");
	}
	else {
		if (msg_recv.valid)
			LOG("[ DEBUG ] Server message received.");
		if (this->f_fail)
			LOG("[ DEBUG ] Core assistant could not detect and analyze.");

		LOG("[ INFO ] Forcibly terminating core assistant thread.");

#ifdef DEBUG
		if (this->mode == Mode::FREE || this->mode == Mode::PRAC)
			cv::destroyWindow("circle");
#endif
		pthread_cancel(th_assist);
	}
	if (t_assist.joinable())
		t_assist.join(); // Only the last message is valid
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// BillAssist