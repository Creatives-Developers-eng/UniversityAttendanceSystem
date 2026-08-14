"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const testing_1 = require("@nestjs/testing");
const app_controller_1 = require("./app.controller");
describe('AppController', () => {
    let appController;
    beforeEach(async () => {
        const app = await testing_1.Test.createTestingModule({
            controllers: [app_controller_1.AppController],
        }).compile();
        appController = app.get(app_controller_1.AppController);
    });
    describe('getHealth', () => {
        it('should return status OK', () => {
            const result = appController.getHealth();
            expect(result).toHaveProperty('status', 'OK');
            expect(result).toHaveProperty('timestamp');
            expect(result).toHaveProperty('service');
        });
    });
});
//# sourceMappingURL=app.controller.spec.js.map