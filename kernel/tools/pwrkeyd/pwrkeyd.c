/*
 * pwrkeyd - power key handling for the stage-1 initramfs.
 *   short press: toggle the screen black (an empty VT2) and back to VT1;
 *                touch is grabbed while black
 *   held for LONG_MS: sync and power off
 * Without a panel driver the backlight stays on. Build: see build.sh.
 */
#include <linux/input.h>
#include <linux/vt.h>

#define LONG_MS		2000
#define BLACK_VT	2
#define CONSOLE_VT	1

static int find_input(const char *want)
{
	char path[32] = "/dev/input/event", name[64];
	int i, fd;

	for (i = 0; i < 10; i++) {
		path[16] = '0' + i;
		path[17] = 0;
		fd = open(path, O_RDONLY);
		if (fd < 0)
			continue;
		if (ioctl(fd, EVIOCGNAME(sizeof(name)), name) > 0 && !strcmp(name, want))
			return fd;
		close(fd);
	}
	return -1;
}

static void set_black(int black, int touch)
{
	static const char clear[] = "\033[2J\033[H\033[?25l";
	int fd;

	if (black) {
		fd = open("/dev/tty2", O_WRONLY);
		if (fd >= 0) {
			write(fd, clear, sizeof(clear) - 1);
			close(fd);
		}
	}
	fd = open("/dev/tty0", O_RDWR);
	if (fd >= 0) {
		ioctl(fd, VT_ACTIVATE, black ? BLACK_VT : CONSOLE_VT);
		close(fd);
	}
	if (touch >= 0)
		ioctl(touch, EVIOCGRAB, black);
}

int main(void)
{
	struct pollfd pfd;
	struct input_event ev;
	int keys, touch, black = 0, down = 0;

	keys = find_input("GPIO Keys");
	if (keys < 0) {
		printf("pwrkeyd: no GPIO Keys input\n");
		return 1;
	}
	touch = find_input("stmfts");
	pfd.fd = keys;
	pfd.events = POLLIN;

	for (;;) {
		/* While the key is held, a timeout means a long press */
		if (poll(&pfd, 1, down ? LONG_MS : -1) == 0) {
			printf("pwrkeyd: long press, powering off\n");
			__nolibc_syscall0(__NR_sync);
			reboot(LINUX_REBOOT_CMD_POWER_OFF);
			down = 0;
			continue;
		}
		if (read(keys, &ev, sizeof(ev)) != sizeof(ev))
			continue;
		if (ev.type != EV_KEY || ev.code != KEY_POWER)
			continue;
		if (ev.value == 1) {
			down = 1;
		} else if (ev.value == 0 && down) {
			down = 0;
			black = !black;
			set_black(black, touch);
		}
	}
}
