#!/bin/bash
set -e

echo "=== MongoDB Database Restoration Script ==="
echo "Target database: ${MONGO_INITDB_DATABASE}"
echo "Dump location: /docker-entrypoint-initdb.d/dump/"

# Wait for MongoDB to be ready
echo "Waiting for MongoDB to accept connections..."
for i in {1..60}; do
    if mongosh --eval "db.adminCommand('ping')" --quiet > /dev/null 2>&1; then
        echo "✅ MongoDB is ready (using mongosh)"
        MONGO_SHELL="mongosh"
        break
    elif mongo --eval "db.adminCommand('ping')" --quiet > /dev/null 2>&1; then
        echo "✅ MongoDB is ready (using mongo)"
        MONGO_SHELL="mongo"
        break
    fi
    echo "Waiting for MongoDB... (attempt $i/60)"
    sleep 2
done

if [ -z "$MONGO_SHELL" ]; then
    echo "❌ MongoDB failed to start after 2 minutes"
    exit 1
fi

# Check if dump directory exists
if [ ! -d "/docker-entrypoint-initdb.d/dump" ]; then
    echo "❌ Dump directory not found"
    exit 1
fi

echo "📁 Dump contents:"
ls -la /docker-entrypoint-initdb.d/dump/

# Restore the database
echo "🔄 Restoring database: ${MONGO_INITDB_DATABASE}"
mongorestore --db "${MONGO_INITDB_DATABASE}" /docker-entrypoint-initdb.d/dump/

if [ $? -eq 0 ]; then
    echo "✅ Database restoration completed successfully!"
    
    # Verify restoration
    echo "🔍 Verification:"
    $MONGO_SHELL --eval "show dbs" --quiet
    $MONGO_SHELL "${MONGO_INITDB_DATABASE}" --eval "show collections" --quiet
    
    # Show document counts for key collections
    echo "📊 Collection statistics:"
    $MONGO_SHELL "${MONGO_INITDB_DATABASE}" --eval "db.runs.countDocuments({})" --quiet | sed 's/^/  runs: /'
    $MONGO_SHELL "${MONGO_INITDB_DATABASE}" --eval "db.metrics.countDocuments({})" --quiet | sed 's/^/  metrics: /' 2>/dev/null || echo "  metrics: (collection not found)"
    
else
    echo "❌ Database restoration failed!"
    exit 1
fi
