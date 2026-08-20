import { OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
export declare enum Role {
    ADMIN = "ADMIN",
    STUDENT = "STUDENT",
    TEACHER = "TEACHER"
}
export declare enum AccountState {
    PendingActivation = "PendingActivation",
    Active = "Active",
    Suspended = "Suspended",
    Deactivated = "Deactivated"
}
export declare enum DeviceState {
    Unregistered = "Unregistered",
    PendingVerification = "PendingVerification",
    Bound = "Bound",
    Revoked = "Revoked"
}
export declare enum CodeState {
    Generated = "Generated",
    Sent = "Sent",
    Used = "Used",
    Expired = "Expired",
    Invalidated = "Invalidated"
}
export declare enum SemesterType {
    FIRST = "FIRST",
    SECOND = "SECOND",
    SUMMER = "SUMMER"
}
export declare enum SectionType {
    PRACTICAL = "PRACTICAL",
    THEORETICAL = "THEORETICAL"
}
export declare enum TeacherType {
    PRACTICAL_TEACHER = "PRACTICAL_TEACHER",
    THEORETICAL_TEACHER = "THEORETICAL_TEACHER",
    BOTH = "BOTH"
}
export declare enum SessionState {
    Created = "Created",
    Opened = "Opened",
    Active = "Active",
    Closing = "Closing",
    Closed = "Closed",
    Synced = "Synced"
}
export declare enum AttendanceState {
    Present = "Present",
    Absent = "Absent",
    Late = "Late",
    Excused = "Excused"
}
export declare enum AttendanceMethod {
    QR = "QR",
    Biometric = "Biometric",
    Manual = "Manual"
}
export declare enum RequestState {
    Received = "Received",
    Validating = "Validating",
    Accepted = "Accepted",
    Rejected = "Rejected",
    QueuedForSync = "QueuedForSync"
}
export declare enum QrState {
    Generated = "Generated",
    Active = "Active",
    Expired = "Expired",
    Invalidated = "Invalidated"
}
export declare enum SyncState {
    Idle = "Idle",
    Preparing = "Preparing",
    Syncing = "Syncing",
    Success = "Success",
    Failed = "Failed"
}
export declare class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
    onModuleInit(): Promise<void>;
    onModuleDestroy(): Promise<void>;
}
