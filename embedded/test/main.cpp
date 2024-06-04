

enum Mode {
	FREE_MODE,
	EXER_MODE,
	SHOW_MODE
};

struct BillInfo {
	float board_y;
	float board_x;
	float ball_diameter;
};

struct Position {
	float y;
	float x;
};

struct Trajectory {
	float num_of_frames;
	float sampling_rate;
	BillInfo billiard_info;
	Position* white;
	Position* yellow;
	Position* red;

	Trajectory(float num_of_frames, float sampling_rate, BillInfo billiard_info) :
		num_of_frames(num_of_frames),
		sampling_rate(sampling_rate),
		billiard_info(billiard_info),
		white(new Position[num_of_frames]),
		yellow(new Position[num_of_frames]),
		red(new Position[num_of_frames])
	{

	}
};

namespace prj {
	void initProjector() {

	}
}

namespace cam {
	void initCamera() {

	}
}

namespace det {

}

namespace con {
	void initSocketConnection() {

	}
}

void runProgramDependingOnMode() {}


void runProgram() {
	cam::initCamera();
	prj::initProjector();

	/////////////////////////////////////////////////////////
	// get ready for detecting user gesture
	// this function returns only after detecting user gesture,
	// meaning does not return if user gesture is not detected.
	/////////////////////////////////////////////////////////

	/////////////////////////////////////////////////////////
	// initialize connection with the server via socket.
	/////////////////////////////////////////////////////////

	/////////////////////////////////////////////////////////
	// get ready for any message from the server.
	// there are two options for implementing it.
	//   option #1. using threads.
	//   option #2. returns only after receiving any message
	//   from the server.
	/////////////////////////////////////////////////////////

	/////////////////////////////////////////////////////////
	// parse the json message from the server
	/////////////////////////////////////////////////////////

	/////////////////////////////////////////////////////////
	// runProgramDependingOnMode();
	/////////////////////////////////////////////////////////
}

int main() {
	runProgram();
}