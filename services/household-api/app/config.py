"""
Configuration management for Household AI Assistant.

Settings are loaded from environment variables via .env file.
"""

from pydantic_settings import BaseSettings
from typing import Optional


class Settings(BaseSettings):
    """Application settings loaded from environment variables."""
    
    # API Configuration
    API_HOST: str = "0.0.0.0"
    API_PORT: int = 8000
    DEBUG: bool = False
    ENVIRONMENT: str = "development"
    LOG_LEVEL: str = "INFO"
    
    # OpenClaw Integration
    OPENCLAW_BASE_URL: Optional[str] = None
    OPENCLAW_API_KEY: Optional[str] = None
    
    # Database Configuration
    POSTGRES_USER: str = "household_ai"
    POSTGRES_PASSWORD: str = "password"
    POSTGRES_DB: str = "household_ai"
    POSTGRES_HOST: str = "postgres"
    POSTGRES_PORT: int = 5432
    
    # Redis Configuration
    REDIS_URL: str = "redis://redis:6379"
    REDIS_HOST: str = "redis"
    REDIS_PORT: int = 6379
    
    # Home Assistant Integration
    HOME_ASSISTANT_URL: Optional[str] = None
    HOME_ASSISTANT_TOKEN: Optional[str] = None
    HOME_ASSISTANT_TIMEOUT: int = 10
    
    # Google APIs (Calendar, Gmail)
    GOOGLE_APPLICATION_CREDENTIALS: Optional[str] = None
    GOOGLE_CALENDAR_ID: Optional[str] = None
    GOOGLE_GMAIL_ADDRESS: Optional[str] = None
    
    # OpenAI (LLM Backend)
    OPENAI_API_KEY: Optional[str] = None
    OPENAI_MODEL: str = "gpt-4"
    
    # Grocy (Grocery Management)
    GROCY_API_URL: Optional[str] = None
    GROCY_API_KEY: Optional[str] = None
    
    # Water Usage Monitoring
    WATER_API_URL: Optional[str] = None
    WATER_API_KEY: Optional[str] = None
    WATER_API_TIMEOUT_SECONDS: int = 10
    
    # Library Systems
    KAVITA_URL: Optional[str] = None
    KAVITA_API_KEY: Optional[str] = None
    
    CALIBRE_WEB_URL: Optional[str] = None
    CALIBRE_WEB_API_KEY: Optional[str] = None
    
    AUDIOBOOKSHELF_URL: Optional[str] = None
    AUDIOBOOKSHELF_API_KEY: Optional[str] = None
    
    # Docker Integration
    DOCKER_HOST_1: str = "unix:///var/run/docker.sock"
    DOCKER_HOST_2: Optional[str] = None
    DOCKER_HOST_3: Optional[str] = None
    
    # Feature Flags
    MOCK_INTEGRATIONS: bool = False
    AUDIT_LOG_ENABLED: bool = True
    
    # Confirmation Settings
    CONFIRMATION_TIMEOUT_SECONDS: int = 300
    
    # Rate Limiting
    RATE_LIMIT_REQUESTS: int = 100
    RATE_LIMIT_WINDOW_SECONDS: int = 60
    
    # Advanced
    MAX_CONCURRENT_AGENTS: int = 5
    
    class Config:
        env_file = ".env"
        case_sensitive = True
    
    @property
    def database_url(self) -> str:
        """Construct PostgreSQL connection URL."""
        return (
            f"postgresql://{self.POSTGRES_USER}:{self.POSTGRES_PASSWORD}@"
            f"{self.POSTGRES_HOST}:{self.POSTGRES_PORT}/{self.POSTGRES_DB}"
        )
    
    @property
    def is_production(self) -> bool:
        """Check if running in production."""
        return self.ENVIRONMENT == "production"
    
    @property
    def is_mock_mode(self) -> bool:
        """Check if running in mock mode (no external API calls)."""
        return self.MOCK_INTEGRATIONS


# Create global settings instance
settings = Settings()
