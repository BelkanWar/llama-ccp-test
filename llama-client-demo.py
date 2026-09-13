import base64
from llama_cpp import Llama
# claude --resume 64921ba8-d32a-440f-9ca3-4dae1fe81bf0
def encode_image(image_path):
    """Converts an image to a base64 encoded string."""
    with open(image_path, "rb") as image_file:
        result = f"data:image/jpeg;base64,{base64.b64encode(image_file.read()).decode('utf-8')}"
    return result

llm = Llama(
    model_path="./models/gemma-4-E4B.gguf",
    clip_model_path="./models/gemma-4-E4B-mmproj.gguf",
    n_ctx=65536,
    n_gpu_layers=-1,  # 0 代表全部load在system ram, -1 表示全部層load到GPU
    logits_all=True
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

# def query(prompt:str, image_path:str):
#     output = llm.create_chat_completion(
#         messages=[
#             {
#                 "role": "user",
#                 "content": [
#                     {"type": "text", "text": prompt},
#                     {"type": "image_url", "image_url": {"url": encode_image(image_path)}}
#                 ]
#             }
#         ]
#     )
#     return output['choices'][0]['message']['content']

# print(query("這張圖片裡有什麼？", "/home/belkanwar/Downloads/PXL_20260625_013230826.jpg"))