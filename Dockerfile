# Use the offical Golang image to create a build artifact.
# This is based on Debian and sets the GOPATH to /go.
# https://hub.docker.com/_/golang
FROM golang:1.13 as builder

# Set the needed GO* environment variables.
ENV CGO_ENABLED=0

# Set the working directory to a $GOPATH subdirectory, not under $GOPATH/src.
WORKDIR /go/docker

# Copy local code to the container image.
COPY . .

# Build the command inside the container.
RUN go build -v -mod=readonly -o /server

# Use a Docker multi-stage build to create a lean production image.
# https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
FROM alpine

# Install needed root TLS certificate authorities.
RUN apk add ca-certificates

# Copy /etc/mime.types to the production image from the builder stage.
COPY --from=builder /etc/mime.types /etc

# Copy the binary to the production image from the builder stage.
COPY --from=builder /server /

# Run the web service on container startup.
CMD ["/server"]