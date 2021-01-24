FROM golang:alpine as builder
RUN apk add --no-cache git
RUN git clone https://git.sr.ht/~migadu/alps
WORKDIR /go/alps
ENV CGO_ENABLED=0
RUN go build -ldflags '-w -extldflags "-static"' ./cmd/alps

FROM alpine
COPY --from=builder /go/alps/alps /alps
COPY --from=builder /go/alps/themes /themes
COPY --from=builder /go/alps/plugins /plugins
USER nobody
ENTRYPOINT ["/alps", "-theme", "alps", "-addr", ":5000"]
EXPOSE 5000
