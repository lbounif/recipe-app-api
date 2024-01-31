FROM python:3.9-alpine3.13
LABEL maintainer="mississaugaappdeveloper.com"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
# create a new virtual env for dependencies:python -m venv /py
RUN python -m venv /py && \ 
    /py/bin/pip install --upgrade pip && \
    # install our requirements
    /py/bin/pip install -r /tmp/requirements.txt && \
    # Install dev dependencices if dev=true
    if [ $DEV= "true"]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    # remove all dependencies we don't need
    rm -rf /tmp && \
    #use a user different from root user
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# update the env variable inside the image
ENV PATH="/py/bin:$PATH"

#specify a user we are switching to
USER django-user