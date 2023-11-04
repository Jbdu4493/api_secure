FROM ubuntu:20.04
RUN apt-get update; apt-get install python3-pip -y
RUN apt-get install uvicorn -y
ADD . /sources/
RUN pip install -r /sources/requirement.txt
WORKDIR /sources/
EXPOSE 8000
CMD uvicorn api:api --reload --port 8000 --host 0.0.0.0