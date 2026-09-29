FROM golang:1.22-alpine AS build

WORKDIR /src
COPY go.mod ./
RUN go mod download

COPY main.go ./
COPY static/ ./static/
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /app/server .

FROM scratch

WORKDIR /app
COPY --from=build /app/server ./server
COPY --from=build /src/static ./static

EXPOSE 8080
USER 65532:65532
ENTRYPOINT ["./server"]