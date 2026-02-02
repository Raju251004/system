import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';

final assessmentRepositoryProvider = Provider<AssessmentRepository>((ref) {
  return AssessmentRepository(ref.watch(dioProvider));
});

class AssessmentRepository {
  final Dio _dio;

  AssessmentRepository(this._dio);

  Future<void> submitAssessment(Map<String, dynamic> data) async {
    try {
      await _dio.post('/assessment/submit', data: data);
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        throw Exception(
          e.response!.data['message'] ?? 'Failed to submit assessment',
        );
      }
      throw Exception('Failed to submit assessment: ${e.message}');
    } catch (e) {
      throw Exception('Failed to submit assessment: ${e.toString()}');
    }
  }
}
