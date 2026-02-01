import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';

final statusRepositoryProvider = Provider<StatusRepository>((ref) {
  return StatusRepository(ref.watch(dioProvider));
});

class StatusRepository {
  final Dio _dio;

  StatusRepository(this._dio);

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _dio.get('/auth/profile');
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch status: ${e.toString()}');
    }
  }
}
