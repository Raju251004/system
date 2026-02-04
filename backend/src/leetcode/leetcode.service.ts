import { Injectable, HttpException } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { firstValueFrom } from 'rxjs';

export interface LeetCodeUserStats {
  submitStats: {
    acSubmissionNum: { difficulty: string; count: number }[];
  };
}

interface LeetCodeGraphQLResponse {
  data: {
    matchedUser: LeetCodeUserStats;
  };
  errors?: { message: string }[];
}

@Injectable()
export class LeetCodeService {
  constructor(private readonly httpService: HttpService) { }

  async getUserStats(username: string): Promise<LeetCodeUserStats> {
    const query = `
      query userProfile($username: String!) { 
        matchedUser(username: $username) { 
          submitStats: submitStatsGlobal { 
            acSubmissionNum { difficulty count } 
          } 
        } 
      }
    `;

    try {
      const response = await firstValueFrom(
        this.httpService.post<any>('https://leetcode.com/graphql', {
          query,
          variables: { username },
        }),
      );

      const data = response.data as LeetCodeGraphQLResponse;

      if (data.errors) {
        throw new Error(data.errors[0].message);
      }

      return data.data.matchedUser;
    } catch (error) {
      console.error('LeetCode API Error:', error);
      // Fallback or throw
      throw new HttpException('Failed to fetch LeetCode stats', 500);
    }
  }

  async getDailyProblem(): Promise<{ title: string; difficulty: string; link: string }> {
    const query = `
      query questionOfToday {
        activeDailyCodingChallengeQuestion {
          date
          link
          question {
            title
            difficulty
            titleSlug
          }
        }
      }
    `;

    try {
      const response = await firstValueFrom(
        this.httpService.post<any>('https://leetcode.com/graphql', { query }),
      );

      const data = response.data;
      if (data.errors) throw new Error(data.errors[0].message);

      const today = data.data.activeDailyCodingChallengeQuestion;
      return {
        title: today.question.title,
        difficulty: today.question.difficulty,
        link: `https://leetcode.com${today.link}`,
      };
    } catch (error) {
      console.error('LeetCode Daily Error:', error);
      // Fallback
      return {
        title: 'Two Sum',
        difficulty: 'Easy',
        link: 'https://leetcode.com/problems/two-sum/',
      };
    }
  }
}
