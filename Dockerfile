FROM python:latest

RUN apt update
RUN apt -y upgrade
RUN pip install twisted
WORKDIR /usr/web2py
COPY ./web2py .


