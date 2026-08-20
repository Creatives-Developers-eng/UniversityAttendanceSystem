"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const testing_1 = require("@nestjs/testing");
const common_1 = require("@nestjs/common");
const request = require("supertest");
const app_controller_1 = require("./../src/app.controller");
const docs_controller_1 = require("./../src/docs/docs.controller");
const http_exception_filter_1 = require("./../src/common/filters/http-exception.filter");
const transform_interceptor_1 = require("./../src/common/interceptors/transform.interceptor");
describe('University Attendance System E2E Matrix', () => {
    let app;
    beforeAll(async () => {
        const moduleFixture = await testing_1.Test.createTestingModule({
            controllers: [app_controller_1.AppController, docs_controller_1.DocsController],
        }).compile();
        app = moduleFixture.createNestApplication();
        app.setGlobalPrefix('api/v1');
        app.useGlobalPipes(new common_1.ValidationPipe());
        app.useGlobalFilters(new http_exception_filter_1.HttpExceptionFilter());
        app.useGlobalInterceptors(new transform_interceptor_1.TransformInterceptor());
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
//# sourceMappingURL=app.e2e-spec.js.map