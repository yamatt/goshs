# Stage 1: Build the Go application
FROM --platform=$BUILDPLATFORM golang:1.25 AS builder

ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=${TARGETOS:-linux} GOARCH=${TARGETARCH:-amd64} go build -o /goshs .

# Stage 2: Minimal runtime image
FROM scratch

COPY --from=builder /goshs /goshs

ENTRYPOINT ["/goshs"]
