"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.HfInferenceService = void 0;
const common_1 = require("@nestjs/common");
let HfInferenceService = class HfInferenceService {
    async generateTextEmbedding(text) {
        console.log(`🚀 Offloading generation to the cloud for: "${text}"`);
        try {
            const response = await fetch(`https://image.pollinations.ai/prompt/${encodeURIComponent(text)}?nologo=true&width=1024&height=1024`, {
                method: 'GET',
            });
            if (!response.ok) {
                const err = await response.text();
                console.error(`💥 AI API tripped on a wire: ${err}`);
                throw new common_1.InternalServerErrorException('AI API failed. Blame the cloud provider, not me.');
            }
            const arrayBuffer = await response.arrayBuffer();
            const buffer = Buffer.from(arrayBuffer);
            return `data:image/jpeg;base64,${buffer.toString('base64')}`;
        }
        catch (error) {
            console.error('🔥 Epic failure in AI generation:', error);
            const placeholderBase64 = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==';
            return `data:image/png;base64,${placeholderBase64}`;
        }
    }
};
exports.HfInferenceService = HfInferenceService;
exports.HfInferenceService = HfInferenceService = __decorate([
    (0, common_1.Injectable)()
], HfInferenceService);
//# sourceMappingURL=hf-inference.service.js.map