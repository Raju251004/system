import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/widgets/status_window.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class StatusPage extends ConsumerStatefulWidget {
  const StatusPage({super.key});

  @override
  ConsumerState<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends ConsumerState<StatusPage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => debugPrint('onStatus: $val'),
        onError: (val) => debugPrint('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              _lastWords = val.recognizedWords;
              if (_lastWords.toLowerCase().contains("arise")) {
                _triggerAriseEffect();
              }
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _triggerAriseEffect() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        content: Text(
          "SHADOWS HAVE RISEN",
          style: Theme.of(
            context,
          ).textTheme.displayLarge?.copyWith(fontSize: 20),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background - subtle grid or darkness
          Container(color: Colors.black),

          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: StatusWindow(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "STATUS",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const Divider(color: Colors.cyan),
                      const SizedBox(height: 20),
                      _buildStatRow("NAME", "Sung Jin-Woo"),
                      _buildStatRow("JOB", "Shadow Monarch"),
                      _buildStatRow("TITLE", "Demon Hunter"),
                      const SizedBox(height: 20),
                      _buildStatRow("LEVEL", "146"),
                      _buildStatRow("HP", "93,300"),
                      _buildStatRow("MP", "12,180"),
                      const SizedBox(height: 20),
                      _buildStatRow("STR", "320"),
                      _buildStatRow("AGI", "295"),
                      _buildStatRow("INT", "210"),
                      _buildStatRow("VIT", "180"),
                      _buildStatRow("PER", "250"),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _listen,
        backgroundColor: _isListening
            ? Colors.red
            : Theme.of(context).colorScheme.primary,
        child: Icon(
          _isListening ? Icons.mic : Icons.mic_none,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
