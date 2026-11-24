#pragma once
#include "../defines.h"
#include <algorithm>
#include <imgui.h>
#include <algorithm>
#include <string>
#include <cstdio>


/*
Everything here to make imgui look better somewhat
*/

inline void SectionHeader(const char* label) {
	ImGui::TextColored(ImVec4(0.55f, 0.75f, 1.0f, 1.0f), "%s", label);
	ImGui::Separator();
}

// Label on the left | widget fills the rest
inline void LabeledRow(const char* label, float label_w = 110.0f) {
	ImGui::AlignTextToFramePadding();
	ImGui::TextUnformatted(label);
	ImGui::SameLine(label_w);
	ImGui::SetNextItemWidth(-FLT_MIN);
}

template <size_t N>
inline bool ComboStr(const char* id, int& idx, const char* const (&items)[N]) {
	bool changed = false;
	if (idx < 0 || idx >= (int)N) idx = 0;
	if (ImGui::BeginCombo(id, items[idx])) {
		for (int i = 0; i < (int)N; ++i) {
			bool sel = (i == idx);
			if (ImGui::Selectable(items[i], sel)) { idx = i; changed = true; }
			if (sel) ImGui::SetItemDefaultFocus();
		}
		ImGui::EndCombo();
	}
	return changed;
}


// Returns true on the frame the button is clicked (only possible when idle).
// While 0.0f < completion < 1.0f the button is disabled and shows "NN%".
// The button becomes clickable again once completion reaches 1.0f.
inline bool ProgressButton(const char* label, float completion, const ImVec2& size = ImVec2(0, 0))
{
    const bool running = completion > 0.0f && completion < 1.0f;

    char text[128];
    if (running)
        snprintf(text, sizeof(text), "%d%%##%s", (int)(completion * 100.0f), label);
    else
        snprintf(text, sizeof(text), "%s", label);

    if (running)
        ImGui::BeginDisabled();

    const bool clicked = ImGui::Button(text, size);

    if (running)
        ImGui::EndDisabled();

    return clicked && !running;
}
