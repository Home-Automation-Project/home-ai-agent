"""
Pydantic models for API requests and responses.
"""

from datetime import datetime
from typing import Optional, List, Any, Dict
from enum import Enum
from pydantic import BaseModel, Field


# ===== Common Models =====

class StatusEnum(str, Enum):
    """Status enumeration."""
    SUCCESS = "success"
    ERROR = "error"
    PENDING = "pending"
    CONFIRMED = "confirmed"
    DENIED = "denied"


class HealthResponse(BaseModel):
    """API health check response."""
    status: StatusEnum = StatusEnum.SUCCESS
    timestamp: datetime = Field(default_factory=datetime.utcnow)
    version: str = "0.1.0"


# ===== Integration Models =====

class IntegrationRequest(BaseModel):
    """Generic integration request."""
    service: str
    action: str
    parameters: Optional[Dict[str, Any]] = None
    require_confirmation: bool = False


class IntegrationResponse(BaseModel):
    """Generic integration response."""
    status: StatusEnum
    data: Optional[Dict[str, Any]] = None
    error: Optional[str] = None
    timestamp: datetime = Field(default_factory=datetime.utcnow)
    duration_ms: Optional[float] = None


# ===== Home Assistant Models =====

class EntityState(BaseModel):
    """Home Assistant entity state."""
    entity_id: str
    state: str
    attributes: Dict[str, Any] = {}
    last_updated: Optional[datetime] = None
    last_changed: Optional[datetime] = None


class ServiceCallRequest(BaseModel):
    """Home Assistant service call request."""
    domain: str
    service: str
    service_data: Dict[str, Any] = {}


# ===== Confirmation Models =====

class ConfirmationRequest(BaseModel):
    """Request for user confirmation of an action."""
    action_id: str
    agent_name: str
    skill_name: str
    action_name: str
    action_details: str
    affected_resources: Optional[List[str]] = None
    timeout_seconds: int = 300


class ConfirmationResponse(BaseModel):
    """User response to confirmation request."""
    action_id: str
    approved: bool
    user_response: str  # "yes", "no", "timeout"
    timestamp: datetime = Field(default_factory=datetime.utcnow)


# ===== Audit Models =====

class AuditLogEntry(BaseModel):
    """Audit log entry."""
    agent_name: str
    skill_name: str
    action_name: str
    parameters: Dict[str, Any] = {}
    result: StatusEnum
    error_message: Optional[str] = None
    confirmation_required: bool = False
    confirmation_status: Optional[str] = None  # "approved", "denied", "timeout"
    timestamp: datetime = Field(default_factory=datetime.utcnow)
    duration_ms: Optional[float] = None


# ===== State Models =====

class HouseholdState(BaseModel):
    """Current household state snapshot."""
    occupancy_status: str  # "home", "away", "mixed"
    active_alerts: List[str] = []
    last_updated: datetime = Field(default_factory=datetime.utcnow)
    custom_data: Optional[Dict[str, Any]] = None


# ===== Error Models =====

class ErrorResponse(BaseModel):
    """Standard error response."""
    error: str
    error_code: Optional[str] = None
    details: Optional[str] = None
    timestamp: datetime = Field(default_factory=datetime.utcnow)
