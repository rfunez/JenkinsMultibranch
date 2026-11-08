FROM alpine:3.20
RUN echo 'Welcome to Docker Jenkins' >/tmp/greetings.txt
CMD [ "cat", "/tmp/greetings.txt" ]