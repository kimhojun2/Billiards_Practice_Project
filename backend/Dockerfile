FROM python:3.10.0

#RUN apt-get update && apt-get install -y python3-pip && apt-get clean


WORKDIR /A202/
COPY . /A202/
RUN python -m pip install --upgrade pip
RUN pip3 install -r requirements.txt
RUN pip install gunicorn
COPY .env /A202/
#RUN python3 manage.py collectstatic --noinput

