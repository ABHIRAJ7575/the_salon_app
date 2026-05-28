import { HfInferenceService } from './hf-inference.service';
export declare class AiController {
    private readonly hfService;
    constructor(hfService: HfInferenceService);
    searchStylists(query: string): Promise<{
        id: string;
        name: string;
        specialty: string;
        distance: string;
    }[]>;
}
