import { Controller, Get } from '@nestjs/common';

@Controller('health')
export class AppController {
  @Get()
  getHealth() {
    return {
      status: 'OK',
      timestamp: new Date().toISOString(),
      service: 'University Attendance System Central Backend',
      version: '1.0.0',
    };
  }
}
