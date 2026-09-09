MODEL="gemma-4-E4B-it-Q5_K_M.gguf"
URL="https://huggingface.co/unsloth/gemma-4-E4B-it-GGUF/resolve/main/${MODEL}"

download-model ::
	curl -L -o ./models/${MODEL} ${URL}

install-claude-code ::
	# reference: https://code.claude.com/docs/zh-TW/setup
	curl -fsSL https://claude.ai/install.sh | bash
	echo export ANTHROPIC_BASE_URL=http://localhost:8080
	echo export ANTHROPIC_API_KEY="not_set" >> ~/.bashrc         # 隨便填入字串作為預留位置
	echo export ANTHROPIC_AUTH_TOKEN="not_set" >> ~/.bashrc       # 隨便填入字串作為預留位置
	# 關鍵優化設定（強烈建議加入，避免本地卡死或噴錯）>> ~/.bashrc
	echo export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 >> ~/.bashrc # 停用非必要的背景流量
	echo export CLAUDE_CODE_ATTRIBUTION_HEADER=0 >> ~/.bashrc           # 關閉歸屬標頭，避免影響本地解讀
	echo export CLAUDE_CODE_DISABLE_1M_CONTEXT=1 >> ~/.bashrc           # 停用百萬上下文防止記憶體崩潰
	echo "" >> ~/.bashrc

model-up ::
	docker run --rm -v ./models:/models -p 8080:8080 ghcr.io/ggml-org/llama.cpp:server-cuda13 -m /models/${MODEL}

model-up-gpu ::
	docker run --rm --gpus all -v ./models:/models -p 8080:8080 ghcr.io/ggml-org/llama.cpp:server-cuda13 -m /models/${MODEL}