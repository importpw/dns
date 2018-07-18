FROM alpine:3.5
RUN apk add --no-cache curl bind-tools
WORKDIR /public
COPY . .
RUN ./test.sh
RUN echo "All tests passed!" > index.html
