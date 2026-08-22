FROM python:3.10-slim

# Install system dependencies
RUN apt-get update && apt-get install -y supervisor git curl

# Clone OpenF1
RUN git clone https://github.com/br-g/openf1.git /app
WORKDIR /app

# Patch API to allow HEAD requests for UptimeRobot
RUN sed -i 's/"GET", "POST"/"GET", "POST", "HEAD"/g' /app/src/openf1/services/query_api/app.py

# Install OpenF1 dependencies
RUN pip install -e .

# Copy supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose the API port
EXPOSE 10000

# Start supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
