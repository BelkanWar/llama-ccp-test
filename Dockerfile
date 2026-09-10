FROM python:3.12.8-slim-bookworm AS base
WORKDIR /workspace

RUN apt update  && \
    apt install -y apt-utils build-essential && \
    apt install -y curl git && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean

RUN pip install --upgrade pip

# clone & install llama.cpp
RUN git clone https://github.com/ggml-org/llama.cpp.git
RUN pip install -r ./llama.cpp/requirements.txt

CMD  ["/bin/sh", "-ec", "sleep infinity"]