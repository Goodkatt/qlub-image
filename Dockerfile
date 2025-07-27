FROM python:3.11
WORKDIR /usr/src/app
COPY app/ .
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 8080
USER 1000:1000
ENV GUNICORN_CMD_ARGS="--bind=0.0.0.0:8080 --access-logfile -"
CMD ["gunicorn", "app.wsgi:application"]
