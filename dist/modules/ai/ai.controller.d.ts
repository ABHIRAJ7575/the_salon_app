import { HfInferenceService } from './hf-inference.service';
export declare class AiController {
    private readonly hfService;
    constructor(hfService: HfInferenceService);
    searchStylists(query: string): Promise<{
        success: boolean;
        base64Image: string;
        message: string;
    }>;
}
