# Kootumb Frontend-Backend Connection Guide

## 🔗 How to Connect Frontend and Backend

### 📋 **Prerequisites**
1. Django backend running on port 8000
2. Flutter frontend configured with correct API endpoints
3. CORS properly configured (✅ Already done)

---

## 🚀 **Step-by-Step Connection Process**

### **Step 1: Start the Django Backend**

```bash
cd /home/sakshi/Desktop/kootumb/kootumb_API_Backend
./env/bin/python3 manage.py runserver 0.0.0.0:8000
```

**Backend will be available at:**
- Local access: `http://127.0.0.1:8000/`
- Network access: `http://0.0.0.0:8000/`

### **Step 2: Configure Frontend for Your Target Device**

#### **🤖 For Android Emulator (Current Setup)**
- File: `assets/.env.json`
- URL: `http://10.0.2.2:8000/`
- ✅ Already configured correctly

#### **📱 For Physical Android Device**
- File: `assets/.env.physical-device.json` (created)
- URL: `http://YOUR_COMPUTER_IP:8000/`
- Replace `YOUR_COMPUTER_IP` with your actual IP address

#### **🍎 For iOS Simulator**
- File: `assets/.env.ios.json` (created)
- URL: `http://127.0.0.1:8000/`

### **Step 3: Switch Environment Configuration**

Copy the appropriate config file to `.env.json`:

```bash
# For physical device
cp assets/.env.physical-device.json assets/.env.json

# For iOS
cp assets/.env.ios.json assets/.env.json

# For Android emulator (default)
# Already configured in assets/.env.json
```

### **Step 4: Find Your Computer's IP Address**

```bash
# On Linux/Mac
ip addr show | grep "inet " | grep -v 127.0.0.1

# Or
ifconfig | grep "inet " | grep -v 127.0.0.1
```

Update the physical device config with your actual IP.

---

## 🔧 **Network Configuration Details**

### **URL Mappings**
| Target Device | Backend URL | Frontend Config |
|---------------|-------------|-----------------|
| Android Emulator | `0.0.0.0:8000` | `10.0.2.2:8000` |
| Physical Device | `0.0.0.0:8000` | `YOUR_IP:8000` |
| iOS Simulator | `127.0.0.1:8000` | `127.0.0.1:8000` |

### **Port Explanation**
- **10.0.2.2**: Android emulator's special IP that maps to host's 127.0.0.1
- **0.0.0.0**: Django listens on all network interfaces
- **127.0.0.1**: Localhost/loopback address

---

## 🧪 **Testing the Connection**

### **1. Test Backend Health Endpoint**
```bash
curl http://127.0.0.1:8000/health/
```
Expected response: `{"message":"Todo muy bueno!"}`

### **2. Test API Endpoints**
```bash
# Test authentication endpoint
curl -X POST http://127.0.0.1:8000/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{"username":"test","password":"test"}'

# Test user registration
curl -X POST http://127.0.0.1:8000/api/auth/register/ \
  -H "Content-Type: application/json" \
  -d '{"username":"test","email":"test@test.com","password":"testpass"}'
```

### **3. Run Flutter App**
```bash
cd /home/sakshi/Desktop/kootumb/kootumb_Frontend_Flutter
flutter run
```

---

## 🔒 **Security & CORS Configuration**

Your Django backend is already configured with:

```python
# CORS Configuration (already in settings.py)
CORS_ALLOW_ALL_ORIGINS = True  # For development
CORS_ALLOW_CREDENTIALS = True
CORS_ALLOW_HEADERS = [
    'accept', 'accept-encoding', 'authorization', 'content-type',
    'dnt', 'origin', 'user-agent', 'x-csrftoken', 'x-requested-with',
]
```

---

## 🐛 **Troubleshooting Common Issues**

### **"Network Error" or "Connection Refused"**
1. ✅ Ensure Django backend is running
2. ✅ Check correct IP address in frontend config
3. ✅ Verify firewall isn't blocking port 8000
4. ✅ For physical devices: ensure same network

### **"CORS Error"**
- ✅ Already configured in your backend

### **"404 Not Found"**
- ✅ Verify API endpoints exist in Django URLs
- ✅ Check URL paths match between frontend and backend

### **Authentication Issues**
1. ✅ Ensure user accounts exist in Django
2. ✅ Check JWT token handling in Flutter
3. ✅ Verify authentication headers

---

## 📱 **Running the Complete Stack**

### **Terminal 1: Django Backend**
```bash
cd /home/sakshi/Desktop/kootumb/kootumb_API_Backend
./env/bin/python3 manage.py runserver 0.0.0.0:8000
```

### **Terminal 2: Flutter Frontend**
```bash
cd /home/sakshi/Desktop/kootumb/kootumb_Frontend_Flutter
flutter run
```

### **Terminal 3: Testing (Optional)**
```bash
# Test backend connectivity
curl http://127.0.0.1:8000/health/

# Monitor Django logs
tail -f /path/to/django/logs
```

---

## ✅ **Success Indicators**

You'll know the connection is working when:
1. ✅ Django server starts without errors
2. ✅ Flutter app loads without network errors
3. ✅ Health check returns successful response
4. ✅ Authentication/registration works in app
5. ✅ Data loads from backend in frontend

---

## 🔄 **Development Workflow**

1. **Start Backend**: `./env/bin/python3 manage.py runserver 0.0.0.0:8000`
2. **Choose Target**: Select appropriate `.env.json` config
3. **Run Frontend**: `flutter run`
4. **Test Features**: Login, registration, data fetching
5. **Debug**: Check backend logs and frontend console

Your connection is now properly configured! 🎉
