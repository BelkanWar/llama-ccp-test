import os
import subprocess
from llama_cpp import Llama

if os.path.exists(".models/gemma-4-E4B-it-Q5_K_M.gguf") == False:
    subprocess.run(["curl",  "-L",  "-O",  "https://huggingface.co/unsloth/gemma-4-E4B-it-GGUF/resolve/main/gemma-4-E4B-it-Q5_K_M.gguf"])

llm = Llama(
    model_path="./models/gemma-4-E4B-it-Q5_K_M.gguf",
    n_ctx=4096,
    n_gpu_layers=0  # -1 表示全部層卸載到 GPU
)

output = llm("你能告訴我這個專案的結構嗎？", max_tokens=256)
print(output['choices'][0]['text'])