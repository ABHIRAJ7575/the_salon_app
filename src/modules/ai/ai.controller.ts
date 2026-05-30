import { Controller, Post, Body, InternalServerErrorException } from '@nestjs/common';
import { HfInferenceService } from './hf-inference.service';

@Controller('ai')
export class AiController {
  constructor(private readonly hfService: HfInferenceService) { }

  @Post('search')
  async searchStylists(@Body('query') query: string) {
    if (!query) {
      // User sent an empty string. Typical.
      throw new InternalServerErrorException('Query is empty. What exactly am I supposed to generate? A black hole?');
    }

    console.log('📬 Controller hit. Over-complicated microservices? No thanks. Just a clean, monolithic route serving real AI.');

    // Pass it to the service. Let the cloud handle the heavy lifting.
    const base64Image = await this.hfService.generateTextEmbedding(query);

    // Returning the structured payload exactly as the Flutter frontend expects. Contract driven development!
    return {
      success: true,
      base64Image: base64Image,
      message: "AI generation complete! Behold the power of cloud compute."
    };
  }
}
