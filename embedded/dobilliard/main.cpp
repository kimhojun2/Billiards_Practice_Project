
#include <atomic>
#include <chrono>
#include <fstream>
#include <iostream>
#include <jsoncpp/json/json.h>
#include <opencv2/opencv.hpp>
#include <signal.h>
#include <string>
#include <thread>

#include "connection.hpp"
#include "devices.hpp"
#include "dobilliard.hpp"

inline std::string getunixtime() {
	using namespace std;
	using namespace std::chrono;
	const time_point<system_clock> current_time = system_clock::now();
	return to_string(duration_cast<seconds>(current_time.time_since_epoch()).count());
}

inline bool readFile(const std::string& filename, std::string& file) {
	using namespace std;

	ifstream fstrm(filename, ifstream::in);
	if (!fstrm.is_open()) return false;

	fstrm.seekg(0, ios::end);
	int fsize = fstrm.tellg();
	fstrm.seekg(0, ios::beg);

	file.resize(fsize);
	fstrm.read(&file[0], fsize);

	fstrm.close();

	return true;
}

void runFreeMode(cv::VideoCapture& vc,
                 bill::Visualizer& visualizer,
                 bill::Message& msg_recv,
                 std::mutex& mut_msg_recv,
                 std::condition_variable& cv_chld_itrp,
                 bill::Message& msg_send,
                 std::mutex& mut_msg_send,
                 std::condition_variable& cv_sock_send,
                 const Json::Value& cfg) {
	LOG("[ INFO ] Starting free mode.");

	LOG("[ INFO ] Parsing configurations.");
	bill::BillInfo billiard_info;
	std::string device_info;
	cv::Vec3b hsv_lb;
	cv::Vec3b hsv_ub;
	billiard_info = {
	    cfg["billiard_info"]["board_y"].asFloat(),
	    cfg["billiard_info"]["board_x"].asFloat(),
	    cfg["billiard_info"]["ball_diameter"].asFloat(),
	    cfg["billiard_info"]["cushion_len"].asFloat()};
	device_info = cfg["device_info"].asString();
	for (int v = 0; v < 3; ++v)
		hsv_lb[v] = cfg["billiard_info"]["hsv_range"][0][v].asUInt();

	for (int v = 0; v < 3; ++v)
		hsv_ub[v] = cfg["billiard_info"]["hsv_range"][1][v].asUInt();

	bill::BillAssist billassist(bill::Mode::FREE, billiard_info, vc, visualizer, hsv_lb, hsv_ub, 1.0);
	billassist.detect(msg_recv, mut_msg_recv, cv_chld_itrp, msg_send, mut_msg_send, cv_sock_send);

	LOG("[ INFO ] End of free mode.");
}

void runPracticeMode(cv::VideoCapture& vc,
                     bill::Visualizer& visualizer,
                     bill::Message& msg_recv,
                     std::mutex& mut_msg_recv,
                     std::condition_variable& cv_chld_itrp,
                     bill::Message& msg_send,
                     std::mutex& mut_msg_send,
                     std::condition_variable& cv_sock_send,
                     const Json::Value& cfg) {
	LOG("[ INFO ] Starting practice mode.");

	LOG("[ INFO ] Parsing configurations.");
	bill::BillInfo billiard_info;
	std::string device_info;
	cv::Vec3b hsv_lb;
	cv::Vec3b hsv_ub;
	billiard_info = {
	    cfg["billiard_info"]["board_y"].asFloat(),
	    cfg["billiard_info"]["board_x"].asFloat(),
	    cfg["billiard_info"]["ball_diameter"].asFloat(),
	    cfg["billiard_info"]["cushion_len"].asFloat()};
	device_info = cfg["device_info"].asString();
	for (int v = 0; v < 3; ++v)
		hsv_lb[v] = cfg["billiard_info"]["hsv_range"][0][v].asUInt();

	for (int v = 0; v < 3; ++v)
		hsv_ub[v] = cfg["billiard_info"]["hsv_range"][1][v].asUInt();

	bill::BillAssist billassist(bill::Mode::PRAC, billiard_info, vc, visualizer, hsv_lb, hsv_ub, 1.0);
	billassist.detect(msg_recv, mut_msg_recv, cv_chld_itrp, msg_send, mut_msg_send, cv_sock_send);

	LOG("[ INFO ] End of practice mode.");
}

void runShowMode(cv::VideoCapture& vc,
                 bill::Visualizer& visualizer,
                 bill::Message& msg_recv,
                 std::mutex& mut_msg_recv,
                 std::condition_variable& cv_chld_itrp,
                 bill::Message& msg_send,
                 std::mutex& mut_msg_send,
                 std::condition_variable& cv_sock_send,
                 const Json::Value& cfg) {
	LOG("[ INFO ] Starting show mode.");

	LOG("[ INFO ] Parsing configurations.");
	bill::BillInfo billiard_info;
	std::string device_info;
	cv::Vec3b hsv_lb;
	cv::Vec3b hsv_ub;
	billiard_info = {
	    cfg["billiard_info"]["board_y"].asFloat(),
	    cfg["billiard_info"]["board_x"].asFloat(),
	    cfg["billiard_info"]["ball_diameter"].asFloat(),
	    cfg["billiard_info"]["cushion_len"].asFloat()};
	device_info = cfg["device_info"].asString();
	for (int v = 0; v < 3; ++v)
		hsv_lb[v] = cfg["billiard_info"]["hsv_range"][0][v].asUInt();

	for (int v = 0; v < 3; ++v)
		hsv_ub[v] = cfg["billiard_info"]["hsv_range"][1][v].asUInt();

	bill::BillAssist billassist(bill::Mode::SHOW, billiard_info, vc, visualizer, hsv_lb, hsv_ub, 1.0);
	billassist.detect(msg_recv, mut_msg_recv, cv_chld_itrp, msg_send, mut_msg_send, cv_sock_send);

	LOG("[ INFO ] End of show mode.");
}

int runDoBilliard(const Json::Value& cfg) {
	LOG("[ INFO ] Starting DoBilliard.");

	// CAMERA SETTING
	cv::VideoCapture vc;
	LOG("[ INFO ] Parsing camera settings.");
	const int frame_width = cfg["camera_settings"]["frame_width"].asInt();
	const int frame_height = cfg["camera_settings"]["frame_height"].asInt();
	const double fps = cfg["camera_settings"]["fps"].asDouble();
	const int camera_id = cfg["camera_settings"]["id"].asInt();
	if (!dev::initCamera(vc, frame_width, frame_height, fps, camera_id)) {
		LOG("[ ERROR ] Camera setting failed. Terminating program.");
		return 1;
	}
	LOG("[ INFO ] Camera connected!");

	// PROJECTOR SETTING
	bill::BillInfo billinfo = {
	    cfg["billiard_info"]["board_y"].asFloat(),
	    cfg["billiard_info"]["board_x"].asFloat(),
	    cfg["billiard_info"]["ball_diameter"].asFloat(),
	    cfg["billiard_info"]["cushion_len"].asFloat()};
	bill::Visualizer visualizer(billinfo, 4, 30, cv::Mat(), cv::Mat());
	visualizer.showBlankScreen();

	// SOCKET SETTING
	bill::Message msg_recv;
	bill::Message msg_send;
	std::mutex mut_msg_recv;
	std::mutex mut_msg_send;
	std::condition_variable cv_this_itrp;
	std::condition_variable cv_sock_send;
	char server_ip[32];
	char server_port[8];
	LOG("[ INFO ] Parsing socket connection settings.");
	strcpy(server_ip, cfg["server_info"]["ip"].asString().c_str());
	strcpy(server_port, cfg["server_info"]["port"].asString().c_str());
	int retry_interval = cfg["server_info"]["interval"].asInt();
	conn::Sock sock(server_ip, server_port, msg_recv, msg_send, mut_msg_recv, mut_msg_send, cv_this_itrp, cv_sock_send);

	// STARTING MAIN ALGORITHM
	bill::Mode mode = bill::Mode::DEFAULT;
	LOG("[ INFO ] Starting mode switcher.");
	while (true) {
		if (mode == bill::Mode::TERM) break;
		if (mode != bill::Mode::FREE && mode != bill::Mode::PRAC) {
			// Error handling? What if message invalid?
			LOG("[ INFO ] Waiting for server message.");
			{
				std::unique_lock<std::mutex> ul_this_itrp(mut_msg_recv);
				cv_this_itrp.wait(ul_this_itrp, [&]() { return msg_recv.valid; });
				msg_recv.valid = false;
			}
		}
		else {
			mut_msg_recv.lock();
			msg_recv.valid = false;
		}

		if (msg_recv.num_of_frames == 0) mode = bill::Mode::FREE;
		else if (msg_recv.num_of_frames == 1) mode = bill::Mode::PRAC;
		else if (msg_recv.num_of_frames >= 2) mode = bill::Mode::SHOW;
		else mode = bill::Mode::DEFAULT;

		switch (mode) {
		case bill::Mode::FREE:
			runFreeMode(vc, visualizer,
			            msg_recv, mut_msg_recv, cv_this_itrp,
			            msg_send, mut_msg_send, cv_sock_send,
			            cfg);
			break;
		case bill::Mode::PRAC:
			runPracticeMode(vc, visualizer,
			                msg_recv, mut_msg_recv, cv_this_itrp,
			                msg_send, mut_msg_send, cv_sock_send,
			                cfg);
			break;
		case bill::Mode::SHOW:
			runShowMode(vc, visualizer,
			            msg_recv, mut_msg_recv, cv_this_itrp,
			            msg_send, mut_msg_send, cv_sock_send,
			            cfg);
			break;
		case bill::Mode::DEFAULT:
			break;
		case bill::Mode::TERM:
			break;
		default:
			break;
		}

		LOG("[ DEBUG ] End of iteration.");
	}

	// THREAD JOIN

	// RELEASE

	// CLOSE

	return 0;
}

#ifdef DEVELOP
int main() {
	cv::VideoCapture cam(0);

	bill::Timer timer(1);

	cam.release();

	return 0;
}
#else
int main(int argc, char* argv[]) {
	LOG("[ DEBUG ] Program started.");

	std::string cfgname;
	if (argc == 1) {
		LOG("[ INFO ] Configuration file has not defined. Defaults to `.config`.");
		cfgname = ".config";
	}
	if (argc == 2) {
		LOG("[ INFO ] Using " << argv[1] << " as configuration file.");
		cfgname = std::string(argv[1]);
	}

	std::string cfgstr;
	if (!readFile(cfgname, cfgstr)) {
		LOG("[ ERROR ] File opening failed.");
		exit(1);
	}

	Json::Value cfg;
	Json::Reader reader;
	if (!reader.parse(cfgstr, cfg, false)) {
		LOG("[ WARN ] JSON parsing error.");
		return false;
	}

	return runDoBilliard(cfg);
}
#endif