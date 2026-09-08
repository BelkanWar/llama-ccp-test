MODEL="gemma-4-E4B-it-Q5_K_M.gguf"
URL="https://huggingface.co/unsloth/gemma-4-E4B-it-GGUF/resolve/main/${MODEL}"

download-model ::
	curl -L -o ./models/${MODEL} ${URL}

container-up ::
	docker run --rm -v ./models:/models -p 8080:8080 ghcr.io/ggml-org/llama.cpp:server-cuda13 -m /models/${MODEL}

container-up-gpu ::
	docker run --rm --gpus all -v ./models:/models -p 8080:8080 ghcr.io/ggml-org/llama.cpp:server-cuda13 -m /models/${MODEL}