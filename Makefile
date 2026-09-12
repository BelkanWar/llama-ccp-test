MODEL="gemma-4-26B"
LLM_URL="https://huggingface.co/google/${MODEL}-A4B-it-qat-q4_0-gguf/resolve/main/${MODEL}_q4_0-it.gguf"
MMPROJ_URL="https://huggingface.co/google/${MODEL}-A4B-it-qat-q4_0-gguf/resolve/main/${MODEL}-it-mmproj.gguf"

download-model ::
	echo ${LLM_URL}
	curl -L -o ./models/${MODEL}.gguf ${LLM_URL}
	curl -L -o ./models/${MODEL}-mmproj.gguf ${MMPROJ_URL}

install-claude-code ::
	# reference: https://code.claude.com/docs/zh-TW/setup
	curl -fsSL https://claude.ai/install.sh | bash
	echo export ANTHROPIC_BASE_URL=http://localhost:8080 >> ~/.bashrc
	echo export ANTHROPIC_API_KEY="not_set" >> ~/.bashrc         # 隨便填入字串作為預留位置
	echo export ANTHROPIC_AUTH_TOKEN="not_set" >> ~/.bashrc       # 隨便填入字串作為預留位置
	# 關鍵優化設定（強烈建議加入，避免本地卡死或噴錯
	echo export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 >> ~/.bashrc # 停用非必要的背景流量
	echo export CLAUDE_CODE_ATTRIBUTION_HEADER=0 >> ~/.bashrc           # 關閉歸屬標頭，避免影響本地解讀
	echo export CLAUDE_CODE_DISABLE_1M_CONTEXT=1 >> ~/.bashrc           # 停用百萬上下文防止記憶體崩潰
	echo "" >> ~/.bashrc

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
