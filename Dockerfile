# MongoDB with Pre-loaded Sacred Experiment Data
FROM mongo:7.0

# Set environment variables
ARG DB_NAME=${DB_NAME}

ENV MONGO_INITDB_DATABASE=${DB_NAME}

# Create directory for database dump
RUN mkdir -p /docker-entrypoint-initdb.d/dump

# Copy the database dump files
COPY dump-folder/${DB_NAME}/ /docker-entrypoint-initdb.d/dump/

# Copy initialization script
COPY scripts/restore-database.sh /docker-entrypoint-initdb.d/01-restore-database.sh

# Make script executable
RUN chmod +x /docker-entrypoint-initdb.d/01-restore-database.sh

# Expose MongoDB port
EXPOSE 27017

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD mongosh --eval "db.adminCommand('ping')" --quiet || mongo --eval "db.adminCommand('ping')" --quiet
