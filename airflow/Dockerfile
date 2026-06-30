FROM apache/airflow:2.10.5

#create models dir and set ownership
USER root
RUN mkdir -p /app/models

USER airflow

#copy requirements file
COPY requirements.txt /tmp/requirements.txt

#Install Python packages && root (system-wide)
RUN pip install -r /tmp/requirements.txt
#switch back to airflow user for safety
USER airflow