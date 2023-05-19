# FROM ubuntu:20.04 AS builder-image
# FROM python:3.8-alpine
# FROM --platform=linux/amd64 python:3.7-alpine
FROM python:3.8-slim
# FROM amd64/python:3.9-bullseye
WORKDIR /usr/src/app

COPY requirements.txt ./

# RUN apk --no-cache --update-cache add gcc gfortran python python-dev py-pip build-base wget freetype-dev libpng-dev openblas-dev
# RUN ln -s /usr/include/locale.h /usr/include/xlocale.h
# RUN apk add --update yourPackageName
# RUN apt-get update && apt-get install -y gcc
# RUN apk --no-cache add musl-dev linux-headers g++

# RUN pip install --default-timeout=100 future
# RUN apk add --no-cache bash \
#   && apk add --no-cache --virtual .build-deps \
#         # python3-dev \ 
#         # bzip2-dev \
#         # gcc \
#         # g++ \
#         # libc-dev \
#         # gfortran \
#         # cmake \
#         # libpng-dev \
#         # openblas-dev \
#         # py-pip \ 
#         # build-base \ 
#         # wget \
#         # freetype-dev \
#         # linux-headers \
#         # musl-dev \
#   && pip install --no-cache-dir --upgrade pip \
#   # && pip install tf-models-official --no-deps \
#   && pip install --no-cache-dir -r requirements.txt \
#   && apk del .build-deps
# RUN python3 -m pip install --upgrade https://storage.googleapis.com/tensorflow/mac/gpu/tensorflow-0.12.0-py3-none-any.whl
# RUN python3 -m pip install pybind11
RUN pip install --no-cache-dir --upgrade pip \
  #  && pip install absl-py \
   && pip install --no-cache-dir --no-deps -r requirements.txt \
   && rm -rf /root/.cache

# RUN pip install --upgrade pip \
#  && pip install -r requirements.txt \
#  && rm -rf /root/.cache

# # RUN pip3 install --no-cache-dir -r requirements.txt  

COPY . .

CMD ["python", "inference.py"]







# FROM ubuntu:20.04 AS builder-image

# RUN apt-get update && apt-get install --no-install-recommends -y python3.8 python3.8-dev python3.8-venv python3-pip python3-wheel build-essential && \
#    apt-get clean && rm -rf /var/lib/apt/lists/*

# # create and activate virtual environment
# RUN python3.8 -m venv /opt/venv
# ENV PATH="/opt/venv/bin:$PATH"

# # install requirements
# COPY requirements.txt .
# RUN pip3 install --no-cache-dir -r requirements.txt

# FROM ubuntu:20.04 AS runner-image
# RUN apt-get update && apt-get install --no-install-recommends -y python3.8 python3-venv && \
#    apt-get clean && rm -rf /var/lib/apt/lists/*

# COPY --from=builder-image /opt/venv /opt/venv

# # activate virtual environment
# ENV VIRTUAL_ENV=/opt/venv
# ENV PATH="/opt/venv/bin:$PATH"

# CMD ["python", "inference.py"]




# FROM python:slim AS base

# FROM base as builder

# RUN python -m venv /opt/venv
# ENV PATH="/opt/venv/bin:$PATH"

# #WORKDIR /install
# COPY ./library-dependencies.txt /tmp/library-dependencies.txt
# COPY ./requirements.txt /tmp/requirements.txt
# #ENV PATH="/install:${PATH}"

# RUN buildDeps='build-essential gcc gfortran python3-dev' \
#     && apt-get update \
#     && apt-get install -y $buildDeps --no-install-recommends \
#     && cat /tmp/library-dependencies.txt | egrep -v "^\s*(#|$)" | xargs apt-get install -y \
#     && pip3 install --upgrade pip \
#     && CFLAGS="-g0 -Wl,--strip-all -I/usr/include:/usr/local/include -L/usr/lib:/usr/local/lib" \
#         pip3 install \
# #       --prefix="/install" \
#         --no-cache-dir \
#         --compile \
#         --global-option=build_ext \
#         --global-option="-j 6" \
#         -r /tmp/requirements.txt \
#     && apt-get purge -y --auto-remove $buildDeps \
#     && rm -rf /var/lib/apt/lists/* \
#     && rm -r \
# 	/tmp/requirements.txt \
#         /tmp/library-dependencies.txt

# FROM base
# COPY --from=builder /opt/venv /opt/venv
# COPY ./library-dependencies.txt /tmp/library-dependencies.txt

# RUN apt-get update \
#     && cat /tmp/library-dependencies.txt | egrep -v "^\s*(#|$)" | xargs apt-get install -y \
#     && apt-get install -y libgomp1 --no-install-recommends \
#     && rm -rf /var/lib/apt/lists/*

# ENV PATH="/opt/venv/bin:$PATH"
# ENV BEANCOUNT_FILE ""
# ENV FAVA_OPTIONS ""
# EXPOSE 5000
# CMD fava --host 0.0.0.0 $FAVA_OPTIONS $BEANCOUNT_FILE


# FROM ubuntu:20.04 AS final
# FROM python:3.8-slim-buster
# WORKDIR /app
# COPY . .
# RUN pip install --no-cache-dir --upgrade pip && pip install -r requirements.txt
# CMD ["python", "inference.py"]

# ARG python=python:3.11-slim

# Build stage:
# FROM ubuntu:20.04 AS final
# FROM python:3.9-slim

# WORKDIR /usr/src/app

# RUN apt-get update -y && apt install -y --no-install-recommends \
#     tensorflow \
#     tensorflow_datasets \
#     && rm -rf /var/lib/apt/lists/
# COPY . .

# CMD ["python", "./inference.py"]

# FROM python:3.11-alpine as base

# RUN mkdir /svc
# COPY . /svc
# WORKDIR /svc

# RUN apk add --update \
#     postgresql-dev \
#     gcc \
#     musl-dev \
#     linux-headers

# RUN pip install --no-cache-dir --upgrade pip && pip install wheel && pip wheel . --wheel-dir=/svc/wheels

# FROM python:3.11-alpine

# COPY --from=base /svc /svc

# WORKDIR /svc

# RUN pip install --no-cache-dir --upgrade pip && pip install --no-index --find-links=/svc/wheels -r requirements.txt

# FROM tensorflow/tensorflow:latest

# # Set the working directory inside the container
# WORKDIR /app

# # Copy the Python scripts into the container
# COPY . .

# # Install any necessary dependencies
# RUN pip install --no-cache-dir --disable-pip-version-check \
#     tensorflow_datasets && \
#     rm -rf /root/.cache

# # Set any additional environment variables if needed
# # ENV PYTHONPATH="/app:${PYTHONPATH}"

# # Set up the entry point for the container
# CMD ["python", "inference.py"]

# FROM python:3.7-alpine AS builder
# WORKDIR /app
# RUN python -m venv .venv && .venv/bin/pip install --no-cache-dir -U pip setuptools
# COPY requirements.txt .
# RUN .venv/bin/pip install --no-cache-dir -r requirements.txt && find /app/.venv ( -type d -a -name test -o -name tests \) -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) -exec rm -rf '{}' \+
# WORKDIR /app
# COPY --from=builder /app /app
# COPY . .
# ENV PATH="/app/.venv/bin:$PATH"
# CMD ["python", "inference.py"]

# FROM python:3.11-slim
# WORKDIR /app
# COPY . .
# RUN pip install --no-cache-dir --upgrade pip \
#     && pip install --no-cache-dir -r requirements.txt
# CMD ["python", "inference.py"]

# FROM python:3.11-alpine as base

# RUN mkdir /svc
# COPY . /svc
# WORKDIR /svc

# RUN apk add --update \

#     postgresql-dev \
#     gcc \
#     musl-dev \
#     linux-headers

# RUN pip install wheel && pip wheel . --wheel-dir=/svc/wheels

# FROM python:3.11-alpine

# COPY --from=base /svc /svc

# WORKDIR /svc

# RUN pip install --no-index --find-links=/svc/wheels -r requirements.txt