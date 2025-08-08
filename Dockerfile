# MongoDB with Pre-loaded Sacred Experiment Data
FROM mongo:7.0

# Set environment variables
ARG DB_NAME=workshop_data

ENV MONGO_INITDB_DATABASE=${DB_NAME}

# Copy the database dump files directly to init directory
COPY dump-folder/ /docker-entrypoint-initdb.d/

# Copy initialization script
COPY scripts/restore-database.sh /docker-entrypoint-initdb.d/01-restore-database.sh

# Make script executable
RUN chmod +x /docker-entrypoint-initdb.d/01-restore-database.sh



# Expose MongoDB port
EXPOSE 27017

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD mongosh --eval "db.adminCommand('ping')" --quiet || mongo --eval "db.adminCommand('ping')" --quiet
