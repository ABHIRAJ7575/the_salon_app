import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:the_salon_app/core/presentation/theme/app_theme.dart';
import 'package:the_salon_app/features/ai_salon/data/repositories/ai_diagnostic_repository.dart';

class AiDiagnosticWorkspace extends StatefulWidget {
  const AiDiagnosticWorkspace({super.key});

  @override
  State<AiDiagnosticWorkspace> createState() => _AiDiagnosticWorkspaceState();
}

class _AiDiagnosticWorkspaceState extends State<AiDiagnosticWorkspace> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final AiDiagnosticRepository _repository = AiDiagnosticRepository();

  bool _isScanning = false;
  List<dynamic> _recommendations = [];

  void _submitQuery() async {
    final query = _textController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isScanning = true;
      _recommendations = [];
    });

    try {
      final results = await _repository.searchStylists(query);
      setState(() {
        _recommendations = results;
      });
    } catch (e) {
      // Ignore errors for now or show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error analyzing request: $e')),
      );
    } finally {
      setState(() {
        _isScanning = false;
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryDeepNavy,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'AI Diagnostic Workspace',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _isScanning
                  ? _buildRadarScanner()
                  : _recommendations.isNotEmpty
                      ? _buildResultsList()
                      : _buildEmptyState(),
            ),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome,
            size: 64,
            color: Colors.white.withOpacity(0.5),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true)).scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 2.seconds),
          const SizedBox(height: 24),
          Text(
            'Describe your ideal style,\nand let AI find the perfect match.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white.withOpacity(0.8)),
          ),
        ],
      ).animate().fadeIn(duration: 800.ms),
    );
  }

  Widget _buildRadarScanner() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.5), width: 2),
            ),
          ).animate(onPlay: (controller) => controller.repeat()).scale(begin: const Offset(0.5, 0.5), end: const Offset(2.0, 2.0), duration: 1.5.seconds).fadeOut(duration: 1.5.seconds),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.8), width: 2),
            ),
          ).animate(onPlay: (controller) => controller.repeat()).scale(begin: const Offset(0.0, 0.0), end: const Offset(1.5, 1.5), duration: 1.5.seconds).fadeOut(duration: 1.5.seconds),
          const Icon(
            Icons.memory,
            size: 48,
            color: AppTheme.accentGold,
          ),
          Positioned(
            bottom: 40,
            child: const Text(
              'Analyzing...',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true)).fadeIn(duration: 500.ms),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _recommendations.length,
      itemBuilder: (context, index) {
        final stylist = _recommendations[index];
        return Card(
          color: Colors.white.withOpacity(0.1),
          margin: const EdgeInsets.only(bottom: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.white.withOpacity(0.2)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            leading: CircleAvatar(
              backgroundColor: AppTheme.primaryBlue,
              child: Text(
                stylist['name']?.substring(0, 1) ?? 'S',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              stylist['name'] ?? 'Stylist Name',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              stylist['specialty'] ?? 'Specialty',
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
            trailing: Text(
              '${(stylist['score'] * 100).toStringAsFixed(0)}% Match',
              style: const TextStyle(color: AppTheme.accentGold, fontWeight: FontWeight.bold),
            ),
          ),
        ).animate().fadeIn(delay: (index * 150).ms, duration: 400.ms).slideX(begin: 0.2, end: 0);
      },
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'e.g., "I need a balayage expert nearby"',
                hintStyle: TextStyle(color: AppTheme.textLight.withOpacity(0.5)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppTheme.lightGreyScaffold,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              onSubmitted: (_) => _submitQuery(),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _submitQuery,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppTheme.primaryBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
