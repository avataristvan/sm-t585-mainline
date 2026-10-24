/* Minimal no-libc CPU speed probe for stage 1: cpuloop CPU [MITER]
 * Pins itself to CPU, runs MITER million dependent adds (default 200) and
 * prints the elapsed time in microseconds; MHz ~= MITER * 1e6 / us. */
typedef unsigned long u64;

static long sys(long n, long a, long b, long c)
{
	register long x8 asm("x8") = n;
	register long x0 asm("x0") = a, x1 asm("x1") = b, x2 asm("x2") = c;
	asm volatile("svc 0" : "+r"(x0) : "r"(x8), "r"(x1), "r"(x2) : "memory");
	return x0;
}

static u64 dec(const char *s)
{
	u64 v = 0;
	for (; *s; s++)
		v = v * 10 + (*s - '0');
	return v;
}

static u64 now_us(void)
{
	long ts[2];
	sys(113, 1, (long)ts, 0);	/* clock_gettime(CLOCK_MONOTONIC) */
	return ts[0] * 1000000UL + ts[1] / 1000;
}

__attribute__((used)) void main2(long argc, char **argv)
{
	if (argc < 2)
		sys(93, 2, 0, 0);
	u64 mask = 1UL << dec(argv[1]);
	u64 n = (argc > 2 ? dec(argv[2]) : 200) * 1000000UL;
	if (sys(122, 0, sizeof(mask), (long)&mask))	/* sched_setaffinity */
		sys(93, 3, 0, 0);
	u64 t0 = now_us();
	/* one dependent add per cycle on Cortex-A53 */
	asm volatile("1: subs %0, %0, #1\n b.ne 1b" : "+r"(n));
	u64 us = now_us() - t0;
	char b[21];
	int i = 20;
	b[i] = '\n';
	do
		b[--i] = '0' + us % 10;
	while (us /= 10);
	sys(64, 1, (long)(b + i), 21 - i);
	sys(93, 0, 0, 0);
}

__attribute__((naked)) void _start(void)
{
	asm("ldr x0, [sp]\n add x1, sp, #8\n b main2");
}
