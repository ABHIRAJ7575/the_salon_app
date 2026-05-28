import { Server, Socket } from 'socket.io';
export declare class BookingSyncGateway {
    server: Server;
    private readonly logger;
    handleSlotReservation(data: {
        slotId: string;
        userId: string;
    }, client: Socket): Promise<void>;
}
