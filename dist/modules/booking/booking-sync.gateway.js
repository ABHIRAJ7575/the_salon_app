"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
var BookingSyncGateway_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.BookingSyncGateway = void 0;
const websockets_1 = require("@nestjs/websockets");
const socket_io_1 = require("socket.io");
const common_1 = require("@nestjs/common");
let BookingSyncGateway = BookingSyncGateway_1 = class BookingSyncGateway {
    constructor() {
        this.logger = new common_1.Logger(BookingSyncGateway_1.name);
    }
    async handleSlotReservation(data, client) {
        this.logger.log(`Received reservation request from client ${client.id} for slot ${data.slotId}`);
        setTimeout(() => {
            this.server.emit('slotReserved', { slotId: data.slotId, success: true });
            client.emit('reservationStatus', { success: true });
            this.logger.log(`Slot ${data.slotId} reserved successfully.`);
        }, 500);
    }
};
exports.BookingSyncGateway = BookingSyncGateway;
__decorate([
    (0, websockets_1.WebSocketServer)(),
    __metadata("design:type", socket_io_1.Server)
], BookingSyncGateway.prototype, "server", void 0);
__decorate([
    (0, websockets_1.SubscribeMessage)('reserveSlot'),
    __param(0, (0, websockets_1.MessageBody)()),
    __param(1, (0, websockets_1.ConnectedSocket)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, socket_io_1.Socket]),
    __metadata("design:returntype", Promise)
], BookingSyncGateway.prototype, "handleSlotReservation", null);
exports.BookingSyncGateway = BookingSyncGateway = BookingSyncGateway_1 = __decorate([
    (0, websockets_1.WebSocketGateway)({
        cors: {
            origin: '*',
        },
    })
], BookingSyncGateway);
//# sourceMappingURL=booking-sync.gateway.js.map