"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const testing_1 = require("@nestjs/testing");
const common_1 = require("@nestjs/common");
const request = require("supertest");
const app_controller_1 = require("./../src/app.controller");
const http_exception_filter_1 = require("./../src/common/filters/http-exception.filter");
const transform_interceptor_1 = require("./../src/common/interceptors/transform.interceptor");
describe('AppController (e2e)', () => {
    let app;
    beforeEach(async () => {
        const moduleFixture = await testing_1.Test.createTestingModule({
            controllers: [app_controller_1.AppController],
        }).compile();
        app = moduleFixture.createNestApplication();
        app.setGlobalPrefix('api/v1');
        app.useGlobalPipes(new common_1.ValidationPipe());
        app.useGlobalFilters(new http_exception_filter_1.HttpExceptionFilter());
        app.useGlobalInterceptors(new transform_interceptor_1.TransformInterceptor());
        await app.init();
    });
    afterEach(async () => {
        await app.close();
    });
    it('/api/v1/health (GET)', () => {
        return request(app.getHttpServer())
            .get('/api/v1/health')
            .expect(200)
            .expect((res) => {
            expect(res.body).toHaveProperty('statusCode', 200);
            expect(res.body).toHaveProperty('data');
            expect(res.body.data).toHaveProperty('status', 'OK');
            expect(res.body.data).toHaveProperty('service');
        });
    });
});
//# sourceMappingURL=app.e2e-spec.js.map