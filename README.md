# Hệ thống phát hiện gian lận thẻ tín dụng Real-time 

Project ứng dụng Machine Learning và Data Engineering để phát hiện các giao dịch gian lận thẻ tín dụng theo thời gian thực. 

Vì số lượng giao dịch lừa đảo trong thực tế là rất hiếm, Project này tập trung vào việc xử lý luồng dữ liệu lớn
## Tech stack
Dự án có sự kết hợp của các công nghệ sau:
- **Ngôn ngữ chính:** Python.
- **Machine Learning:** Sử dụng mô hình **XGBoost** để dự đoán, kết hợp với kỹ thuật **SMOTE** (thư viện imbalanced-learn) để tạo thêm dữ liệu giả cho nhóm lừa đảo.
- **Quản lý dữ liệu (Data Engineering):** 
  - **Kafka (Confluent Cloud):** Đóng vai trò là hệ thống truyền dữ liệu streaming.
  - **PySpark:** Hứng dữ liệu từ Kafka và dùng model để dự đoán trực tiếp.
  - **Apache Airflow:** Lập lịch để tự động hóa quá trình huấn luyện (train) model.
  - **MLflow:** Ghi lại các chỉ số đánh giá (F1, Precision...) và lưu trữ model.
  - **Docker Compose:** Đóng gói và khởi chạy toàn bộ hệ thống một cách nhanh chóng.

## Hướng dẫn cài đặt và chạy hệ thống

### Bước 1: Cấu hình Kafka
Tạo một file tên là `.env` ở trong thư mục `src/` và điền thông tin kết nối Kafka vào:
'env'
KAFKA_BOOTSTRAP_SERVERS=xxx
KAFKA_SECURITY_PROTOCOL=SASL_SSL
KAFKA_SASL_MECHANISM=PLAIN
KAFKA_SASL_JAAS_CONFIG=org.apache.kafka.common.security.plain.PlainLoginModule required username="..." password="...";

Bước 2: Khởi động hệ thống và Train model
Mở terminal ở thư mục src/ và chạy lệnh sau để bật các dịch vụ Docker:


docker compose up -d
Mở trình duyệt, truy cập vào trang quản lý Airflow: http://localhost:8080
Trigger DAG có tên fraud_detection_training. Lúc này hệ thống sẽ tự động tải dữ liệu về và bắt đầu train model.
Có thể xem chi tiết điểm số của model trên trang MLflow tại địa chỉ: http://localhost:5500.
Bước 3: Real-time Inference
Khi model đã train xong, tiến hành bật Producer và công cụ dự đoán Inference


# Bật bộ dự đoán
docker compose up --force-recreate -d inference
# Bật bộ tạo giao dịch giả lập liên tục
docker compose up -d producer
Truy cập vào topic fraud_predictions sẽ thấy các giao dịch bị mô hình đánh giá là lừa đảo (chứa nhãn "prediction": 1) xuất hiện liên tục theo thời gian thực.

# Kết quả đạt được
Tỷ lệ gian lận chỉ khoảng 0.34%
Precision đạt mức 89.4%
