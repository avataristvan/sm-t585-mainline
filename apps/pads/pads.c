// Pad grid for the SM-T585: SDL3 straight on KMS (no compositor), multitouch.
// Each pad lights while a finger holds it; presses go to stdout as
// "on <pad>" / "off <pad>" (later: USB MIDI notes).
//
//   cc -O2 -o pads pads.c $(pkg-config --cflags --libs sdl3)
//   pads [seconds]        quit after <seconds>, or on Escape
#include <SDL3/SDL.h>
#include <stdio.h>
#include <stdlib.h>

#define COLS 4
#define ROWS 4
#define MAX_FINGERS 10

static struct {
	SDL_FingerID id;
	int pad;		// -1: slot free
} fingers[MAX_FINGERS];

static int held[COLS * ROWS];	// fingers on each pad

static int pad_at(float x, float y)
{
	int c = (int)(x * COLS), r = (int)(y * ROWS);

	if (c < 0 || c >= COLS || r < 0 || r >= ROWS)
		return -1;
	return r * COLS + c;
}

static void press(int pad)
{
	if (pad >= 0 && held[pad]++ == 0)
		printf("on %d\n", pad);
}

static void release(int pad)
{
	if (pad >= 0 && --held[pad] == 0)
		printf("off %d\n", pad);
}

static int slot(SDL_FingerID id, int alloc)
{
	for (int i = 0; i < MAX_FINGERS; i++)
		if (fingers[i].pad != -1 && fingers[i].id == id)
			return i;
	if (alloc)
		for (int i = 0; i < MAX_FINGERS; i++)
			if (fingers[i].pad == -1)
				return i;
	return -1;
}

// Finger down, moved or up: a finger sliding onto another pad moves its press.
static void finger(const SDL_TouchFingerEvent *f, int down)
{
	int s = slot(f->fingerID, down);
	int pad = down ? pad_at(f->x, f->y) : -1;

	if (s < 0)
		return;
	if (fingers[s].pad != pad) {
		if (fingers[s].pad != -1)
			release(fingers[s].pad);
		press(pad);
	}
	fingers[s].id = f->fingerID;
	fingers[s].pad = down ? (pad >= 0 ? pad : -2) : -1;
}

static void draw(SDL_Renderer *ren)
{
	int w, h;

	SDL_GetRenderOutputSize(ren, &w, &h);
	SDL_SetRenderDrawColor(ren, 16, 16, 20, 255);
	SDL_RenderClear(ren);
	float pw = (float)w / COLS, ph = (float)h / ROWS, gap = 12;
	for (int p = 0; p < COLS * ROWS; p++) {
		SDL_FRect r = { (p % COLS) * pw + gap, (p / COLS) * ph + gap,
				pw - 2 * gap, ph - 2 * gap };
		if (held[p])
			SDL_SetRenderDrawColor(ren, 255, 140, 30, 255);
		else
			SDL_SetRenderDrawColor(ren, 50, 55, 70, 255);
		SDL_RenderFillRect(ren, &r);
	}
	SDL_RenderPresent(ren);
}

int main(int argc, char **argv)
{
	Uint64 end = argc > 1 ? SDL_GetTicks() + 1000 * (Uint64)atoi(argv[1]) : 0;
	SDL_Window *win;
	SDL_Renderer *ren;

	setvbuf(stdout, NULL, _IOLBF, 0);
	for (int i = 0; i < MAX_FINGERS; i++)
		fingers[i].pad = -1;
	// Touch only; no mouse emulation from fingers.
	SDL_SetHint(SDL_HINT_TOUCH_MOUSE_EVENTS, "0");
	if (!SDL_Init(SDL_INIT_VIDEO) ||
	    !SDL_CreateWindowAndRenderer("pads", 0, 0, SDL_WINDOW_FULLSCREEN, &win, &ren)) {
		fprintf(stderr, "SDL: %s\n", SDL_GetError());
		return 1;
	}
	SDL_SetRenderVSync(ren, 1);
	fprintf(stderr, "video %s, renderer %s\n", SDL_GetCurrentVideoDriver(),
		SDL_GetRendererName(ren));

	for (;;) {
		SDL_Event e;

		while (SDL_PollEvent(&e)) {
			switch (e.type) {
			case SDL_EVENT_QUIT:
				goto out;
			case SDL_EVENT_KEY_DOWN:
				if (e.key.key == SDLK_ESCAPE)
					goto out;
				break;
			case SDL_EVENT_FINGER_DOWN:
			case SDL_EVENT_FINGER_MOTION:
				finger(&e.tfinger, 1);
				break;
			case SDL_EVENT_FINGER_UP:
			case SDL_EVENT_FINGER_CANCELED:
				finger(&e.tfinger, 0);
				break;
			}
		}
		if (end && SDL_GetTicks() >= end)
			break;
		draw(ren);
	}
out:
	SDL_Quit();
	return 0;
}
