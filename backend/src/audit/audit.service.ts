import { Injectable, NotFoundException, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { QueryAuditLogDto } from './dto/query-audit-log.dto';
import { Prisma } from '@prisma/client';

export interface CreateAuditLogParams {
  userId?: string;
  action: string;
  entityType: string;
  entityId?: string;
  payload?: any;
  ipAddress?: string;
}

@Injectable()
export class AuditService {
  private readonly logger = new Logger(AuditService.name);

  constructor(private readonly prisma: PrismaService) {}

  async logAction(params: CreateAuditLogParams) {
    const { userId, action, entityType, entityId, payload, ipAddress } = params;

    let payloadString: string | null = null;
    if (payload) {
      if (typeof payload === 'string') {
        payloadString = payload;
      } else {
        try {
          // Remove any sensitive credentials if present in payload
          const sanitizedPayload = { ...payload };
          delete sanitizedPayload.password;
          delete sanitizedPayload.password_hash;
          delete sanitizedPayload.token;
          delete sanitizedPayload.access_token;
          delete sanitizedPayload.refresh_token;

          if (ipAddress) {
            sanitizedPayload._client_ip = ipAddress;
          }

          payloadString = JSON.stringify(sanitizedPayload);
        } catch (e) {
          payloadString = String(payload);
        }
      }
    }

    try {
      const log = await this.prisma.auditLog.create({
        data: {
          user_id: userId || null,
          action,
          entity_type: entityType,
          entity_id: entityId || null,
          payload: payloadString,
        },
      });

      return log;
    } catch (error: any) {
      this.logger.error(`Failed to record audit log: ${error.message}`);
      return null;
    }
  }

  async getLogs(dto: QueryAuditLogDto) {
    const {
      page = 1,
      limit = 20,
      action,
      entity_type,
      user_id,
      from_date,
      to_date,
    } = dto;

    const skip = (page - 1) * limit;

    const where: any = {};

    if (action) {
      where.action = { contains: action, mode: 'insensitive' };
    }

    if (entity_type) {
      where.entity_type = { equals: entity_type, mode: 'insensitive' };
    }

    if (user_id) {
      where.user_id = user_id;
    }

    if (from_date || to_date) {
      where.timestamp = {};
      if (from_date) {
        where.timestamp.gte = new Date(from_date);
      }
      if (to_date) {
        where.timestamp.lte = new Date(to_date);
      }
    }

    const [total, logs] = await Promise.all([
      this.prisma.auditLog.count({ where }),
      this.prisma.auditLog.findMany({
        where,
        skip,
        take: limit,
        orderBy: { timestamp: 'desc' },
        include: {
          user: {
            select: {
              id: true,
              username: true,
              full_name: true,
              role: true,
            },
          },
        },
      }),
    ]);

    return {
      total,
      page,
      limit,
      total_pages: Math.ceil(total / limit),
      logs,
    };
  }

  async getLogById(id: string) {
    const log = await this.prisma.auditLog.findUnique({
      where: { id },
      include: {
        user: {
          select: {
            id: true,
            username: true,
            full_name: true,
            role: true,
          },
        },
      },
    });

    if (!log) {
      throw new NotFoundException(`Audit log with ID ${id} not found`);
    }

    return log;
  }

  async getEntityLogs(entityType: string, entityId: string) {
    return this.prisma.auditLog.findMany({
      where: {
        entity_type: { equals: entityType, mode: 'insensitive' },
        entity_id: entityId,
      },
      include: {
        user: {
          select: {
            id: true,
            username: true,
            full_name: true,
            role: true,
          },
        },
      },
      orderBy: { timestamp: 'desc' },
    });
  }

  async getStatistics() {
    const [totalLogs, todayLogs, actionsSummary] = await Promise.all([
      this.prisma.auditLog.count(),
      this.prisma.auditLog.count({
        where: {
          timestamp: {
            gte: new Date(new Date().setHours(0, 0, 0, 0)),
          },
        },
      }),
      this.prisma.auditLog.groupBy({
        by: ['action'],
        _count: { action: true },
        orderBy: { _count: { action: 'desc' } },
        take: 5,
      }),
    ]);

    return {
      total_logs: totalLogs,
      today_logs: todayLogs,
      top_actions: actionsSummary.map((item) => ({
        action: item.action,
        count: item._count.action,
      })),
    };
  }
}
