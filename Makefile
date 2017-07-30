include config.mk

# ASSUMPTIONS:
#   1. You are building on 64-bit Manjaro Linux.
#   2. You are building only for 64-bit Linux and 64-bit Windows.

# ===== Configuration =====

FILE_NAME=faulty

# Be careful with what you set this to -- it gets rm -rf'd by `make clean`.
BUILD_DIR=./build

LINUX_BUILD_DIR=${BUILD_DIR}/linux-x86_64
WINDOWS_BUILD_DIR=${BUILD_DIR}/windows-x86_64

LINUX_EXE=${LINUX_BUILD_DIR}/${FILE_NAME}
WINDOWS_EXE=${WINDOWS_BUILD_DIR}/${FILE_NAME}.exe

SRCFILES := $(shell find 'src' -name '*.c')

# ===== Flags =====

# TODO: Figure out if these are correct. I copypasta'd them from https://github.com/duckinator/dux/blob/main/Makefile
#       and removed things that were clearly specific to operating systems.
override COMPILER_FLAGS += -std=c99 -Wall -g -Iinclude -Wextra -Wunused -Wformat=2 -Winit-self -Wmissing-include-dirs -Wstrict-overflow=4 -Wfloat-equal -Wwrite-strings -Wconversion -Wundef -Wtrigraphs -Wunused-parameter -Wunknown-pragmas -Wcast-align -Wswitch-enum -Waggregate-return -Wmissing-noreturn -Wmissing-format-attribute -Wpacked -Wredundant-decls -Wunreachable-code -Winline -Winvalid-pch -Wdisabled-optimization -Wbad-function-cast -Wunused-function -Werror=implicit-function-declaration -gdwarf-2 -pedantic-errors

override LINKER_FLAGS += -lSDL2

# ===== Targets =====

# WINDOWS BUILDS ARE BROKEN. RIP.
all: prereqs linux #windows

prereqs: config.mk
	@mkdir -p ${LINUX_BUILD_DIR}
	@mkdir -p ${WINDOWS_BUILD_DIR}

linux: prereqs ${LINUX_EXE}

${LINUX_EXE}:
	${CC} ${COMPILER_FLAGS} ${LINKER_FLAGS} ${SRCFILES} -o ${LINUX_EXE}

windows: prereqs ${WINDOWS_EXE}

# BROKEN
${WINDOWS_EXE}:
	${WINDOWS_CC} ${COMPILER_FLAGS} ${LINKER_FLAGS} ${SRCFILES} -o ${WINDOWS_EXE}


config.mk:
	@printf "Before compiling, copy config.mk.dist to config.mk and edit it if necessary.\n"
	@false

test:
	@echo "lol just kidding"

clean:
	@find ./src -name '*.o' -delete
	@find ./src -name '*.d' -delete
	@rm -rf ${BUILD_DIR}

.PHONY: all linux windows clean test todo
