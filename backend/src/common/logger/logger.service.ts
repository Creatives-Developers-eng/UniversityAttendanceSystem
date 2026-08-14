import { Injectable, Logger, Scope } from '@nestjs/common';

@Injectable({ scope: Scope.TRANSIENT })
export class AppLoggerService extends Logger {
  log(message: string, context?: string) {
    super.log(message, context || this.context);
  }

  error(message: string, trace?: string, context?: string) {
    super.error(message, trace, context || this.context);
  }

  warn(message: string, context?: string) {
    super.warn(message, context || this.context);
  }

  debug(message: string, context?: string) {
    super.debug(message, context || this.context);
  }

  verbose(message: string, context?: string) {
    super.verbose(message, context || this.context);
  }
}
