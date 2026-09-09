MODEL="gemma-4-26B-A4B-it"
VERSION="${MODEL}-UD-Q4_K_M.gguf"
URL="https://huggingface.co/unsloth/${MODEL}-GGUF/resolve/main/${VERSION}"

download-model ::
	curl -L -o ./models/${VERSION} ${URL}

model-up-cpu ::
	docker run --rm -v ./models:/models -p 8080:8080 ghcr.io/ggml-org/llama.cpp:server-cuda13 -m /models/${VERSION} --ctx-size 32768 

model-up ::
	docker run --rm --gpus all -v ./models:/models -p 8080:8080 ghcr.io/ggml-org/llama.cpp:server-cuda13 -m /models/${VERSION} --ctx-size 32768 