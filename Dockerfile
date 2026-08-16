FROM alpine:3.22

RUN apk add --no-cache ca-certificates openssh-client ttyd wget \
    && update-ca-certificates

COPY docker/entrypoint.sh /usr/local/bin/agentdesk-entrypoint
RUN chmod 0755 /usr/local/bin/agentdesk-entrypoint \
    && addgroup -S agentdesk \
    && adduser -S -D -H -G agentdesk agentdesk \
    && mkdir -p /run/agentdesk \
    && chown agentdesk:agentdesk /run/agentdesk

USER agentdesk
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/agentdesk-entrypoint"]
