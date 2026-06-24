-- PostgreSQL Database Initialization for Household AI Assistant

-- Create audit_logs table
CREATE TABLE IF NOT EXISTS audit_logs (
    id SERIAL PRIMARY KEY,
    agent_name VARCHAR(255) NOT NULL,
    skill_name VARCHAR(255) NOT NULL,
    action_name VARCHAR(255) NOT NULL,
    parameters JSONB,
    result VARCHAR(50) NOT NULL,
    error_message TEXT,
    confirmation_required BOOLEAN DEFAULT FALSE,
    confirmation_status VARCHAR(50),
    timestamp TIMESTAMP NOT NULL DEFAULT NOW(),
    duration_ms FLOAT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Create indexes for audit_logs
CREATE INDEX idx_audit_logs_timestamp ON audit_logs(timestamp);
CREATE INDEX idx_audit_logs_agent_name ON audit_logs(agent_name);
CREATE INDEX idx_audit_logs_skill_name ON audit_logs(skill_name);
CREATE INDEX idx_audit_logs_result ON audit_logs(result);

-- Create confirmations table
CREATE TABLE IF NOT EXISTS confirmations (
    id SERIAL PRIMARY KEY,
    action_id VARCHAR(255) UNIQUE NOT NULL,
    agent_name VARCHAR(255) NOT NULL,
    skill_name VARCHAR(255) NOT NULL,
    action_name VARCHAR(255) NOT NULL,
    action_details TEXT NOT NULL,
    affected_resources TEXT[],
    approved BOOLEAN,
    user_response VARCHAR(50),
    timeout_seconds INT DEFAULT 300,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    responded_at TIMESTAMP,
    expires_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Create indexes for confirmations
CREATE INDEX idx_confirmations_action_id ON confirmations(action_id);
CREATE INDEX idx_confirmations_agent_name ON confirmations(agent_name);
CREATE INDEX idx_confirmations_expires_at ON confirmations(expires_at);

-- Create service_state table
CREATE TABLE IF NOT EXISTS service_state (
    id SERIAL PRIMARY KEY,
    service_name VARCHAR(255) UNIQUE NOT NULL,
    state JSONB,
    last_updated TIMESTAMP NOT NULL DEFAULT NOW(),
    health_status VARCHAR(50),
    response_time_ms FLOAT,
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Create indexes for service_state
CREATE INDEX idx_service_state_name ON service_state(service_name);

-- Create alerts table
CREATE TABLE IF NOT EXISTS alerts (
    id SERIAL PRIMARY KEY,
    alert_type VARCHAR(100) NOT NULL,
    severity VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    source_agent VARCHAR(255),
    source_service VARCHAR(255),
    resolution_status VARCHAR(50) DEFAULT 'open',
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    resolved_at TIMESTAMP,
    acknowledged_at TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Create indexes for alerts
CREATE INDEX idx_alerts_severity ON alerts(severity);
CREATE INDEX idx_alerts_status ON alerts(resolution_status);
CREATE INDEX idx_alerts_created_at ON alerts(created_at);

-- Create agent_sessions table
CREATE TABLE IF NOT EXISTS agent_sessions (
    id SERIAL PRIMARY KEY,
    agent_name VARCHAR(255) NOT NULL,
    session_id VARCHAR(255) UNIQUE NOT NULL,
    status VARCHAR(50) NOT NULL,
    started_at TIMESTAMP NOT NULL DEFAULT NOW(),
    ended_at TIMESTAMP,
    total_actions INT DEFAULT 0,
    successful_actions INT DEFAULT 0,
    failed_actions INT DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Create indexes for agent_sessions
CREATE INDEX idx_agent_sessions_agent_name ON agent_sessions(agent_name);
CREATE INDEX idx_agent_sessions_started_at ON agent_sessions(started_at);

-- Create rate_limits table for throttling
CREATE TABLE IF NOT EXISTS rate_limits (
    id SERIAL PRIMARY KEY,
    agent_name VARCHAR(255) NOT NULL,
    service_name VARCHAR(255) NOT NULL,
    request_count INT DEFAULT 0,
    window_start TIMESTAMP NOT NULL,
    window_end TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Create indexes for rate_limits
CREATE INDEX idx_rate_limits_agent_service ON rate_limits(agent_name, service_name);
CREATE INDEX idx_rate_limits_window ON rate_limits(window_start, window_end);

-- Permissions for read-only access (optional: adjust as needed)
-- GRANT SELECT ON audit_logs TO readonly_user;
-- GRANT SELECT ON confirmations TO readonly_user;
-- GRANT SELECT ON service_state TO readonly_user;
-- GRANT SELECT ON alerts TO readonly_user;
-- GRANT SELECT ON agent_sessions TO readonly_user;
