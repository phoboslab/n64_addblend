/**
 * RSP additive blend - workaround for overflow with additive blending
 * 
 * Using the normal `RDPQ_BLENDER_ADDITIVE` color combiner will cause 
 * overflow when pixels exceed the 5 or 8 bit range. There is no clamping
 * on the RDP to prevent this.
 * 
 * Here we work around this issue by drawing on a 32bit surface using the
 * RDP, but using the color combiner to divide all incoming pixels by 8.
 * This effectively draws 16 bit colors (5551) into a 32bit surface (8888),
 * giving us way more range before additive blending will overflow.
 * 
 * In a post processing step the 32bit render buffer is converted back to
 * 16bit, either using the RSP or CPU. This step takes about 4ms on the RSP.
 * 
 * Note that the RSP code (rsp_add.rspl) is written in RSPL and transpiled 
 * into assembly (rsp_add.S) using the transpiler from HailToDogongo's 
 * Tiny3D project: https://github.com/HailToDodongo/rspl
 * 
 * Keep in mind that the N64 struggles a lot with overdraw. For each 
 * blended pixel the previous value needs to be loaded from RDRAM, combined
 * with the incoming pixel and written back to RDRAM. With the N64's slow
 * memory speed, there's only so many blended sprites you can render,
 * before it turns into a slide show. 
 * 
 * In this example, the issue is amplified even more, because we're drawing
 * into a 32bit buffer - doubling the memory traffic.
 */

#include "libdragon.h"

static sprite_t *flare_sprite;

typedef struct {
	float x;
	float y;
	float vx;
	float vy;
	float scale_factor;
} flare_t;

#define NUM_FLARES 64

static flare_t flares[NUM_FLARES];

// Convert 32bit rgba 8888 to 16bit 5551 on the RSP
static uint32_t rsp_overlay_id = 0;
DEFINE_RSP_UCODE(rsp_add);
enum {
	COMMAND_RGBA8888_TO_5551 = 0x0
};

void rsp_rgba_8888_to_5551(uint32_t *rgba32_in, uint16_t *rgba16_out) {
	rspq_write(rsp_overlay_id, COMMAND_RGBA8888_TO_5551,
		(uint32_t)rgba32_in & 0xFFFFFF,
		(uint32_t)rgba16_out & 0xFFFFFF
	);
}

int main() {
	debug_init_isviewer();
	debug_init_usblog();

	rspq_init();
	joypad_init();
	timer_init();

	dfs_init(DFS_DEFAULT_LOCATION);
	rdpq_init();

	rsp_overlay_id = rspq_overlay_register(&rsp_add);

	// Init the display with a 16bit framebuffer
	display_init(RESOLUTION_320x240, DEPTH_16_BPP, 3, GAMMA_NONE, FILTERS_DISABLED);
	uint32_t display_width = display_get_width();
	uint32_t display_height = display_get_height();

	// Init the rendering surface as 32bit
	surface_t render32 = surface_alloc(FMT_RGBA32, display_width, display_height);

	// Initialize flares with random positions and velocity
	int flare_width = 64;
	int flare_height = 64;

	flare_sprite = sprite_load("rom:/flare.sprite");
	for (uint32_t i = 0; i < NUM_FLARES; i++) {
		flare_t *flare = &flares[i];
		flare->x = rand() % display_width;
		flare->y = rand() % display_height;
		flare->vx = (float)rand() / RAND_MAX - 0.5f;
		flare->vy = (float)rand() / RAND_MAX - 0.5f;
	}

	while (true) {
		surface_t *screen = display_get();

		rdpq_attach(screen, NULL);
		rdpq_set_mode_standard();

		// Draw onto the separate 32bit render surface using a color combiner 
		// that blend additively with the target surface but also multiplies
		// each incoming pixel with 32/256 (i.e. divide by 8) to convert 
		// 8 bit colors into 5 bit.
		rdpq_set_fog_color(RGBA32(0, 0, 0, 32));
		rdpq_mode_blender(RDPQ_BLENDER((IN_RGB, FOG_ALPHA, MEMORY_RGB, ONE)));	
		rdpq_set_color_image(&render32);

		rdpq_clear((color_t){0,0,0,0});
		

		// Update and render flares
		surface_t flare_surf = sprite_get_pixels(flare_sprite);
		for (uint32_t i = 0; i < NUM_FLARES; i++) {
			flares[i].x += flares[i].vx;
			flares[i].y += flares[i].vy;

			if (flares[i].x < -flare_width) {
				flares[i].x = display_width;
			}
			else if (flares[i].x > display_width) {
				flares[i].x = -flare_width;
			}
			if (flares[i].y < -flare_height) {
				flares[i].y = display_height;
			}
			else if (flares[i].y > display_height) {
				flares[i].y = -flare_height;
			}

			rdpq_tex_blit(&flare_surf, flares[i].x, flares[i].y, &(rdpq_blitparms_t){
				.scale_x = 2, .scale_y = 2
			});
		}	
		

		rdpq_detach();
		rdpq_fence();
		rsp_rgba_8888_to_5551(render32.buffer, screen->buffer);

		display_show(screen);
	}
}
