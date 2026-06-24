"""
Health check endpoints.
"""

import logging
from datetime import datetime

from fastapi import APIRouter, status
from app.models import HealthResponse, StatusEnum

logger = logging.getLogger(__name__)

router = APIRouter()


@router.get(
    "/health",
    response_model=HealthResponse,
    status_code=status.HTTP_200_OK,
    summary="Health Check",
    description="Check if the API is running and healthy",
)
async def health_check() -> HealthResponse:
    """
    Health check endpoint.
    
    Returns:
        HealthResponse with status and timestamp
    """
    return HealthResponse(
        status=StatusEnum.SUCCESS,
        timestamp=datetime.utcnow(),
    )


@router.get(
    "/readiness",
    response_model=HealthResponse,
    status_code=status.HTTP_200_OK,
    summary="Readiness Check",
    description="Check if the API is ready to receive requests (all dependencies healthy)",
)
async def readiness_check() -> HealthResponse:
    """
    Readiness check endpoint.
    
    In a real implementation, this would check:
    - Database connectivity
    - Redis connectivity
    - External service availability
    
    Returns:
        HealthResponse with status and timestamp
    """
    # TODO: Check PostgreSQL connection
    # TODO: Check Redis connection
    # TODO: Check external service connectivity
    
    return HealthResponse(
        status=StatusEnum.SUCCESS,
        timestamp=datetime.utcnow(),
    )


@router.get(
    "/liveness",
    response_model=HealthResponse,
    status_code=status.HTTP_200_OK,
    summary="Liveness Check",
    description="Check if the API is still running (lightweight check)",
)
async def liveness_check() -> HealthResponse:
    """
    Liveness check endpoint (lightweight, no dependency checks).
    
    Returns:
        HealthResponse with status and timestamp
    """
    return HealthResponse(
        status=StatusEnum.SUCCESS,
        timestamp=datetime.utcnow(),
    )
