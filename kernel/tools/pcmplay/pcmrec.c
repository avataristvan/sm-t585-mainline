/*
 * pcmrec - minimal ALSA capture via raw ioctls, sibling of pcmplay, for the stage-1
 * loopback measurement. S16_LE stereo 48 kHz only, writes a 44-byte WAV header.
 *   pcmrec <pcm-dev> <out.wav> <frames> [period-frames] [periods]
 * Prints every ioctl result, elapsed time and the final hw_ptr.
 * Build: see build.sh (nolibc from the kernel tree).
 */
#include <sound/asound.h>

static unsigned long num(const char *s)
{
	unsigned long v = 0;

	for (; *s >= '0' && *s <= '9'; s++)
		v = v * 10 + *s - '0';
	return v;
}

static void mask_set(struct snd_pcm_hw_params *p, int var, unsigned int bit)
{
	struct snd_mask *m = &p->masks[var - SNDRV_PCM_HW_PARAM_FIRST_MASK];

	for (int i = 0; i < 8; i++)
		m->bits[i] = 0;
	m->bits[bit >> 5] = 1u << (bit & 31);
}

static void iv_set(struct snd_pcm_hw_params *p, int var, unsigned int v)
{
	struct snd_interval *i = &p->intervals[var - SNDRV_PCM_HW_PARAM_FIRST_INTERVAL];

	i->min = i->max = v;
	i->openmin = i->openmax = i->empty = 0;
	i->integer = 1;
}

static long ms_now(void)
{
	struct timespec t;

	clock_gettime(CLOCK_MONOTONIC, &t);
	return t.tv_sec * 1000 + t.tv_nsec / 1000000;
}

static void le32(unsigned char *p, unsigned int v)
{
	p[0] = v; p[1] = v >> 8; p[2] = v >> 16; p[3] = v >> 24;
}

static void wav_header(unsigned char *h, unsigned int bytes)
{
	memcpy(h, "RIFF\0\0\0\0WAVEfmt \x10\0\0\0\x01\0\x02\0\0\0\0\0\0\0\0\0\x04\0\x10\0data", 40);
	le32(h + 4, 36 + bytes);
	le32(h + 24, 48000);
	le32(h + 28, 48000 * 4);
	le32(h + 40, bytes);
}

static char buf[4096 * 4];

int main(int argc, char **argv)
{
	struct snd_pcm_hw_params hw;
	struct snd_pcm_status st;
	struct snd_xferi x;
	unsigned char hdr[44];
	unsigned long want = argc > 3 ? num(argv[3]) : 0;
	unsigned long period = argc > 4 ? num(argv[4]) : 1024;
	unsigned long periods = argc > 5 ? num(argv[5]) : 4;
	unsigned long total = 0, n;
	long fd, out, r, t0;
	int i;

	if (argc < 4) {
		printf("usage: pcmrec /dev/snd/pcmC0D0c out.wav frames [period] [periods]\n");
		return 1;
	}
	if (period * 4 > sizeof(buf))
		period = sizeof(buf) / 4;
	fd = open(argv[1], O_RDWR);
	out = open(argv[2], O_WRONLY | O_CREAT | O_TRUNC, 0644);
	printf("open pcm=%ld wav=%ld\n", fd, out);
	if (fd < 0 || out < 0)
		return 2;

	memset(&hw, 0, sizeof(hw));
	for (i = 0; i <= SNDRV_PCM_HW_PARAM_LAST_MASK - SNDRV_PCM_HW_PARAM_FIRST_MASK; i++)
		memset(&hw.masks[i], 0xff, sizeof(hw.masks[i]));
	for (i = 0; i <= SNDRV_PCM_HW_PARAM_LAST_INTERVAL - SNDRV_PCM_HW_PARAM_FIRST_INTERVAL; i++)
		hw.intervals[i].max = ~0u;
	hw.rmask = ~0u;
	mask_set(&hw, SNDRV_PCM_HW_PARAM_ACCESS, SNDRV_PCM_ACCESS_RW_INTERLEAVED);
	mask_set(&hw, SNDRV_PCM_HW_PARAM_FORMAT, SNDRV_PCM_FORMAT_S16_LE);
	mask_set(&hw, SNDRV_PCM_HW_PARAM_SUBFORMAT, SNDRV_PCM_SUBFORMAT_STD);
	iv_set(&hw, SNDRV_PCM_HW_PARAM_CHANNELS, 2);
	iv_set(&hw, SNDRV_PCM_HW_PARAM_RATE, 48000);
	iv_set(&hw, SNDRV_PCM_HW_PARAM_PERIOD_SIZE, period);
	iv_set(&hw, SNDRV_PCM_HW_PARAM_PERIODS, periods);
	r = ioctl(fd, SNDRV_PCM_IOCTL_HW_PARAMS, &hw);
	printf("hw_params=%ld errno=%d\n", r, r < 0 ? errno : 0);
	if (r < 0)
		return 3;
	r = ioctl(fd, SNDRV_PCM_IOCTL_PREPARE, 0);
	printf("prepare=%ld errno=%d\n", r, r < 0 ? errno : 0);
	if (r < 0)
		return 4;
	r = ioctl(fd, SNDRV_PCM_IOCTL_START, 0);
	printf("start=%ld errno=%d\n", r, r < 0 ? errno : 0);

	wav_header(hdr, 0);
	write(out, hdr, sizeof(hdr));
	t0 = ms_now();
	while (total < want) {
		n = want - total < period ? want - total : period;
		x.result = 0;
		x.buf = buf;
		x.frames = n;
		r = ioctl(fd, SNDRV_PCM_IOCTL_READI_FRAMES, &x);
		if (r < 0) {
			printf("readi errno=%d after %lu frames, %ld ms\n", errno, total, ms_now() - t0);
			if (errno == EPIPE && ioctl(fd, SNDRV_PCM_IOCTL_PREPARE, 0) == 0 &&
			    ioctl(fd, SNDRV_PCM_IOCTL_START, 0) == 0)
				continue;
			break;
		}
		write(out, buf, x.result * 4);
		total += x.result;
	}
	memset(&st, 0, sizeof(st));
	ioctl(fd, SNDRV_PCM_IOCTL_STATUS, &st);
	printf("read %lu frames in %ld ms, state=%d hw_ptr=%lu\n",
	       total, ms_now() - t0, st.state, (unsigned long)st.hw_ptr);
	wav_header(hdr, total * 4);
	lseek(out, 0, SEEK_SET);
	write(out, hdr, sizeof(hdr));
	return 0;
}
