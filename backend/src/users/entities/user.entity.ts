import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  OneToMany,
} from 'typeorm';
import { Assessment } from '../../assessment/entities/assessment.entity';

export enum Rank {
  E = 'E',
  D = 'D',
  C = 'C',
  B = 'B',
  A = 'A',
  S = 'S',
}

@Entity()
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  email: string;

  @Column({ select: false })
  passwordHash: string;

  @Column({ unique: true })
  username: string;

  @Column({ type: 'enum', enum: Rank, default: Rank.E })
  rank: Rank;

  @Column({ default: 1 })
  level: number;

  @Column({ default: 0 })
  currentXp: number;

  @Column({ default: 100 })
  xpToNextLevel: number;

  @Column({ default: 100 })
  hp: number;

  @Column({ default: 100 })
  maxHp: number;

  @Column({ default: 0 })
  currency: number; // Gold/Zenny

  @Column("text", { array: true, default: [] })
  titles: string[];

  @Column({
    type: 'jsonb',
    default: { str: 10, agi: 10, vit: 10, int: 10, per: 10 },
  })
  stats: {
    str: number;
    agi: number;
    vit: number;
    int: number;
    per: number;
  };

  @Column({ nullable: true })
  jobClass: string;

  @Column({ nullable: true })
  profilePicture: string; // URL or Asset ID

  @Column({ nullable: true })
  title: string;

  @Column({ default: false })
  isOnboardingCompleted: boolean;

  @Column({ default: 'NORMAL' })
  status: string; // NORMAL, PUNISHED

  @Column({ default: 0 })
  streak: number;

  @Column({ default: 0 })
  dailyQuestProgress: number;

  @Column({ type: 'timestamp', nullable: true })
  lastActiveDate: Date;

  @OneToMany(() => Assessment, (assessment) => assessment.user)
  assessments: Assessment[];

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
