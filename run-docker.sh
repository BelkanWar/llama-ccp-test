#!/bin/sh
docker run --rm --gpus all -v ./models:/models -p 8080:8080 ghcr.io/ggml-org/llama.cpp:server-cuda13 -m /models/gemma-4-E4B-it-Q5_K_M.gguf