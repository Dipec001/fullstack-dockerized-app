# Start from the official Go image
FROM golang:1.19-bullseye AS base

# Set the working directory inside the container
WORKDIR /app

# Copy the go.mod and go.sum files
COPY go.mod go.sum ./

# Install dependencies (will be cached if unchanged)
RUN go mod download

# Copy the source code
COPY . .

# Build the Go application
RUN go build -o api-golang

# Expose the port that the Go app will run on
EXPOSE 8080

# Command to run the Go application
CMD ["./api-golang"]

