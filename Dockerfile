FROM lightninglabs/lndinit:daily-testing-only

# Install packages
RUN apk update && apk add --update --no-cache \
    git \
    bash \
    curl \
    openssh \
    wget \
    curl

RUN apk --no-cache add --virtual builds-deps build-base

COPY start.sh "/usr/local/bin/"
RUN chmod +x /usr/local/bin/start.sh
COPY lnd.conf "/root/lnd.conf"

# Add additional params when running docker run 
# https://stackoverflow.com/a/53544072/5676120
ENTRYPOINT ["/usr/local/bin/start.sh"]