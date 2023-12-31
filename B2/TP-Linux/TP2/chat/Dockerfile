FROM python:3.11.7
LABEL authors="ahliko"

RUN pip install --upgrade pip
RUN pip install colorlog
RUN pip install redis
RUN pip install websockets

WORKDIR /app
COPY chat.py /app

ENTRYPOINT ["python3", "chat.py"]