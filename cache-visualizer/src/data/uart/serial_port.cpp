#include "serial_port.h"

#include <fcntl.h>
#include <unistd.h>
#include <termios.h>
#include <cerrno>

SerialPort::~SerialPort() {
	close();
}

bool SerialPort::open(const std::string &device, i32 baud) {
	// creates connection to tty without block, continous data flow in and out
	fd_ = ::open(device.c_str(), O_RDWR | O_NOCTTY | O_NONBLOCK);

	if (fd_ < 0) return false;

	// caching tty state to manipulate to handle hardware data better
	termios tty{};
    if (tcgetattr(fd_, &tty) != 0) {
        close();
        return false;
    }

    cfmakeraw(&tty);

    // 8-N-1: read bytes 
    tty.c_cflag &= ~CSIZE;
    tty.c_cflag |= CS8;
    tty.c_cflag &= ~PARENB;
    tty.c_cflag &= ~CSTOPB;
    tty.c_cflag |= CLOCAL | CREAD;

    // no hardware/software flow control
    tty.c_cflag &= ~CRTSCTS;
    tty.c_iflag &= ~(IXON | IXOFF | IXANY);

    speed_t speed = B115200;

    if (baud == 9600) speed = B9600;
    else if (baud == 57600) speed = B57600;
    else if (baud == 115200) speed = B115200;
    else if (baud == 230400) speed = B230400;

    cfsetispeed(&tty, speed);
    cfsetospeed(&tty, speed);

    tty.c_cc[VMIN] = 0;
    tty.c_cc[VTIME] = 0;

    if (tcsetattr(fd_, TCSANOW, &tty) != 0) {
        close();
        return false;
    }

    return true;
}

void SerialPort::close() {
    if (fd_ >= 0) {
        ::close(fd_);
        fd_ = -1;
    }
}

bool SerialPort::is_open() const {
    return fd_ >= 0;
}

bool SerialPort::write(const std::vector<uint8_t>& data) {
    if (fd_ < 0)
        return false;

    size_t offset = 0;

    while (offset < data.size()) {
        ssize_t n = ::write(
            fd_,
            data.data() + offset,
            data.size() - offset
        );

        if (n > 0) {
            offset += n;
        } else if (n < 0 && errno == EINTR) {
            continue;
        } else {
            return false;
        }
    }

    return true;
}

int SerialPort::read(uint8_t* buffer, size_t size) {
    if (fd_ < 0)
        return -1;

    return static_cast<int>(::read(fd_, buffer, size));
}
