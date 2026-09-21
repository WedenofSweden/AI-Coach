# Build this Dockerfile from the repository root:
# docker build -f coach-addon/Dockerfile .
ARG BUILD_FROM=python:3.12-alpine
FROM ${BUILD_FROM}

# python:3.12-alpine builds its own Python from source at /usr/local, entirely
# separate from Alpine's own packaged Python. An apk-installed py3-matplotlib
# lands in the OS Python, not this one - confirmed by ModuleNotFoundError at
# runtime. Pip-installing matplotlib from the same musllinux wheel index used
# for requests/garminconnect below is what actually reaches this interpreter.
RUN apk add --no-cache jq \
    && pip install --no-cache-dir \
        --extra-index-url https://wheels.home-assistant.io/musllinux/ \
        requests \
        garminconnect \
        matplotlib

# Application code and all persistent state live on the Supervisor share map
# (see config.yaml map: and run.sh cd into /share/workout planner), not in
# the image. This is deliberate: it is the exact code already running in
# production when invoked directly from the Terminal add-on, no separate
# build-time copy to keep in sync.
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
