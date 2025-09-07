# 🚀 Loan Processing App - Deployment Guide

This guide covers deploying your FastAPI + Streamlit loan processing application on various free platforms.

## 📋 Prerequisites

1. **Google Gemini API Key**: Get one from [Google AI Studio](https://makersuite.google.com/app/apikey)
2. **Git Repository**: Push your code to GitHub/GitLab
3. **Account**: Sign up on your chosen platform

## 🌟 **Option 1: Render.com (RECOMMENDED)**

### Why Render?
- ✅ **750 free hours/month** (enough for 24/7)
- ✅ **Easy deployment** from GitHub
- ✅ **Automatic HTTPS**
- ✅ **Sleeps after 15min inactivity** (wakes up in ~30 seconds)

### Steps:

1. **Push your code to GitHub**
   ```bash
   git add .
   git commit -m "Add deployment configs"
   git push origin main
   ```

2. **Deploy Backend**:
   - Go to [render.com](https://render.com)
   - Click "New +" → "Web Service"
   - Connect your GitHub repo
   - **Settings**:
     - **Name**: `loan-processor-backend`
     - **Environment**: `Python 3`
     - **Build Command**: `pip install -r requirements.txt`
     - **Start Command**: `uvicorn main:app --host 0.0.0.0 --port $PORT`
     - **Environment Variables**:
       - `GOOGLE_API_KEY`: Your Gemini API key
     - **Plan**: Free

3. **Deploy Frontend**:
   - Create another Web Service
   - **Settings**:
     - **Name**: `loan-processor-frontend`
     - **Environment**: `Python 3`
     - **Build Command**: `pip install -r requirements.txt`
     - **Start Command**: `streamlit run app.py --server.port $PORT --server.address 0.0.0.0`
     - **Environment Variables**:
       - `BACKEND_URL`: `https://loan-processor-backend.onrender.com`
     - **Plan**: Free

4. **Update Frontend Code**:
   Replace `http://127.0.0.1:8000` with your backend URL in `app.py`:
   ```python
   # Change this line in app.py
   response = requests.post("https://loan-processor-backend.onrender.com/process-application/", files=multipart_files)
   ```

---

## 🚁 **Option 2: Fly.io**

### Why Fly.io?
- ✅ **3 free VMs** (256MB RAM each)
- ✅ **Global edge deployment**
- ✅ **Quick wake-up times**

### Steps:

1. **Install Fly CLI**:
   ```bash
   # Windows (PowerShell)
   iwr https://fly.io/install.ps1 -useb | iex
   
   # Or download from: https://fly.io/docs/hands-on/install-flyctl/
   ```

2. **Login and Initialize**:
   ```bash
   fly auth login
   fly launch
   ```

3. **Deploy**:
   ```bash
   fly deploy
   ```

4. **Set Environment Variables**:
   ```bash
   fly secrets set GOOGLE_API_KEY=your_api_key_here
   ```

---

## 🐳 **Option 3: Docker + Any Platform**

### Deploy to any Docker-supporting platform:

1. **Build and test locally**:
   ```bash
   # Build backend
   docker build -t loan-backend --build-arg SERVICE=backend .
   
   # Build frontend  
   docker build -t loan-frontend --build-arg SERVICE=frontend .
   
   # Test with docker-compose
   docker-compose up
   ```

2. **Push to Docker Hub**:
   ```bash
   docker tag loan-backend yourusername/loan-backend
   docker tag loan-frontend yourusername/loan-frontend
   docker push yourusername/loan-backend
   docker push yourusername/loan-frontend
   ```

3. **Deploy on platforms like**:
   - **Railway**: Connect Docker Hub
   - **DigitalOcean App Platform**: Free tier available
   - **Google Cloud Run**: Free tier available

---

## 🔧 **Important Configuration Changes**

### 1. Update Backend URLs in Frontend

In `app.py`, replace all `http://127.0.0.1:8000` with your deployed backend URL:

```python
# Find and replace these lines:
requests.post("http://127.0.0.1:8000/process-application/", files=multipart_files)
requests.post("http://127.0.0.1:8000/save-verified-document/", json=payload)
requests.get("http://127.0.0.1:8000/get-report-data/")
requests.delete("http://127.0.0.1:8000/delete-all-data/")
```

### 2. Environment Variables

Set these in your deployment platform:
- `GOOGLE_API_KEY`: Your Gemini API key
- `BACKEND_URL`: Your backend URL (for frontend)
- `PORT`: Platform will set this automatically

### 3. CORS Configuration

Add CORS to your FastAPI backend in `main.py`:
```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify your frontend URL
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

---

## 🎯 **Quick Start Commands**

### For Render.com:
```bash
# 1. Push to GitHub
git add .
git commit -m "Ready for deployment"
git push origin main

# 2. Go to render.com and create two web services
# 3. Update app.py with backend URL
# 4. Redeploy frontend
```

### For Fly.io:
```bash
# 1. Install flyctl
# 2. Login and deploy
fly auth login
fly launch
fly deploy
fly secrets set GOOGLE_API_KEY=your_key
```

---

## 🚨 **Troubleshooting**

### Common Issues:

1. **"Connection Error"**: 
   - Check backend URL in frontend
   - Ensure backend is deployed and running

2. **"Google API Key Error"**:
   - Verify API key is set correctly
   - Check API key has proper permissions

3. **"Tesseract not found"**:
   - Use the provided Dockerfile (includes Tesseract)
   - Or add Tesseract installation to build commands

4. **Slow startup**:
   - Normal for free tiers (cold starts)
   - Consider upgrading to paid plan for production

---

## 💡 **Pro Tips**

1. **Use Render.com** for easiest deployment
2. **Test locally** with Docker before deploying
3. **Monitor logs** in your platform's dashboard
4. **Set up monitoring** for production use
5. **Use environment variables** for all secrets

---

## 📞 **Need Help?**

- **Render Support**: [render.com/docs](https://render.com/docs)
- **Fly.io Docs**: [fly.io/docs](https://fly.io/docs)
- **Docker Docs**: [docs.docker.com](https://docs.docker.com)

Your app should be live and accessible worldwide! 🌍
