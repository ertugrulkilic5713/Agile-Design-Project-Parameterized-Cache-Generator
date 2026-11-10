#pragma once
#include "../defines.h"

enum class RunState { Stopped, Running, Paused };
struct ControlEvents {
	bool run = false; 
	bool pause = false; 
	bool stop = false; 
	bool step = false; // increments of n instructions forward
	bool fast_forward = false; // TODO
};

class ControlsPanel {
public:
	void render();

	inline RunState get_state() const { return state_; }
	inline void set_state(RunState s) { state_ = s; } // trigger when sim finishes
	inline float get_speed() const { return speed_; }
	inline void set_speed(float s) { speed_ = s; }

	inline ControlEvents consume_events() { 
		ControlEvents e = events_; 
		events_ = {}; 
		return e; 
	}

private:
	RunState state_ = RunState::Stopped;
	float speed_ = 1.0f; // control speed of simulation/visualizer
	ControlEvents events_;
};
