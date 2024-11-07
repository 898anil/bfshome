# Variables
BINARY_NAME=bfs_server
GO=go
MAIN_FILE=main.go

# Build configurations
GOOS?=$(shell go env GOOS)
GOARCH?=$(shell go env GOARCH)

# Colors for terminal output
GREEN=\033[0;32m
NC=\033[0m # No Color

.PHONY: all build clean run help

# Default target
all: build

# Build the application
build:
	@echo "${GREEN}Building ${BINARY_NAME}...${NC}"
	@GOOS=${GOOS} GOARCH=${GOARCH} ${GO} build -o ${BINARY_NAME} ${MAIN_FILE}
	@echo "${GREEN}Build complete!${NC}"

# Clean build files
clean:
	@echo "${GREEN}Cleaning...${NC}"
	@rm -f ${BINARY_NAME}
	@echo "${GREEN}Cleaned!${NC}"

# Run the application
run: build
	@echo "${GREEN}Starting server...${NC}"
	@./${BINARY_NAME}

# Development mode with automatic restart
dev:
	@echo "${GREEN}Starting server in development mode...${NC}"
	@which air > /dev/null || (echo "Installing air..." && go install github.com/cosmtrek/air@latest)
	@air

# Install dependencies
deps:
	@echo "${GREEN}Installing dependencies...${NC}"
	@${GO} mod download
	@echo "${GREEN}Dependencies installed!${NC}"

# Run tests
test:
	@echo "${GREEN}Running tests...${NC}"
	@${GO} test ./... -v

# Show help
help:
	@echo "Available commands:"
	@echo "  make build    - Build the application"
	@echo "  make clean    - Remove build artifacts"
	@echo "  make run      - Build and run the application"
	@echo "  make dev      - Run in development mode with auto-reload"
	@echo "  make deps     - Install dependencies"
	@echo "  make test     - Run tests"
	@echo "  make help     - Show this help message"

# Cross compilation targets
build-linux:
	@echo "${GREEN}Building for Linux...${NC}"
	@GOOS=linux GOARCH=amd64 ${GO} build -o ${BINARY_NAME}-linux ${MAIN_FILE}

build-windows:
	@echo "${GREEN}Building for Windows...${NC}"
	@GOOS=windows GOARCH=amd64 ${GO} build -o ${BINARY_NAME}-windows.exe ${MAIN_FILE}

build-mac:
	@echo "${GREEN}Building for macOS...${NC}"
	@GOOS=darwin GOARCH=amd64 ${GO} build -o ${BINARY_NAME}-mac ${MAIN_FILE}

# Build for all platforms
build-all: build-linux build-windows build-mac 