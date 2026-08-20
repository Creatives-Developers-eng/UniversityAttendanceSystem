import { Injectable } from '@nestjs/common';
import * as crypto from 'crypto';

@Injectable()
export class BiometricsCryptoService {
  private readonly algorithm = 'aes-256-gcm';

  /**
   * Computes SHA-256 hash of a biometric embedding vector or string
   */
  hashTemplate(data: string): string {
    return crypto.createHash('sha256').update(data).digest('hex');
  }

  /**
   * Validates SHA-256 format
   */
  isValidHash(hash: string): boolean {
    return /^[a-fA-F0-9]{64}$/.test(hash);
  }
}
