import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { AppController } from './../src/app.controller';
import { DocsController } from './../src/docs/docs.controller';
import { HttpExceptionFilter } from './../src/common/filters/http-exception.filter';
import { TransformInterceptor } from './../src/common/interceptors/transform.interceptor';

describe('University Attendance System E2E Matrix', () => {
  let app: INestApplication;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      controllers: [AppController, DocsController],
    }).compile();

    app = moduleFixture.createNestApplication();
    app.setGlobalPrefix('api/v1');
    app.useGlobalPipes(new ValidationPipe());
    app.useGlobalFilters(new HttpExceptionFilter());
    app.useGlobalInterceptors(new TransformInterceptor());

    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  describe('Health Check (GET /api/v1/health)', () => {
    it('should return 200 OK with system status', () => {
      return request(app.getHttpServer())
        .get('/api/v1/health')
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('statusCode', 200);
          expect(res.body).toHaveProperty('data');
          expect(res.body.data).toHaveProperty('status', 'OK');
          expect(res.body.data).toHaveProperty('service');
          expect(res.body.data).toHaveProperty('version', '1.0.0');
        });
    });
  });

  describe('Swagger & OpenAPI Documentation (GET /api/v1/docs)', () => {
    it('should serve Swagger UI interactive documentation HTML', () => {
      return request(app.getHttpServer())
        .get('/api/v1/docs')
        .expect(200)
        .expect('Content-Type', /html/)
        .expect((res) => {
          expect(res.text).toContain('University Attendance System - API Documentation');
          expect(res.text).toContain('SwaggerUIBundle');
        });
    });

    it('should serve OpenAPI 3.0 specification JSON on /api/v1/docs/json', () => {
      return request(app.getHttpServer())
        .get('/api/v1/docs/json')
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('data');
          expect(res.body.data).toHaveProperty('openapi', '3.0.3');
          expect(res.body.data.info).toHaveProperty('title');
          expect(res.body.data.paths).toHaveProperty('/auth/login');
          expect(res.body.data.paths).toHaveProperty('/sessions/start');
          expect(res.body.data.paths).toHaveProperty('/attendance/sync');
          expect(res.body.data.paths).toHaveProperty('/reports/sections/{sectionId}');
        });
    });
  });
});
