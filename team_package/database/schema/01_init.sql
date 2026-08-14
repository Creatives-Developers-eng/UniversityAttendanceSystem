-- =============================================================================
-- University Attendance System - PostgreSQL Database Schema Initialization
-- File: database/schema/01_init.sql
-- Description: Enables UUID extension and sets up domain check constraints
-- =============================================================================

-- 1. Enable UUID Extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. State Check Constraint Definitions (Aligned with SYSTEM_STATES.md)
-- Account States: PendingActivation, Active, Suspended, Deactivated
-- Device States: Unregistered, PendingVerification, Bound, Revoked
-- Activation Code States: Generated, Sent, Used, Expired, Invalidated
-- Session States: Created, Opened, Active, Closing, Closed, Synced
-- Attendance Request States: Received, Validating, Accepted, Rejected, QueuedForSync
-- Attendance States: Present, Absent, Late, Excused
-- Synchronization States: Idle, Preparing, Syncing, Success, Failed
-- QR States: Generated, Active, Expired, Invalidated
