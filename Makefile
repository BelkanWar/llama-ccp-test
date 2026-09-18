MODEL_TYPE ?= large

ifeq ($(MODEL_TYPE),small)
	MODEL = gemma-4-E4B
	LLM_URL = https://huggingface.co/google/gemma-4-E4B-it-qat-q4_0-gguf/resolve/main/gemma-4-E4B_q4_0-it.gguf
	MMPROJ_URL = https://huggingface.co/google/gemma-4-E4B-it-qat-q4_0-gguf/resolve/main/gemma-4-E4B-it-mmproj.gguf
else
	MODEL = gemma-4-26B
	LLM_URL = https://huggingface.co/google/gemma-4-26B-A4B-it-qat-q4_0-gguf/resolve/main/gemma-4-26B_q4_0-it.gguf
	MMPROJ_URL = https://huggingface.co/google/gemma-4-26B-A4B-it-qat-q4_0-gguf/resolve/main/gemma-4-26B-it-mmproj.gguf
endif

download-model ::
	echo ${LLM_URL}
	curl -L -o ./models/${MODEL}.gguf ${LLM_URL}
	curl -L -o ./models/${MODEL}-mmproj.gguf ${MMPROJ_URL}

define OPENCODE_CONFIG
{
  "$$schema": "https://opencode.ai/config.json",
  "provider": {
    "local": {
      "options": {
        "baseURL": "http://localhost:8080",
        "apiKey": "sk-dummy"
      },
      "models": {
        "gemma-4": {
          "attachment": true,
          "modalities": {
            "input": ["text", "image"]
          }
        }
      }
    }
  },
  "model": "local/gemma-4"
}

endef

install-opencode ::
	curl -fsSL https://opencode.ai/install | bash
	mkdir -p /home/${USER}/.config/opencode/

config-opencode :: 
	$(file > /home/${USER}/.config/opencode/opencode.json,$(OPENCODE_CONFIG))

model-up-cpu ::
	docker run -itd --rm \
	--name llama \
	-v ./models:/models \
	-p 8080:8080 \
	ghcr.io/ggml-org/llama.cpp:server-cuda13 \
	-m /models/${MODEL}.gguf \
	--mmproj /models/${MODEL}-mmproj.gguf \
	--jinja \
	--chat-template-file /models/google-gemma-4-31B-it-interleaved.jinja \
	--chat-template-kwargs '{"enable_thinking":true}' \
	--ctx-size 65536 \
	--ubatch-size 2048 \

model-up ::
	docker run -itd --rm \
	--name llama \
	--gpus all \
	-v ./models:/models \
	-p 8080:8080 \
	ghcr.io/ggml-org/llama.cpp:server-cuda13 \
	-m /models/${MODEL}.gguf \
	--mmproj /models/${MODEL}-mmproj.gguf \
	--jinja \
	--chat-template-file /models/google-gemma-4-31B-it-interleaved.jinja \
	--chat-template-kwargs '{"enable_thinking":true}' \
	--ctx-size 65536 \
	--ubatch-size 2048 \

build ::
	docker build -f Dockerfile -t converter:last . 
