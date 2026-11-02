FROM python:3.11-slim

WORKDIR /scraper
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

ENTRYPOINT ["python3", "scraper.py"]
