# Build this Dockerfile from the repository root:
# docker build -f coach-addon/Dockerfile .
ARG BUILD_FROM=python:3.12-alpine
FROM ${BUILD_FROM}

# Alpine provides matplotlib as a compatible system package. Do not replace it
# with pip installation: no suitable Alpine wheel is available for this image.
RUN apk add --no-cache jq py3-matplotlib \
    && pip install --no-cache-dir \
        --extra-index-url https://wheels.home-assistant.io/musllinux/ \
        requests \
        garminconnect

# Application code and all persistent state live on the Supervisor share map
# (see config.yaml map: and run.sh cd into /share/workout planner), not in
# the image. This is deliberate: it is the exact code already running in
# production when invoked directly from the Terminal add-on, no separate
# build-time copy to keep in sync.
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
