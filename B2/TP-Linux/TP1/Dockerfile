FROM debian

RUN apt update -y
RUN apt install python3 -y
RUN apt install python3-pip -y

RUN pip install emoji --break-system-packages

WORKDIR /app
COPY app.py /app/app.py

ENTRYPOINT ["python3", "app.py"]