# Build this Dockerfile from the repository root:
# docker build -f coach-addon/Dockerfile .
ARG BUILD_FROM=python:3.12-slim
FROM ${BUILD_FROM}

# Confirmed by a real build failure: matplotlib has no musllinux (Alpine)
# wheel, and python:3.12-alpine ships no C compiler to build it from source
# either. python:3.12-slim (Debian/glibc) is the pragmatic fix - matplotlib,
# requests and garminconnect all have first-party manylinux wheels on PyPI,
# so no extra wheel index or build toolchain is needed at all.
RUN apt-get update \
    && apt-get install --no-install-recommends -y jq \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir \
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
