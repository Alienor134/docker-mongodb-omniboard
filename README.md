# Sacred MongoDB Docker Environment

A containerized MongoDB environm├── 📁 scripts/                # Database initialization scripts
│   ├── restore-database.sh    # Automatic restoration script (used in Dockerfile)
│   └── init-restore.sh        # Additional initialization
├── 🔄 mongo_dump_restore.bat  # Atlas sync script (requires environment variables)
├── 📱 omniboard_fast_start.bat # Local Omniboard (non-Docker, requires conda)
└── 📄 README.md               # This documentation-loaded with Sacred experiment data, featuring Omniboard web interface for experiment visualization.

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose installed
- Windows with PowerShell (for batch scripts)

### 1. Start the Environment
```bash
# Start with Docker Compose
docker-compose up -d
```

### 2. Access Omniboard Web Interface

#### **For Localhost Access:**
```
http://localhost:9004
```

#### **For Network Access (Other WiFi Users):**
1. **Find your machine's IP address:**
   ```cmd
   ipconfig | findstr "IPv4"
   ```
   Look for your WiFi adapter IP (usually starts with 192.168.x.x or 10.x.x.x)

2. **Share this address with network users:**
   ```
   http://YOUR_MACHINE_IP:9004
   ```
   Example: `http://192.168.1.100:9004`

## � Database Access

### **MongoDB Connection Details:**

| Access Type | Address | Port | Database |
|-------------|---------|------|----------|
| **Localhost** | `localhost` | `27018` | `workshop_data` |
| **Network** | `YOUR_MACHINE_IP` | `27018` | `workshop_data` |

### **Connection Strings:**
```bash
# Localhost
mongodb://localhost:27018/workshop_data

# Network access
mongodb://YOUR_MACHINE_IP:27018/workshop_data
```

## 🛠️ Management Scripts

| Script | Description |
|--------|-------------|
| `mongo_dump_restore.bat` | Sync with MongoDB Atlas (requires environment variables) |
| `omniboard_fast_start.bat` | Start Omniboard locally (non-Docker, requires conda) |

## 📁 Project Structure

```
docker-mongodb-omniboard/
├── 📄 config.env              # Configuration (database name, ports)
├── 🐳 docker-compose.yml      # Main orchestration file (MongoDB + Omniboard)
├── 🐳 Dockerfile              # MongoDB image with pre-loaded Sacred data
├── 📁 dump-folder/            # Database dumps
│   ├── workshop_data/         # Current Sacred experiment data
│   └── test_data_new/         # Alternative dataset
├── 📁 scripts/                # Database initialization scripts
│   ├── restore-database.sh    # Automatic restoration script (used in Dockerfile)
│   └── init-restore.sh        # Additional initialization
├── ⚙️ manage.bat              # Interactive Docker management interface
├── 🔄 mongo_dump_restore.bat  # Atlas sync script (requires environment variables)
├── 📱 omniboard_fast_start.bat # Local Omniboard (non-Docker, requires conda)
└── � README.md               # This documentation
```

## 🔧 Configuration

All settings are managed in `config.env`:

```env
# Database name (current: workshop_data)
DB_NAME=workshop_data

# Host ports (what users connect to)
MONGO_PORT_HOST=27018      # MongoDB access port
OMNIBOARD_PORT_HOST=9004   # Omniboard web interface port

# Docker internal ports (usually don't change)
MONGO_PORT_DOCKER=27017
OMNIBOARD_PORT_DOCKER=9000

# Atlas credentials (for mongo_dump_restore.bat)
# Set as environment variables, not in config.env:
# ATLAS_USER=your_username
# ATLAS_PASSWORD=your_password
# ATLAS_URL=your_cluster_url
```

## 🌐 Network Access Setup

### **For the Host Machine Owner:**

1. **Check Windows Firewall:**
   - Allow Docker Desktop through Windows Firewall
   - Ensure ports 9004 and 27018 are accessible

2. **Find Your IP Address:**
   ```cmd
   ipconfig | findstr "IPv4"
   ```

3. **Share with Network Users:**
   - Omniboard: `http://YOUR_IP:9004`
   - MongoDB: `mongodb://YOUR_IP:27018/workshop_data`

### **For Network Users:**

1. **Web Access (Recommended):**
   - Open browser and go to: `http://HOST_MACHINE_IP:9004`
   - No additional software needed

2. **Direct MongoDB Access:**
   - Use MongoDB tools with: `mongodb://HOST_MACHINE_IP:27018/workshop_data`
   - Examples: MongoDB Compass, Studio 3T, mongosh

## 🔍 Troubleshooting

### **Can't Access from Network:**
1. **Check if services are running:**
   ```cmd
   docker-compose ps
   ```

2. **Test localhost first:**
   ```
   http://localhost:9004
   ```

3. **Check Windows Firewall:**
   - Windows Security → Firewall & network protection
   - Allow Docker Desktop and ports 9004, 27018

4. **Router Settings:**
   - Ensure "Client Isolation" is disabled
   - Check if router blocks inter-device communication

### **Services Won't Start:**
1. **Check Docker is running:**
   ```cmd
   docker --version
   ```

2. **View logs:**
   ```cmd
   docker-compose logs
   ```

3. **Restart everything:**
   ```cmd
   docker-compose down
   docker-compose up -d
   ```

## 🎯 Docker Operations

### **Start Services:**
```cmd
docker-compose up -d
```

### **Stop Services:**
```cmd
docker-compose down
```

### **View Logs:**
```cmd
docker-compose logs
docker-compose logs mongodb
docker-compose logs omniboard
```

### **Rebuild (after configuration changes):**
```cmd
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

## 📁 Data Management

### **Backup Current Data:**
```cmd
docker exec mongodb-sacred mongodump --db=workshop_data --out=/tmp/backup
docker cp mongodb-sacred:/tmp/backup ./backup-$(date +%Y%m%d)
```

### **Restore from Atlas:**
```cmd
# Set environment variables first:
# set ATLAS_USER=your_username
# set ATLAS_PASSWORD=your_password  
# set ATLAS_URL=your_cluster_url
mongo_dump_restore.bat
```

### **View Data Statistics:**
Access MongoDB shell:
```cmd
docker exec -it mongodb-sacred mongosh workshop_data
```

## 🏗️ Architecture

```
┌─────────────────┐    ┌──────────────────┐
│   Omniboard     │    │    MongoDB       │
│  (Port 9004)    │────│  (Port 27018)    │
│                 │    │                  │
│ Web Interface   │    │ Sacred Data      │
└─────────────────┘    └──────────────────┘
        │                       │
        └───────────────────────┘
                    │
            Docker Network
                    │
        ┌─────────────────────┐
        │    Host Machine     │
        │  (Your Computer)    │
        └─────────────────────┘
                    │
            ┌───────────────┐
            │ WiFi Network  │
            └───────────────┘
                    │
        ┌─────────────────────┐
        │   Network Users     │
        │ (Other Computers)   │
        └─────────────────────┘
```

## 📝 Sacred Experiment Data

The container includes pre-loaded Sacred experiment data:
- **Database:** `workshop_data`
- **Collections:** `runs`, `metrics`, `fs.files`, `fs.chunks`
- **Web Interface:** Full experiment browsing and analysis via Omniboard
- **Data Source:** Pre-loaded from `dump-folder/workshop_data/`

## 🆘 Support

1. **Check service status:** `docker-compose ps`
2. **View logs:** `docker-compose logs [service_name]`
3. **Restart services:** `docker-compose down && docker-compose up -d`
4. **Reset everything:** `docker-compose down -v && docker-compose up -d`

---

**Note:** Replace `YOUR_MACHINE_IP` with the actual IP address of the host machine when sharing access details with network users.
