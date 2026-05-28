import {
  WebSocketGateway,
  SubscribeMessage,
  MessageBody,
  ConnectedSocket,
  WebSocketServer,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { DataSource } from 'typeorm';
import { Logger } from '@nestjs/common';

@WebSocketGateway({
  cors: {
    origin: '*',
  },
})
export class BookingSyncGateway {
  @WebSocketServer()
  server: Server;

  private readonly logger = new Logger(BookingSyncGateway.name);

  // Note: In a real app, this would be injected via constructor
  // constructor(private readonly dataSource: DataSource) {}

  @SubscribeMessage('reserveSlot')
  async handleSlotReservation(
    @MessageBody() data: { slotId: string; userId: string },
    @ConnectedSocket() client: Socket,
  ) {
    this.logger.log(`Received reservation request from client ${client.id} for slot ${data.slotId}`);

    // In a fully wired application, we would use TypeORM's queryRunner for concurrency protection:
    /*
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction('SERIALIZABLE');

    try {
      // 1. Check if slot is available with pessimistic write lock
      const slot = await queryRunner.manager.findOne(SlotEntity, {
        where: { id: data.slotId },
        lock: { mode: 'pessimistic_write' },
      });

      if (!slot || slot.isReserved) {
        throw new Error('Slot already booked or unavailable');
      }

      // 2. Mark as reserved
      slot.isReserved = true;
      slot.reservedBy = data.userId;
      await queryRunner.manager.save(slot);

      // 3. Commit transaction
      await queryRunner.commitTransaction();

      // 4. Broadcast success to all clients to update their UI
      this.server.emit('slotReserved', { slotId: data.slotId, success: true });
      return { event: 'reservationStatus', data: { success: true } };

    } catch (err) {
      await queryRunner.rollbackTransaction();
      this.logger.error(`Failed to reserve slot: ${err.message}`);
      return { event: 'reservationStatus', data: { success: false, error: err.message } };
    } finally {
      await queryRunner.release();
    }
    */

    // Simulated response for this initial setup
    setTimeout(() => {
      this.server.emit('slotReserved', { slotId: data.slotId, success: true });
      client.emit('reservationStatus', { success: true });
      this.logger.log(`Slot ${data.slotId} reserved successfully.`);
    }, 500);
  }
}
