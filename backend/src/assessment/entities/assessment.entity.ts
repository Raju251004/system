import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, CreateDateColumn } from 'typeorm';
import { User } from '../../users/entities/user.entity';

export enum AssessmentType {
    PUSHUPS = 'PUSHUPS',
    SQUATS = 'SQUATS',
    PLANK = 'PLANK',
    RUNNING = 'RUNNING',
    SKIPPING = 'SKIPPING',
    SIT_AND_REACH = 'SIT_AND_REACH',
}

@Entity()
export class Assessment {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @ManyToOne(() => User, (user) => user.assessments)
    user: User;

    @Column()
    userId: string;

    @Column({
        type: 'enum',
        enum: AssessmentType,
    })
    type: AssessmentType;

    // Stores raw input: { reps: 50 } or { time: 120 } or { distance: 1000, time: 300 }
    @Column({ type: 'jsonb' })
    data: Record<string, any>;

    @Column('float')
    score: number;

    @CreateDateColumn()
    createdAt: Date;
}
