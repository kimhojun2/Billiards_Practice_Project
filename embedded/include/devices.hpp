#pragma once

#include <iostream>

#include <opencv2/videoio.hpp>

#include "dobilliard.hpp"

namespace dev {

	bool initCamera(
	    cv::VideoCapture& vc,
	    const int fwidth,
	    const int fheight,
	    const double framerate,
	    const int camera_id = 0,
	    const int api_preference = cv::CAP_ANY) {
		LOG("Initializing camera.");
		if (!vc.open(camera_id, api_preference)) {
			LOG("[ERROR] Camera opening failed.");
			return false;
		}

		if (!vc.set(cv::CAP_PROP_FRAME_WIDTH, fwidth)) {
			LOG("[ERROR] Camera width setting failed.");
			return false;
		}

		if (!vc.set(cv::CAP_PROP_FRAME_HEIGHT, fheight)) {
			LOG("[ERROR] Camera height setting failed.");
			return false;
		}

		if (!vc.set(cv::CAP_PROP_FPS, framerate)) {
			LOG("[ERROR] Camera fps setting failed.");
			return false;
		}

		return true;
	}

	void initProjector() {
	}

}