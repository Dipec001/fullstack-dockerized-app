# Start from the official Go image
FROM golang:1.23-bullseye AS build-base

# Set the working directory inside the container
WORKDIR /app

# Copy the go.mod and go.sum files
COPY go.mod go.sum ./

# Install dependencies (will be cached if unchanged)
# with the manual cache flag, only the changed or added dependencies will be reinstalled
RUN --mount=type=cache,id=s/4759dc50-6756-4eac-83d0-79cf36fa15cf-/root/.cache/go-build,target=/go/pkg/mod \
 go mod download

FROM build-base AS dev

# Set gin mode
ENV GIN_MODE=debug

# Install air for hot reload & delve for debugging
# RUN go install github.com/go-delve/delve/cmd/dlv@latest

RUN go install github.com/air-verse/air@latest && \
  go install github.com/go-delve/delve/cmd/dlv@latest

# RUN curl -sSfL https://raw.githubusercontent.com/cosmtrek/air/master/install.sh | sh -s -- -b /usr/local/bin

# Copy the source code
COPY . .

CMD ["air", "-c", ".air.toml"]

FROM build-base AS prod

# create another user
RUN useradd -u 1001 nonroot

# Copy the source code
COPY . .

# Compile healthcheck
RUN go build \
  -ldflags="-linkmode external -extldflags -static" \
  -tags netgo \
  -o healthcheck \
  ./healthcheck/healthcheck.go

# Build the Go application
# caches the Go build artifacts to speed up incremental builds
RUN --mount=type=cache,id=s/4759dc50-6756-4eac-83d0-79cf36fa15cf-/root/.cache/go-build,target=/root/.cache/go-build \
    go build \
    -ldflags="-linkmode external -extldflags -static" \
    -tags netgo \
    -o api-golang


# The next build with only essentials
FROM scratch

# Scratch has no file system, if you don't explicitly set WORKDIR in the scratch stage, 
# any commands that rely on WORKDIR (such as CMD, COPY, etc.) will fail, 
# as there’s no default working directory.
WORKDIR /

# set gin mode
ENV GIN_MODE=release

# Copy the passwd file since we created and are going to use a non-root user
COPY --from=prod /etc/passwd /etc/passwd

# Copy the healthcheck binary from the build stage
COPY --from=prod /app/healthcheck/healthcheck healthcheck

# Copy the built Go binary from the build stage
COPY --from=prod /app/api-golang /api-golang

# Use nonroot user
USER nonroot

# Expose the port that the Go app will run on
EXPOSE 8080

# Command to run the Go application
CMD ["./api-golang"]

