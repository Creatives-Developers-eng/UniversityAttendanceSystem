import { Test, TestingModule } from '@nestjs/testing';
import { DocsController } from './docs.controller';

describe('DocsController', () => {
  let controller: DocsController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [DocsController],
    }).compile();

    controller = module.get<DocsController>(DocsController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  it('should return Swagger UI HTML', () => {
    const html = controller.getSwaggerUi();
    expect(html).toContain('University Attendance System - API Documentation');
    expect(html).toContain('SwaggerUIBundle');
  });

  it('should return OpenAPI specification JSON', () => {
    const json = controller.getOpenApiJson();
    expect(json.openapi).toBe('3.0.3');
    expect(json.info.title).toContain('University Attendance System');
    expect(json.paths).toHaveProperty('/auth/login');
  });
});
