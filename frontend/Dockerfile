FROM python:2-alpine3.9
RUN mkdir -p /src && pip install --no-cache-dir flask==2.0.1 requests==2.26.0
WORKDIR /src
COPY listener.py listener.py
CMD ["python", "listener.py"]