FROM python:latest

WORKDIR /app

COPY . .

CMD ["python3", "./app.py"]
