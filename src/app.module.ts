import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { UsersModule } from './users/users.module';

@Module({
  imports: [
    TypeOrmModule.forRoot({
    type: 'mysql',
    host: '10.217.5.159',
    port: 3306,
    username: 'root',
    password: 'root',
    database: 'test',
    autoLoadEntities: true,
    synchronize: true,
  }),
  UsersModule
],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
