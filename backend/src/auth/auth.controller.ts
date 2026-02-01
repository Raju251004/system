import {
  Controller,
  Post,
  Body,
  UseGuards,
  Request,
  Get,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import { CreateUserDto } from '../users/dto/create-user.dto';
import { LoginDto } from './dto/login.dto';
import { AuthGuard } from '@nestjs/passport';

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('register')
  async register(@Body() createUserDto: CreateUserDto) {
    return this.authService.register(createUserDto);
  }

  @Post('login')
  async login(@Body() loginDto: LoginDto) {
    // In a real app, use LocalGuard, but for simplicity we validate manually or trust the service
    // Here we assume the service validation happens before or we use a guard.
    // Let's call validateUser manually or assume loginDto has user.
    // Ideally: LocalAuthGuard calls validateUser.

    // For now, let's implement the quick path:
    const user = await this.authService.validateUser(
      loginDto.email,
      loginDto.password,
    );
    if (!user) {
      return { message: 'Invalid credentials' };
    }
    return this.authService.login(user);
  }

  @UseGuards(AuthGuard('jwt'))
  @Get('profile')
  getProfile(
    @Request()
    req: {
      user: { userId: string; username: string; email: string };
    },
  ): { userId: string; username: string; email: string } {
    return req.user;
  }
}
