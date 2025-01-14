FROM golang:1.23.4 as builder
WORKDIR /app
COPY backend/go.mod .
COPY backend/go.sum .
COPY backend/main.go .
COPY backend/migrations /app/migrations
RUN go mod download && go mod verify
RUN CGO_ENABLED=0 go build -a -ldflags '-extldflags "-static"' -o /app/backend

FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/backend /app/backend
COPY backend/migrations /app/migrations
RUN mkdir /app/pb_public
COPY mobile/build/web /app/pb_public
EXPOSE 8090
CMD ["/app/backend", "serve", "--http=0.0.0.0:8090"]
