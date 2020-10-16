FROM golang:1.14 as build-env

WORKDIR /go/src/github.com/patnolanireland/go-template

COPY go.mod . 
COPY go.sum .

RUN go mod download

COPY . /go/src/github.com/patnolanireland/go-template

RUN go build -i -o app ./cmd/app

# TODO: 
# - Is distroless/base the most desirable runtime image?
# - The binary should be run as non-privleged user - i.e. not root
FROM gcr.io/distroless/base

COPY --from=build-env /go/src/github.com/patnolanireland/go-template/app /usr/local/bin/app

COPY ./config/ /opt/service/config/

CMD ["/usr/local/bin/app"]

EXPOSE 8080
