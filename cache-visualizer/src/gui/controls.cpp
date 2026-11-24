#include "controls.h"
#include "widgets.h"

void ControlsPanel::render() {
	SectionHeader("Controls");

	const bool playing = (state_ == RunState::Running);
	const bool stopped = (state_ == RunState::Stopped);

	ImGui::PushStyleColor(ImGuiCol_Button,        ImVec4(0.15f, 0.40f, 0.85f, 1));
	ImGui::PushStyleColor(ImGuiCol_ButtonHovered, ImVec4(0.20f, 0.50f, 0.95f, 1));
	ImGui::BeginDisabled(playing);
	if (ImGui::Button("Play", ImVec2(70, 0))) { state_ = RunState::Running; events_.run = true; }
	ImGui::EndDisabled();
	ImGui::PopStyleColor(2);

	ImGui::SameLine();
	ImGui::BeginDisabled(!playing);
	if (ImGui::Button("Pause", ImVec2(55, 0))) { state_ = RunState::Paused; events_.pause = true; }
	ImGui::EndDisabled();

	ImGui::SameLine();
	ImGui::BeginDisabled(stopped);
	if (ImGui::Button("Stop", ImVec2(50, 0))) { state_ = RunState::Stopped; events_.stop = true; }
	ImGui::EndDisabled();

	ImGui::SameLine();
	ImGui::BeginDisabled(playing);
	if (ImGui::Button("Step", ImVec2(50, 0))) events_.step = true;
	ImGui::EndDisabled();

	ImGui::SameLine();
	if (ImGui::Button(">>", ImVec2(-FLT_MIN, 0))) events_.fast_forward = true;

	LabeledRow("Speed", 60);
	ImGui::SliderFloat("##speed", &speed_, 0.1f, 10.0f, "%.1fx");
}
