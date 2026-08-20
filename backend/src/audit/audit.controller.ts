import {
  Controller,
  Get,
  Param,
  Query,
  UseGuards,
} from '@nestjs/common';
import { AuditService } from './audit.service';
import { QueryAuditLogDto } from './dto/query-audit-log.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { Role } from '../prisma/prisma.service';

@Controller('audit-logs')
@UseGuards(JwtAuthGuard, RolesGuard)
export class AuditController {
  constructor(private readonly auditService: AuditService) {}

  @Get()
  @Roles(Role.ADMIN)
  async getLogs(@Query() query: QueryAuditLogDto) {
    return this.auditService.getLogs(query);
  }

  @Get('statistics')
  @Roles(Role.ADMIN)
  async getStatistics() {
    return this.auditService.getStatistics();
  }

  @Get(':id')
  @Roles(Role.ADMIN)
  async getLogById(@Param('id') id: string) {
    return this.auditService.getLogById(id);
  }

  @Get('entity/:entityType/:entityId')
  @Roles(Role.ADMIN)
  async getEntityLogs(
    @Param('entityType') entityType: string,
    @Param('entityId') entityId: string,
  ) {
    return this.auditService.getEntityLogs(entityType, entityId);
  }
}
