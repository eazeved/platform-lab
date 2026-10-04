# syntax=docker/dockerfile:1
FROM golang:1.23-alpine AS build
WORKDIR /src
COPY go.mod go.sum* ./
RUN go mod download
COPY . .
ARG VERSION=dev
RUN CGO_ENABLED=0 go build -trimpath -ldflags "-s -w -X main.version=${VERSION}" -o /out/demo .

FROM gcr.io/distroless/static-debian12:nonroot
COPY --from=build /out/demo /demo
USER 65532:65532
EXPOSE 8080
ENTRYPOINT ["/demo"]
