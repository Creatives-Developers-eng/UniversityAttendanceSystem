import { Module } from '@nestjs/common';
import { BiometricsService } from './biometrics.service';
import { BiometricsController } from './biometrics.controller';
import { BiometricsCryptoService } from './biometrics-crypto.service';
import { PrismaModule } from '../../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  controllers: [BiometricsController],
  providers: [BiometricsService, BiometricsCryptoService],
  exports: [BiometricsService, BiometricsCryptoService],
})
export class BiometricsModule {}
