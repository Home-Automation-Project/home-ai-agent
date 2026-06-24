"""
Household AI Assistant - FastAPI Integration Gateway

This service provides the integration layer between OpenClaw agents and
external household systems (Home Assistant, Google Calendar, Gmail, Docker, etc.).

Routes:
  - /health - Health check
  - /integrations/* - External service integrations
  - /state/* - Shared state queries
"""

import logging
from contextlib import asynccontextmanager
from datetime import datetime
from typing import Dict, Any

from fastapi import FastAPI, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from app.config import settings
from app.routers import health, integrations, state

# Configure logging
logging.basicConfig(
    level=settings.LOG_LEVEL,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Application lifespan management.
    Handles startup and shutdown events.
    """
    # Startup
    logger.info("Starting Household AI Assistant API Gateway")
    logger.info(f"Environment: {settings.ENVIRONMENT}")
    logger.info(f"Debug mode: {settings.DEBUG}")
    logger.info(f"Mock integrations: {settings.MOCK_INTEGRATIONS}")
    
    # Database initialization (TODO: Create tables if needed)
    # await init_db()
    
    yield
    
    # Shutdown
    logger.info("Shutting down Household AI Assistant API Gateway")


# Create FastAPI application
app = FastAPI(
    title="Household AI Assistant",
    description="Integration gateway for household automation and AI agents",
    version="0.1.0",
    docs_url="/docs",
    redoc_url="/redoc",
    lifespan=lifespan,
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # TODO: Restrict to specific origins in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Include routers
app.include_router(health.router, tags=["health"])
app.include_router(integrations.router, prefix="/integrations", tags=["integrations"])
app.include_router(state.router, prefix="/state", tags=["state"])


# Global exception handlers
@app.exception_handler(HTTPException)
async def http_exception_handler(request, exc):
    """Handle HTTP exceptions with consistent formatting."""
    return JSONResponse(
        status_code=exc.status_code,
        content={
            "error": exc.detail,
            "timestamp": datetime.utcnow().isoformat(),
        },
    )


@app.exception_handler(Exception)
async def general_exception_handler(request, exc):
    """Handle general exceptions with error logging."""
    logger.error(f"Unhandled exception: {exc}", exc_info=True)
    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content={
            "error": "Internal server error",
            "timestamp": datetime.utcnow().isoformat(),
        },
    )


# Optional: Custom startup message
@app.get("/")
async def root() -> Dict[str, Any]:
    """Root endpoint - welcome message."""
    return {
        "name": "Household AI Assistant",
        "version": "0.1.0",
        "status": "running",
        "docs": "/docs",
        "health": "/health",
    }


if __name__ == "__main__":
    import uvicorn
    
    uvicorn.run(
        "app.main:app",
        host=settings.API_HOST,
        port=settings.API_PORT,
        reload=settings.DEBUG,
        log_level=settings.LOG_LEVEL.lower(),
    )
