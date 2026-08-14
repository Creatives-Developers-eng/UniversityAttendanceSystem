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
export declare class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
    onModuleInit(): Promise<void>;
    onModuleDestroy(): Promise<void>;
}
