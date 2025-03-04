# define the correct path and name
export PATH 		:= c:/raylib/w64devkit/bin:$(PATH)
PROJECT_NAME        ?= GAMENAME
OUTDIR				= out/
SOURCE				= src/
DEBUGGING           ?= FALSE
EXT				 	= exe

CC = gcc
MAKE = mingw32-make

ifeq ($(OS),Windows_NT)
    RM = cmd /C "del /Q /S"
else
    RM = rm -f
endif

ifeq ($(DEBUGGING), TRUE)
	CFLAGS += -g -O0 -DDEBUG
else
	CFLAGS += -O2 -s -Wl,--gc-sections,--subsystem,windows
endif

CFLAGS += -Wall -D_DEFAULT_SOURCE -Wno-missing-braces

INCLUDE_PATHS = -I.
LDFLAGS = -L.
LDLIBS = -lraylib -lopengl32 -lgdi32 -lcomdlg32 -lole32 -lwinmm

PROJECT_SOURCE_FILES ?= $(wildcard $(SOURCE)*.c $(SOURCE)**/*.c)
OBJS = $(patsubst %.c, %.o, $(PROJECT_SOURCE_FILES))

.PHONY: all

all:
	$(MAKE) $(PROJECT_NAME)
	$(OUTDIR)$(PROJECT_NAME)

# upx -9 $(OUTDIR)$(PROJECT_NAME).exe

$(PROJECT_NAME): $(OBJS)
	$(CC) -o $(OUTDIR)$(PROJECT_NAME).$(EXT) $(OBJS) $(CFLAGS) $(INCLUDE_PATHS) $(LDFLAGS) $(LDLIBS)

%.o: %.c
	$(CC) -c $< -o $@ $(CFLAGS) $(INCLUDE_PATHS)

clean:
	$(RM) *.o