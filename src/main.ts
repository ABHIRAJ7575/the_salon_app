import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.enableCors();
  await app.listen(3000);
  console.log('===================================================');
  console.log('🚀 SALOON-OS BACKEND SUCCESSFULLY BOOTED ON PORT 3000');
  console.log('===================================================');
}
bootstrap();
