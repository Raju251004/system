import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:system/core/theme/app_theme.dart';
import 'package:system/features/status/presentation/status_controller.dart';

class StatusScreen extends ConsumerWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(statusControllerProvider);

    return Scaffold(
      backgroundColor: AppTheme.voidBlack,
      appBar: AppBar(
        title: Text('STATUS', style: Theme.of(context).textTheme.displayMedium),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.systemBlue),
            onPressed: () {
              ref.read(statusControllerProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: state.when(
        data: (data) => _buildStatusBody(context, data),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text(
            'ERROR: ${err.toString()}',
            style: const TextStyle(color: AppTheme.alertRed),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBody(BuildContext context, Map<String, dynamic> data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInfoCard(context, data),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatTile(context, 'STR', data['strength'] ?? 10),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatTile(context, 'AGI', data['agility'] ?? 10),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatTile(
                  context,
                  'INT',
                  data['intelligence'] ?? 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildStatTile(context, 'VIT', data['vitality'] ?? 10),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatTile(context, 'PER', data['perception'] ?? 10),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Add Quest Navigation or other info here
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.systemBlue.withValues(alpha: 0.05),
        border: Border.all(color: AppTheme.systemBlue.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['username']?.toUpperCase() ?? 'UNKNOWN',
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            'JOB: ${data['job'] ?? 'NONE'}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            'TITLE: ${data['title'] ?? 'NONE'}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Divider(color: AppTheme.systemBlue),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'LEVEL: ${data['level'] ?? 1}',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              Text(
                'RANK: ${data['rank'] ?? 'E'}',
                style: const TextStyle(
                  color: AppTheme.gold,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile(BuildContext context, String label, dynamic value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.voidBlack,
        border: Border.all(color: AppTheme.systemBlue.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.systemBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$value',
            style: Theme.of(
              context,
            ).textTheme.displayMedium?.copyWith(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
