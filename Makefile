# Toolchain definitions
CC = sdcc
LD = stm8-ld
AS = stm8-as

MKDIR = mkdir
CP = cp

DEFINE = -DSTM8S003

# Include settings
INCLUDE = $(addprefix -I, inc/)

# Assembler flags
AS_FLAGS =

# Compiler flags
CC_FLAGS = -mstm8 --out-fmt-elf -c --debug --opt-code-size --asm=gas --function-sections --data-sections $(INCLUDE)

# Path definitions
PROJECT = STM8

# Objects definition
# Compiled objects list
OBJ_DIR = obj
VPATH += src
OBJECTS = $(addprefix $(OBJ_DIR)/, main.o bar.o)

# Linker flags
LD_FLAGS = -T./elf32stm8s003f3.x --print-memory-usage --gc-sections -Map $(OBJ_DIR)/map_$(PROJECT).map
LIB_DIRS = $(addprefix -L, /usr/local/share/sdcc/lib/stm8)

# Source dependencies:
DEPS = $(OBJECTS:.o=.d)
ASM_DEPS = $(OBJECTS:.o=.asm)

# ------------------------------------
# Instructions
# ------------------------------------

$(OBJ_DIR)/$(PROJECT).elf: $(OBJECTS)
	$(LD) $^ -o $@ $(LD_FLAGS) $(LIBS)

#-include $(DEPS)

clean:
	rm -rf $(OBJ_DIR)/

# Uncomment for standard generation

$(OBJ_DIR)/%.d: %.c
	@$(MKDIR) -p $(OBJ_DIR)
	$(CC) $< $(DEFINE) $(CC_FLAGS) -MM > $@

$(OBJ_DIR)/%.o: %.c $(OBJ_DIR)/%.d
	@$(MKDIR) -p $(OBJ_DIR)
	$(CC) $< $(DEFINE) $(CC_FLAGS) -o $@

$(OBJ_DIR)/%.o: %.asm
	@$(MKDIR) -p $(OBJ_DIR)
	$(AS) $< $(AS_FLAGS) -o $@

# ----------------------------------------
# Phony targets
# ----------------------------------------
.PHONY: clean debug
