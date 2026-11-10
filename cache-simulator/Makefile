# AI makefile because hard to remember vendorize 
# configuration

TARGET  := cache-visualizer
BUILD   := build
SRC_DIR := src
VENDOR  := vendor

# `CXX ?=` never fires because make predefines CXX/CC, so check the origin.
ifeq ($(origin CXX),default)
    CXX := clang++
endif
ifeq ($(origin CC),default)
    CC := clang
endif

STANDARD := -std=c++20

# ---------------------------------------------------------------- platform
UNAME := $(shell uname -s 2>/dev/null)

ifeq ($(OS),Windows_NT)
    PLATFORM := windows
else ifeq ($(UNAME),Darwin)
    PLATFORM := macos
else ifeq ($(UNAME),Linux)
    PLATFORM := linux
else
    $(error Unsupported platform: $(UNAME))
endif

ifeq ($(PLATFORM),macos)
    PLATFORM_FLAGS := -DGL_SILENCE_DEPRECATION
    GLFW_DEFINES   := -D_GLFW_COCOA
    PLATFORM_LIBS  := -framework Cocoa -framework IOKit -framework CoreVideo -framework OpenGL -framework QuartzCore
else ifeq ($(PLATFORM),linux)
    PLATFORM_FLAGS :=
    GLFW_DEFINES   := -D_GLFW_X11
    PLATFORM_LIBS  := -lGL -lX11 -lpthread -ldl -lm
else ifeq ($(PLATFORM),windows)
    PLATFORM_FLAGS :=
    GLFW_DEFINES   := -D_GLFW_WIN32 -DUNICODE -D_UNICODE
    PLATFORM_LIBS  := -lopengl32 -lgdi32 -luser32 -lshell32
endif

# ---------------------------------------------------------------- includes
INCLUDES := \
    -I$(VENDOR)/imgui \
    -I$(VENDOR)/imgui/backends \
    -I$(VENDOR)/glfw/include

# ---------------------------------------------------------------- sources
APP_CPP := $(shell find $(SRC_DIR) -type f -name '*.cpp')

IMGUI_CPP := \
    $(VENDOR)/imgui/imgui.cpp \
    $(VENDOR)/imgui/imgui_demo.cpp \
    $(VENDOR)/imgui/imgui_draw.cpp \
    $(VENDOR)/imgui/imgui_tables.cpp \
    $(VENDOR)/imgui/imgui_widgets.cpp \
    $(VENDOR)/imgui/backends/imgui_impl_glfw.cpp \
    $(VENDOR)/imgui/backends/imgui_impl_opengl3.cpp

GLFW_DIR := $(VENDOR)/glfw/src

# GLFW 3.4: common files + the "null" platform (platform.c references it
# on every OS) + EGL/OSMesa contexts.
GLFW_COMMON := $(addprefix $(GLFW_DIR)/, \
    context.c init.c input.c monitor.c platform.c vulkan.c window.c \
    egl_context.c osmesa_context.c \
    null_init.c null_monitor.c null_window.c null_joystick.c)

GLFW_OBJC :=

ifeq ($(PLATFORM),macos)
    # Wildcards so this works across GLFW versions (some have cocoa_time.c,
    # newer ones use posix_time.c for the timer instead).
    GLFW_C := $(wildcard $(GLFW_DIR)/cocoa_*.c) \
              $(wildcard $(GLFW_DIR)/posix_module.c) \
              $(wildcard $(GLFW_DIR)/posix_thread.c)
    # The timer lives in different files depending on GLFW version, so find
    # whichever file defines it (ignoring the Windows one).
    GLFW_TIMER_C := $(filter-out %/win32_time.c,$(shell grep -l '^void _glfwPlatformInitTimer' $(GLFW_DIR)/*.c 2>/dev/null))
    GLFW_C := $(sort $(GLFW_C) $(GLFW_TIMER_C))
    GLFW_OBJC := $(wildcard $(GLFW_DIR)/cocoa_*.m) $(wildcard $(GLFW_DIR)/nsgl_context.m)
else ifeq ($(PLATFORM),linux)
    # posix_poll.c IS required on Linux (used by the X11 backend).
    GLFW_C := $(addprefix $(GLFW_DIR)/, \
        posix_module.c posix_poll.c posix_thread.c posix_time.c \
        x11_init.c x11_monitor.c x11_window.c xkb_unicode.c \
        glx_context.c linux_joystick.c)
else ifeq ($(PLATFORM),windows)
    GLFW_C := $(addprefix $(GLFW_DIR)/, \
        win32_init.c win32_joystick.c win32_module.c win32_monitor.c \
        win32_thread.c win32_time.c win32_window.c wgl_context.c)
endif

CPP_SRC := $(APP_CPP) $(IMGUI_CPP)
C_SRC   := $(GLFW_COMMON) $(GLFW_C)

# ---------------------------------------------------------------- config
CONFIG ?= debug
OBJ_DIR := $(BUILD)/obj/$(CONFIG)
OUT_DIR := $(BUILD)/$(CONFIG)

ifeq ($(CONFIG),release)
    BUILD_FLAGS := -O3 -DNDEBUG
    WARN_FLAGS  :=
else
    BUILD_FLAGS := -g -O0 -DDEBUG
    WARN_FLAGS  := -Wall -Wextra
endif

# Warnings only for our own code; vendored code stays quiet.
CXXFLAGS += $(STANDARD) $(INCLUDES) $(PLATFORM_FLAGS) $(BUILD_FLAGS)
CFLAGS   += $(INCLUDES) $(PLATFORM_FLAGS) $(GLFW_DEFINES) $(BUILD_FLAGS)

# ---------------------------------------------------------------- objects
# Suffix keeps the original extension (foo.cpp -> foo.cpp.o) so the
# pattern rules below match exactly and .c/.cpp/.m never collide.
CPP_OBJ  := $(addprefix $(OBJ_DIR)/,$(addsuffix .o,$(CPP_SRC)))
C_OBJ    := $(addprefix $(OBJ_DIR)/,$(addsuffix .o,$(C_SRC)))
OBJC_OBJ := $(addprefix $(OBJ_DIR)/,$(addsuffix .o,$(GLFW_OBJC)))
OBJ      := $(CPP_OBJ) $(C_OBJ) $(OBJC_OBJ)

TARGET_PATH := $(OUT_DIR)/$(TARGET)

# ---------------------------------------------------------------- rules
.PHONY: all debug release run clean sources build-target

all: debug

debug:
	$(MAKE) CONFIG=debug build-target

release:
	$(MAKE) CONFIG=release build-target

build-target: $(TARGET_PATH)

$(TARGET_PATH): $(OBJ)
	@mkdir -p $(@D)
	$(CXX) $^ -o $@ $(PLATFORM_LIBS)
	@echo "Built $@"

# Only app sources get warnings; imgui/glfw don't.
$(addprefix $(OBJ_DIR)/,$(addsuffix .o,$(APP_CPP))): CXXFLAGS += $(WARN_FLAGS)

$(OBJ_DIR)/%.cpp.o: %.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -MMD -MP -c $< -o $@

$(OBJ_DIR)/%.c.o: %.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -MMD -MP -c $< -o $@

$(OBJ_DIR)/%.m.o: %.m
	@mkdir -p $(@D)
	$(CC) -x objective-c $(CFLAGS) -MMD -MP -c $< -o $@

run: debug
	./$(BUILD)/debug/$(TARGET)

sources:
	@echo "Platform: $(PLATFORM)"
	@echo "C sources:";      printf '  %s\n' $(C_SRC)
	@echo "ObjC sources:";   printf '  %s\n' $(GLFW_OBJC)
	@echo "C++ sources:";    printf '  %s\n' $(CPP_SRC)

clean:
	rm -rf $(BUILD)

-include $(OBJ:.o=.d)
