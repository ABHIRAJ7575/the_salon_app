import { Injectable } from '@nestjs/common';

@Injectable()
export class HfInferenceService {
  async generateTextEmbedding(text: string): Promise<number[]> {
    console.log(`🧠 Simulating Hugging Face embedding generation for: "${text}"`);
    // Return a mock 5-dimensional vector to keep it fast and compilation-safe
    return [0.134, -0.456, 0.982, 0.012, -0.711];
  }
}
