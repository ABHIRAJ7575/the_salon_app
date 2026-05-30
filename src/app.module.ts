import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AiController } from './modules/ai/ai.controller';
import { HfInferenceService } from './modules/ai/hf-inference.service';

@Module({
  imports: [ConfigModule.forRoot({ isGlobal: true })],
  controllers: [AiController],
  providers: [HfInferenceService],
})
export class AppModule {}
