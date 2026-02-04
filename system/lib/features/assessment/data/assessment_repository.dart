import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';

final assessmentRepositoryProvider = Provider<AssessmentRepository>((ref) {
  return AssessmentRepository(ref.watch(dioProvider));
});

class AssessmentRepository {
  final Dio _dio;

  AssessmentRepository(this._dio);

  Future<void> submitAssessment(String type, Map<String, dynamic> data) async {
    try {
      await _dio.post('/assessment/submit', data: {
        'type': type,
        'data': data,
      });
    } on DioException catch (e) {
      throw Exception('Failed to submit assessment: ${e.response?.data['message'] ?? e.message}');
    }
  }

  Future<Map<String, dynamic>> getStats() async {
    try {
      final response = await _dio.get('/assessment/stats');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch stats: ${e.message}');
    }
  }
}
