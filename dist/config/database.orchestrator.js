"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.DatabaseOrchestratorModule = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const mongoose_1 = require("@nestjs/mongoose");
let DatabaseOrchestratorModule = class DatabaseOrchestratorModule {
};
exports.DatabaseOrchestratorModule = DatabaseOrchestratorModule;
exports.DatabaseOrchestratorModule = DatabaseOrchestratorModule = __decorate([
    (0, common_1.Global)(),
    (0, common_1.Module)({
        imports: [
            typeorm_1.TypeOrmModule.forRootAsync({
                useFactory: () => ({
                    type: 'postgres',
                    host: process.env.POSTGRES_HOST || 'localhost',
                    port: parseInt(process.env.POSTGRES_PORT || '5432', 10),
                    username: process.env.POSTGRES_USER || 'admin',
                    password: process.env.POSTGRES_PASSWORD || 'secret',
                    database: process.env.POSTGRES_DB || 'the_salon_app',
                    autoLoadEntities: true,
                    synchronize: process.env.NODE_ENV !== 'production',
                    logging: true,
                }),
            }),
            mongoose_1.MongooseModule.forRootAsync({
                useFactory: () => ({
                    uri: process.env.MONGO_URI || 'mongodb://localhost:27017/salon_ai_logs',
                    connectionFactory: (connection) => {
                        connection.on('connected', () => {
                            console.log('MongoDB successfully connected');
                        });
                        connection.on('error', (err) => {
                            console.error('MongoDB connection error:', err);
                        });
                        return connection;
                    },
                }),
            }),
        ],
        exports: [typeorm_1.TypeOrmModule, mongoose_1.MongooseModule],
    })
], DatabaseOrchestratorModule);
//# sourceMappingURL=database.orchestrator.js.map