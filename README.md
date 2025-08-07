# Sacred MongoDB Docker Environment

A containerized MongoDB environment pre-loaded with Sacred experiment data, featuring Omniboard web interface for experiment visualization.

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose installed
- Windows with PowerShell (for batch scripts)

### 1. Start the Environment
```bash
# Quick start (recommended)
start.bat

# Or manually with Docker Compose
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
| **Localhost** | `localhost` | `27018` | `test_data_new` |
| **Network** | `YOUR_MACHINE_IP` | `27018` | `test_data_new` |

### **Connection Strings:**
```bash
# Localhost
mongodb://localhost:27018/test_data_new

# Network access
mongodb://YOUR_MACHINE_IP:27018/test_data_new
```

## 🛠️ Management Scripts

| Script | Description |
|--------|-------------|
| `start.bat` | Start all services |
| `stop.bat` | Stop all services |
| `manage.bat` | Interactive management menu |
| `mongo_dump_restore.bat` | Sync with MongoDB Atlas |

## 📁 Project Structure

```
docker-mongodb/
├── 📄 config.env              # Configuration (database name, ports)
├── 🐳 docker-compose.yml      # Main orchestration file
├── 🐳 Dockerfile              # MongoDB image with data
├── 📁 dump-folder/            # Your database dump
│   └── test_data_new/         # Sacred experiment data
├── 📁 scripts/                # Database initialization scripts
│   └── restore-database.sh    # Automatic restoration script
├── 🚀 start.bat               # Quick start
├── 🛑 stop.bat                # Quick stop  
├── ⚙️ manage.bat              # Full management interface
├── 🔄 mongo_dump_restore.bat  # Atlas sync script
├── 📱 omniboard_fast_start.bat # Local Omniboard (non-Docker)
└── 📁 archive/                # Old test files
```

## 🔧 Configuration

All settings are managed in `config.env`:

```env
# Database name
DB_NAME=test_data_new

# Host ports (what users connect to)
MONGO_PORT_HOST=27018      # MongoDB access port
OMNIBOARD_PORT_HOST=9004   # Omniboard web interface port

# Atlas credentials (for dump/restore)
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
   - MongoDB: `mongodb://YOUR_IP:27018/test_data_new`

### **For Network Users:**

1. **Web Access (Recommended):**
   - Open browser and go to: `http://HOST_MACHINE_IP:9004`
   - No additional software needed

2. **Direct MongoDB Access:**
   - Use MongoDB tools with: `mongodb://HOST_MACHINE_IP:27018/test_data_new`
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
   stop.bat
   start.bat
   ```

## 📁 Data Management

### **Backup Current Data:**
```cmd
docker exec mongodb-sacred mongodump --db=test_data_new --out=/tmp/backup
docker cp mongodb-sacred:/tmp/backup ./backup-$(date +%Y%m%d)
```

### **Restore from Atlas:**
```cmd
mongo_dump_restore.bat
```

### **View Data Statistics:**
Access MongoDB shell:
```cmd
docker exec -it mongodb-sacred mongosh test_data_new
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
- **Database:** `test_data_new`
- **Collections:** `runs`, `metrics`, `fs.files`, `fs.chunks`
- **Web Interface:** Full experiment browsing and analysis via Omniboard

## 🆘 Support

1. **Check service status:** `docker-compose ps`
2. **View logs:** `docker-compose logs [service_name]`
3. **Restart services:** `stop.bat && start.bat`
4. **Reset everything:** `docker-compose down -v && start.bat`

---

**Note:** Replace `YOUR_MACHINE_IP` with the actual IP address of the host machine when sharing access details with network users.
