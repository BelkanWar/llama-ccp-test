# llama-cpp-test

這個專案旨在提供一個用於測試 Gemma 4 模型（GGUF 格式）的環境。它包含自動化下載模型、使用 Docker 啟動 `llama.cpp` 伺服器，以及配置 Claude Code 以連接到本地 LLM 伺服器的腳本。

## 功能特性

- **模型下載**: 自動從 Hugging Face 下載優化過的 Gemma 4 GGUF 模型。
- **快速啟動伺服器**: 使用 Docker 快速部署 `llama.cpp` 伺服器（支援 CPU 與 GPU），支援多模態（Vision）功能。
- **Claude Code 集成**: 提供一鍵設定環境變數，讓 Claude Code 可以透過本地伺服器（OpenAI-compatible API）運作。
- **Python 測試**: 提供兩種測試範例：使用 OpenAI SDK 連接伺服器，以及直接使用 `llama-cpp-python` 加載模型。

## 前置需求

- [Docker](https://www.docker.com/)
- [Python 3.12+](https://www.python.org/)
- [uv](https://github.com/astral-sh/uv) (推薦用於 Python 環境管理)
- NVIDIA GPU (若要使用 `make model-up` 進行 GPU 加速)

## 開始使用

### 1. 下載模型

首先，下載 Gemma 4 模型：

```bash
make download-model
```

### 2. 啟動模型伺服器

你可以選擇使用 CPU 或 GPU 來啟動 `llama.cpp` 伺服器。伺服器預設運行在 `http://localhost:8080`。

**使用 CPU 啟動:**

```bash
make model-up-cpu
```

**使用 GPU 啟動 (需安裝 NVIDIA Container Toolkit):**

```bash
make model-up
```

### 3. 配置 Claude Code

如果你想讓 opencode 使用這個本地伺服器，請執行以下指令來安裝和設定

```bash
make install-opencode
make config-opencode
```

*注意：執行後請重啟終端機或執行 `source ~/.bashrc` 以使設定生效。*

### 4. 執行 Python 測試

你可以使用以下兩種方式進行測試：

**方式 A：透過 API 連接伺服器 (需先啟動伺服器)**

```bash
uv run llama-cpp-client-demo.py
```

**方式 B：直接使用 `llama-cpp-python` 加載本地模型 (無需伺服器)**

```bash
uv run llama-cpp-python-demo.py
```

## 專案結構

- `models/`: 存放下載的 `.gguf` 模型檔案與視覺模型 (`mmproj`)。
- `llama-cpp-client-demo.py`: 使用 OpenAI 協議測試伺服器端 (API) 的範例。
- `llama-cpp-python-demo.py`: 使用 `llama-cpp-python` 直接在 Python 中載入模型的範例。
- `Dockerfile`: 用於建立模型轉換環境的 Dockerfile。
- `Makefile`: 提供模型下載、伺服器啟動與環境配置的指令。
- `pyproject.toml`: Python 專案定義與依賴管理。

## 模型資訊

本專案目前預設使用：
- **模型名稱**: `gemma-4-26B`
- **量化格式**: `Q4_K_M` (由 `Makefile` 控制)
- **來源**: [Hugging Face](https://huggingface.co/google/gemma-4-26B-A4B-it-qat-q4_0-gguf)

## 手動轉換模型成 GGUF 格式

若你需要將 Hugging Face 格式的模型轉換為 GGUF 格式，可以按照以下步驟操作：

1. **建立轉換環境**:
   ```bash
   make build
   ```

2. **啟動轉換容器**:
   將你的 Hugging Face 模型資料夾掛載到容器的 `/workspace/source` 中：
   ```bash
   docker run -itd --rm \
     --name converter \
     -v $(pwd)/models:/workspace/models \
     -v /path/to/your/hf_model_folder:/workspace/source \
     converter:last
   ```

3. **執行轉換腳本**:
   進入容器並執行轉換指令（例如轉換為 `q8_0` 格式）：
   ```bash
   docker exec -it converter python3 llama.cpp/convert_hf_to_gguf.py \
     ./source/ \
     --outfile /workspace/models/[完成的檔名].gguf \
     --outtype q8_0
   ```
