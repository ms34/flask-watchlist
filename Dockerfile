# syntax=docker/dockerfile:1.4
FROM --platform=$BUILDPLATFORM python:3.10-alpine

# set the working directory
WORKDIR /app

# set environmental variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install the requirements
COPY requirements.txt /app
RUN --mount=type=cache,target=/root/.cache/pip \
    pip3 install -r requirements.txt

# copy the code to the container
COPY . .

# initialize the database (create DB, tables, populate)
RUN python init_db.py

# expose
EXPOSE 5000/tcp

# entrypoint command
CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:5000", "app:app"]