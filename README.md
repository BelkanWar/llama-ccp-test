# llama-cpp-test

這個專案旨在提供一個用於測試 Gemma 4 模型（GGUF 格式）的環境。它包含自動化下載模型、使用 Docker 啟動 `llama.cpp` 伺服器，以及配置 Claude Code 以連接到本地 LLM 伺服器的腳本。

## 功能特性

- **模型下載**: 自動從 Hugging Face 下載 Unsloth 優化過的 Gemma 4 GGUF 模型。
- **快速啟動伺服器**: 使用 Docker 快速部署 `llama.cpp` 伺服器（支援 CPU 與 GPU）。
- **Claude Code 集成**: 提供一鍵設定環境變數，讓 Claude Code 可以透過本地伺服器運作。
- **Python 測試**: 提供簡單的範例腳本使用 `llama-cpp-python` 進行測試。

## 前置需求

- [Docker](https://www.docker.com/)
- [Python 3.12+](https://www.python.org/)
- [uv](https://github.com/astral-sh/uv) (推薦用於 Python 環境管理)
- NVIDIA GPU (若要使用 `model-up` 進行 GPU 加速)

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

如果你想讓 Claude Code 使用這個本地伺服器，請執行以下指令來設定環境變數。這會修改你的 `~/.bashrc`：

```bash
make install-claude-code
```

*注意：執行後請重啟終端機或執行 `source ~/.bashrc` 以使設定生效。*

### 4. 執行 Python 測試

你可以使用 `llama-cpp-python` 進行簡單的本地測試：

```bash
# 使用 uv 執行測試
uv run test.py
```

## 專案結構

- `models/`: 存放下載的 `.gguf` 模型檔案。
- `test.py`: 使用 `llama-cpp-python` 的測試範例。
- `Makefile`: 提供模型下載、伺服器啟動與環境配置的指令。
- `pyproject.toml`: Python 專案定義與依賴管理。

## 模型資訊

本專案目前預設使用：
- **模型名稱**: `gemma-4-26B-A4B-it`
- **量化格式**: `Q4_K_M`
- **來源**: [Unsloth Hugging Face](https://huggingface.co/unsloth)

## 手動轉換模型成gguf格式
1. clone模型檔
2. 執行`make build`，建立轉換所需的docker image
3. 啟動container，並將來源模型檔和儲存完成檔案的資料夾都掛進容器
    ```bash
    docker run -itd --rm --name converter -v ./models:/workspace/models -v [模型檔資料夾]:/workspace/source converter:last
    ```
4. 進到容器內，執行轉換腳本
    ```bash
    python3 llama.cpp/convert_hf_to_gguf.py ./source/ --outfile models/[完成的gguf檔名] --outtype q8_0
    ```