BUILD_DIR=build
include $(N64_INST)/include/n64.mk

src = addblend.c
asm = rsp_add.S
assets_ttf = $(wildcard assets/*.ttf)
assets_png = $(wildcard assets/*.png)

assets_conv = $(addprefix filesystem/,$(notdir $(assets_ttf:%.ttf=%.font64))) \
              $(addprefix filesystem/,$(notdir $(assets_png:%.png=%.sprite)))

MKSPRITE_FLAGS ?= --compress
MKFONT_FLAGS ?= --compress --size 14 --range 20-7F

all: addblend.z64

filesystem/%.font64: assets/%.ttf
	@mkdir -p $(dir $@)
	@echo "    [FONT] $@"
	$(N64_MKFONT) $(MKFONT_FLAGS) -o filesystem "$<"

filesystem/%.sprite: assets/%.png
	@mkdir -p $(dir $@)
	@echo "    [SPRITE] $@"
	$(N64_MKSPRITE) $(MKSPRITE_FLAGS) -o filesystem "$<"

$(BUILD_DIR)/addblend.dfs: $(assets_conv)
$(BUILD_DIR)/addblend.elf: $(src:%.c=$(BUILD_DIR)/%.o) $(asm:%.S=$(BUILD_DIR)/%.o)

addblend.z64: N64_ROM_TITLE="Additive blend demo"
addblend.z64: $(BUILD_DIR)/addblend.dfs 

clean:
	rm -rf $(BUILD_DIR) filesystem addblend.z64

-include $(wildcard $(BUILD_DIR)/*.d)

.PHONY: all clean
