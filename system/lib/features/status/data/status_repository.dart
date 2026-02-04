import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:system/features/status/domain/user_model.dart';
import 'package:system/core/api/api_client.dart';

final statusRepositoryProvider = Provider<StatusRepository>((ref) {
  return StatusRepository(ref.watch(dioProvider));
});

class StatusRepository {
  final Dio _dio;

  StatusRepository(this._dio);

  Future<User> getProfile() async {
    try {
      final response = await _dio.get('/auth/profile');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        throw Exception(
          e.response!.data['message'] ?? 'Failed to fetch status',
        );
      }
      throw Exception('Failed to fetch status: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch status: ${e.toString()}');
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      await _dio.post('/auth/profile', data: data);
    } on DioException catch (e) {
       throw Exception('Failed to update profile: ${e.message}');
    }
  }
}
