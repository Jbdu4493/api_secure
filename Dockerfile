FROM ubuntu:20.04
<<<<<<< HEAD
RUN apt-get update; apt-get install python3-pip uvicorn -y
;
=======
RUN apt-get update; apt-get install python3-pip -y
RUN apt-get install uvicorn -y
>>>>>>> ad4d92055ea79096351791709b06d5c4c95d945c
ADD . /sources/
RUN pip install -r /sources/requirement.txt
WORKDIR /sources/
EXPOSE 8000
<<<<<<< HEAD
CMD uvicorn api:api --reload --port 8000
=======
CMD uvicorn api:api --reload --port 8000 --host 0.0.0.0
>>>>>>> ad4d92055ea79096351791709b06d5c4c95d945c
