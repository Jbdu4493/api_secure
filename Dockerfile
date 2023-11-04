FROM ubuntu:20.04
RUN apt-get update; apt-get install python3-pip -y;
ADD . /sources/
RUN pip install -r /sources/requirement.txt
WORKDIR /sources/
EXPOSE 8000
CMD uvicorn api:api --reload --port 8000