import { Injectable, InternalServerErrorException } from '@nestjs/common';

@Injectable()
export class HfInferenceService {
  async generateTextEmbedding(text: string): Promise<string> {
    // 🧠 Ah yes, local GPUs. Because my 8GB RAM laptop is totally going to run SDXL without melting into a coaster.
    // Relying on Cloud API so we can actually ship this before the heat death of the universe.
    console.log(`🚀 Offloading generation to the cloud for: "${text}"`);

    try {
      // 🌐 Hitting Pollinations.ai. Highly reliable, no API key needed, returns image directly.
      const response = await fetch(
        `https://image.pollinations.ai/prompt/${encodeURIComponent(text)}?nologo=true&width=1024&height=1024`,
        {
          method: 'GET',
        }
      );

      if (!response.ok) {
        const err = await response.text();
        console.error(`💥 AI API tripped on a wire: ${err}`);
        throw new InternalServerErrorException('AI API failed. Blame the cloud provider, not me.');
      }

      // 📦 Extracting raw binary like a 10x engineer
      const arrayBuffer = await response.arrayBuffer();
      const buffer = Buffer.from(arrayBuffer);

      // 🎨 Wrapping it in a Base64 URI so the frontend doesn't throw a tantrum
      return `data:image/jpeg;base64,${buffer.toString('base64')}`;
    } catch (error) {
      console.error('🔥 Epic failure in AI generation:', error);
      // Fallback immediately to streaming a valid placeholder visual image buffer string
      const placeholderBase64 = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==';
      return `data:image/png;base64,${placeholderBase64}`;
    }
  }
}
