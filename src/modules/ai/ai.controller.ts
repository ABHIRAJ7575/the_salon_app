import { Controller, Post, Body } from '@nestjs/common';
import { HfInferenceService } from './hf-inference.service';

@Controller('ai')
export class AiController {
  constructor(private readonly hfService: HfInferenceService) {}

  @Post('search')
  async searchStylists(@Body('query') query: string) {
    console.log('📬 Received incoming natural language search query:', query);
    // Directly trigger the mock embedding flow to ensure end-to-end functionality
    const mockEmbedding = await this.hfService.generateTextEmbedding(query);
    
    return [
      { id: '1', name: 'Arjun Sharma', specialty: 'Fade & Textured Crop Expert', distance: '1.2 km' },
      { id: '2', name: 'Rohan Verma', specialty: 'Vibrant Hair Coloring & Balayage', distance: '2.5 km' },
      { id: '3', name: 'Vikram Dixit', specialty: 'Premium Bridal & Beard Sculpting', distance: '3.1 km' }
    ];
  }
}
