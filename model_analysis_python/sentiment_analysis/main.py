import numpy as np
import tensorflow as tf
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing.text import Tokenizer
from tensorflow.keras.preprocessing.sequence import pad_sequences
from pyvi import ViTokenizer
from typing import List, Dict
import json
import sys
import os

def read_comments_from_file(file_path: str) -> List[str]:
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return [line.strip() for line in f if line.strip()]
    except Exception as e:
        print(f"Lỗi khi đọc file: {e}")
        return []

def save_results_to_json(results: Dict[str, int], output_path: str):
    try:
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(results, f, indent=2, ensure_ascii=False)
        print(f"\nĐã lưu kết quả vào file: {output_path}")
    except Exception as e:
        print(f"Lỗi khi lưu file: {e}")

def analyze_comments(comments: List[str]) -> Dict[str, int]:
    try:
        # Load both models
        sentiment_model = load_model('D:\sentiment_analysis\model_cnn_bilstm (3).keras')
        spam_model = load_model('D:\sentiment_analysis\model_cnn_bilstm_spam.keras')
        print("Đã tải mô hình thành công!")
    except Exception as e:
        print(f"Lỗi khi tải mô hình: {e}")
        print("Hãy đảm bảo tệp mô hình tồn tại và đường dẫn đúng.")
        return {}

    # Define labels
    label_data = {"Tích cực": 1, "Trung tính": 0, "Tiêu cực": 2}
    maxlen = 60

    processed_comments = []
    for comment in comments:
        processed_comment = ViTokenizer.tokenize(comment)
        processed_comments.append(processed_comment)

    # Initialize tokenizer
    tokenizer = Tokenizer()
    tokenizer.fit_on_texts(processed_comments)
    
    try:
        # Convert to sequences and pad
        comment_sequences = tokenizer.texts_to_sequences(processed_comments)
        comment_padded = pad_sequences(comment_sequences, maxlen=maxlen, padding="post")

        # Get predictions from both models
        sentiment_predictions = sentiment_model.predict(comment_padded)
        spam_predictions = spam_model.predict(comment_padded)

        # Get predicted classes
        sentiment_classes = np.argmax(sentiment_predictions, axis=1)
        spam_classes = np.argmax(spam_predictions, axis=1)

        # Initialize counters
        results = {
            "spam_count": int(np.sum(spam_classes == 1)),
            "positive_spam": 0,
            "neutral_spam": 0,
            "negative_spam": 0,
            "positive_not_spam": 0,
            "neutral_not_spam": 0,
            "negative_not_spam": 0
        }

        # Count sentiments for spam and non-spam comments
        for i in range(len(comments)):
            sentiment = sentiment_classes[i]
            is_spam = spam_classes[i]
            
            if is_spam:
                if sentiment == 1:  # Positive
                    results["positive_spam"] += 1
                elif sentiment == 0:  # Neutral
                    results["neutral_spam"] += 1
                else:  # Negative
                    results["negative_spam"] += 1
            else:
                if sentiment == 1:  # Positive
                    results["positive_not_spam"] += 1
                elif sentiment == 0:  # Neutral
                    results["neutral_not_spam"] += 1
                else:  # Negative
                    results["negative_not_spam"] += 1

        return results

    except Exception as e:
        print(f"Lỗi trong quá trình xử lý: {e}")
        return {}

def main():
    if len(sys.argv) != 3:
        print("Sử dụng: python main.py <đường_dẫn_file_comments> <đường_dẫn_file_output>")
        print("Ví dụ: python main.py comments.txt results.json")
        return

    input_path = sys.argv[1]
    output_path = sys.argv[2]

    # Kiểm tra file input
    if not os.path.exists(input_path):
        print(f"Không tìm thấy file input: {input_path}")
        return

    # Đọc comments từ file
    comments = read_comments_from_file(input_path)
    
    if not comments:
        print("Không có comments nào để phân tích.")
        return
        
    # Phân tích comments
    results = analyze_comments(comments)
    
    if results:
        # Hiển thị kết quả
        print("\nKết quả phân tích:")
        print("-" * 30)
        print(json.dumps(results, indent=2, ensure_ascii=False))
        
        # Lưu kết quả vào file
        save_results_to_json(results, output_path)

if __name__ == "__main__":
    main()
