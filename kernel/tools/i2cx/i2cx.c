/*
 * i2cx - minimal i2c write/read for the stage-1 shell (no i2c-tools there).
 *   i2cx <bus> <addr> <wbyte...> [r<N>]
 * Does one I2C_RDWR: write the bytes, then (repeated start) read N bytes.
 * Uses I2C_SLAVE_FORCE semantics via I2C_RDWR, so it works while a driver
 * owns the address. Build: see build.sh (nolibc from the kernel tree).
 */
#include <linux/i2c.h>
#include <linux/i2c-dev.h>

static unsigned long hex(const char *s)
{
	unsigned long v = 0;

	if (s[0] == '0' && (s[1] == 'x' || s[1] == 'X'))
		s += 2;
	for (; *s; s++)
		v = v * 16 + (*s <= '9' ? *s - '0' : (*s | 0x20) - 'a' + 10);
	return v;
}

int main(int argc, char **argv)
{
	unsigned char wbuf[64], rbuf[256];
	struct i2c_msg msgs[2];
	struct i2c_rdwr_ioctl_data xfer = { msgs, 0 };
	char dev[32] = "/dev/i2c-";
	int nw = 0, nr = 0, fd, i;

	if (argc < 4) {
		printf("usage: i2cx <bus> <addr> <wbyte...> [r<N>]\n");
		return 2;
	}
	for (i = 0; argv[1][i] && i < 8; i++)
		dev[9 + i] = argv[1][i];
	for (i = 3; i < argc; i++) {
		if (argv[i][0] == 'r')
			nr = atoi(argv[i] + 1);
		else if (nw < (int)sizeof(wbuf))
			wbuf[nw++] = hex(argv[i]);
	}
	if (nr > (int)sizeof(rbuf))
		nr = sizeof(rbuf);

	fd = open(dev, O_RDWR);
	if (fd < 0) {
		perror("open");
		return 1;
	}
	if (nw) {
		msgs[xfer.nmsgs].addr = hex(argv[2]);
		msgs[xfer.nmsgs].flags = 0;
		msgs[xfer.nmsgs].len = nw;
		msgs[xfer.nmsgs++].buf = wbuf;
	}
	if (nr) {
		msgs[xfer.nmsgs].addr = hex(argv[2]);
		msgs[xfer.nmsgs].flags = I2C_M_RD;
		msgs[xfer.nmsgs].len = nr;
		msgs[xfer.nmsgs++].buf = rbuf;
	}
	if (ioctl(fd, I2C_RDWR, &xfer) < 0) {
		perror("I2C_RDWR");
		return 1;
	}
	for (i = 0; i < nr; i++)
		printf("%02x%c", rbuf[i], (i % 16 == 15 || i == nr - 1) ? '\n' : ' ');
	return 0;
}
