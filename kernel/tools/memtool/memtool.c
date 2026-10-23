/* Minimal no-libc devmem for stage 1: memtool ADDR [VALUE]  (32-bit, hex) */
typedef unsigned long u64;
typedef unsigned int u32;

static long sys(long n, long a, long b, long c, long d, long e, long f)
{
	register long x8 asm("x8") = n;
	register long x0 asm("x0") = a, x1 asm("x1") = b, x2 asm("x2") = c;
	register long x3 asm("x3") = d, x4 asm("x4") = e, x5 asm("x5") = f;
	asm volatile("svc 0" : "+r"(x0) : "r"(x8), "r"(x1), "r"(x2), "r"(x3), "r"(x4), "r"(x5) : "memory");
	return x0;
}

static u64 hex(const char *s)
{
	u64 v = 0;
	if (s[0] == '0' && (s[1] == 'x' || s[1] == 'X'))
		s += 2;
	for (; *s; s++)
		v = v * 16 + (*s <= '9' ? *s - '0' : (*s | 32) - 'a' + 10);
	return v;
}

static void out(u32 v)
{
	char b[11] = "0x";
	for (int i = 0; i < 8; i++)
		b[2 + i] = "0123456789abcdef"[(v >> (28 - 4 * i)) & 0xf];
	b[10] = '\n';
	sys(64, 1, (long)b, 11, 0, 0, 0);
}

__attribute__((used)) void main2(long argc, char **argv)
{
	if (argc < 2)
		sys(93, 2, 0, 0, 0, 0, 0);
	u64 addr = hex(argv[1]);
	/* openat(AT_FDCWD, "/dev/mem", O_RDWR|O_SYNC) */
	long fd = sys(56, -100, (long)"/dev/mem", 02 | 04010000, 0, 0, 0);
	if (fd < 0)
		sys(93, 3, 0, 0, 0, 0, 0);
	long p = sys(222, 0, 4096, 3, 1, fd, addr & ~4095UL);
	if (p < 0 && p > -4096)
		sys(93, 4, 0, 0, 0, 0, 0);
	volatile u32 *r = (volatile u32 *)(p + (addr & 4095));
	if (argc > 2)
		*r = hex(argv[2]);
	out(*r);
	sys(93, 0, 0, 0, 0, 0, 0);
}

__attribute__((naked)) void _start(void)
{
	asm("ldr x0, [sp]\n add x1, sp, #8\n b main2");
}
