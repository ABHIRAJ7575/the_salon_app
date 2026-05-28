import { Module } from '@nestjs/common';
import { AiController } from './modules/ai/ai.controller';
import { HfInferenceService } from './modules/ai/hf-inference.service';

@Module({
  imports: [],
  controllers: [AiController],
  providers: [HfInferenceService],
})
export class AppModule {}
