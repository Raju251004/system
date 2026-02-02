import {
  Controller,
  Post,
  Body,
  UseGuards,
  Request,
  Get,
  UnauthorizedException,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import { CreateUserDto } from '../users/dto/create-user.dto';
import { LoginDto } from './dto/login.dto';
import { AuthGuard } from '@nestjs/passport';
import { UsersService } from '../users/users.service';

@Controller('auth')
export class AuthController {
  constructor(
    private authService: AuthService,
    private usersService: UsersService,
  ) {}

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
      throw new UnauthorizedException('Invalid credentials');
    }
    return this.authService.login(user); // returns token and basic user info
  }

  @UseGuards(AuthGuard('jwt'))
  @Get('profile')
  async getProfile(@Request() req: { user: { userId: string } }) {
    // Fetch fresh user data from DB to get isOnboardingCompleted status
    // req.user has userId from JwtStrategy
    const user = await this.usersService.findOne(req.user.userId);
    if (!user) {
      throw new UnauthorizedException('User not found');
    }
    // Remove passwordHash from response
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    const { passwordHash, ...result } = user;
    return result;
  }
}
