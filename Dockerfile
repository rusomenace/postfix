# Dockerfile for a Postfix email relay service
# Build the container: docker build -t postfix/postfix:latest -f Dockerfile .

FROM alpine:latest

RUN apk update && \
    apk add bash nano gawk cyrus-sasl cyrus-sasl-login cyrus-sasl-crammd5 mailx \
    postfix && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /var/log/supervisor/ /var/run/supervisor/ && \
    sed -i -e 's/inet_interfaces = localhost/inet_interfaces = all/g' /etc/postfix/main.cf

COPY run.sh /

# Copy the transport file
# COPY transport /etc/postfix/transport

RUN chmod +x /run.sh
RUN newaliases

EXPOSE 25
#ENTRYPOINT ["/run.sh"]
CMD ["/run.sh"]
