import base64
from llama_cpp import Llama
from llama_cpp.llama_chat_format import Gemma4ChatHandler

def encode_image(image_path):
    """Converts an image to a base64 encoded string."""
    with open(image_path, "rb") as image_file:
        result = f"data:image/jpeg;base64,{base64.b64encode(image_file.read()).decode('utf-8')}"
    return result

llm = Llama(
    model_path="./models/gemma-4-E4B.gguf",
    chat_handler=Gemma4ChatHandler(clip_model_path="./models/gemma-4-E4B-mmproj.gguf"),
    n_ctx=65536,
    n_gpu_layers=0,
    logits_all=True,
    verbose=False
)

output = llm.create_chat_completion(
    messages=[
        {
            "role": "user",
            "content": [
                {"type": "text", "text": "這張圖片裡有什麼？"},
                {"type": "image_url", "image_url": {"url": encode_image("/home/belkanwar/Downloads/PXL_20260625_013230826.jpg")}}
            ]
        }
    ]
)

print(output['choices'][0]['message']['content'])
llm.close()
