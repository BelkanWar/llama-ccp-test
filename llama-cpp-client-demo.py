import base64
from openai import OpenAI

def encode_image(image_path):
    """Converts an image to a base64 encoded string."""
    with open(image_path, "rb") as image_file:
        result = f"data:image/jpeg;base64,{base64.b64encode(image_file.read()).decode('utf-8')}"
    return result


client = OpenAI(
    base_url="http://localhost:8080/v1",
    api_key="not-needed",
)

response = client.chat.completions.create(
    model="gemma-4",
    messages=[
        {
            "role": "user",
            "content": [
                {"type": "text", "text": "輸出圖片中的文字"},
                {"type": "image_url", "image_url": {"url": encode_image("/home/belkanwar/Downloads/PXL_20260625_013230826.jpg")}}
            ]
        }
    ]
)

print(response.choices[0].message.content)
client.close()