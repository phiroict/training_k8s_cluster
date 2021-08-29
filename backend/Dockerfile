FROM python:2-alpine3.9
RUN mkdir -p /src
RUN pip install flask requests
WORKDIR /src
ADD listener.py listener.py
CMD python listener.py