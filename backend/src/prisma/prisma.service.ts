import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

export enum Role {
  ADMIN = 'ADMIN',
  STUDENT = 'STUDENT',
  TEACHER = 'TEACHER',
}

export enum AccountState {
  PendingActivation = 'PendingActivation',
  Active = 'Active',
  Suspended = 'Suspended',
  Deactivated = 'Deactivated',
}

export enum DeviceState {
  Unregistered = 'Unregistered',
  PendingVerification = 'PendingVerification',
  Bound = 'Bound',
  Revoked = 'Revoked',
}

export enum CodeState {
  Generated = 'Generated',
  Sent = 'Sent',
  Used = 'Used',
  Expired = 'Expired',
  Invalidated = 'Invalidated',
}

export enum SemesterType {
  FIRST = 'FIRST',
  SECOND = 'SECOND',
  SUMMER = 'SUMMER',
}

export enum SectionType {
  PRACTICAL = 'PRACTICAL',
  THEORETICAL = 'THEORETICAL',
}

export enum TeacherType {
  PRACTICAL_TEACHER = 'PRACTICAL_TEACHER',
  THEORETICAL_TEACHER = 'THEORETICAL_TEACHER',
  BOTH = 'BOTH',
}

@Injectable()
export class PrismaService
  extends PrismaClient
  implements OnModuleInit, OnModuleDestroy
{
  async onModuleInit() {
    await this.$connect();
  }

  async onModuleDestroy() {
    await this.$disconnect();
  }
}
