import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:the_salon_app/core/presentation/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AiSmartMirrorWorkspace extends StatefulWidget {
  const AiSmartMirrorWorkspace({super.key});

  @override
  State<AiSmartMirrorWorkspace> createState() => _AiSmartMirrorWorkspaceState();
}

class _AiSmartMirrorWorkspaceState extends State<AiSmartMirrorWorkspace> with SingleTickerProviderStateMixin {
  String? _selectedStyle;
  
  final List<Map<String, String>> _styleAdjustments = [
    {'id': 'classic_pompadour', 'name': 'Classic Pompadour', 'icon': '✂️'},
    {'id': 'buzz_cut', 'name': 'Buzz Cut', 'icon': '🪒'},
    {'id': 'corporate_beard', 'name': 'Corporate Beard', 'icon': '🧔'},
    {'id': 'slick_back', 'name': 'Slick Back', 'icon': '🕶️'},
  ];

  late AnimationController _meshPulseController;

  @override
  void initState() {
    super.initState();
    _meshPulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _meshPulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, 
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'AR SMART MIRROR',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 📷 LAYER 1: ISP Matrix Background
          _buildIspMatrixBackground(),
          
          // 📡 LAYER 2: FaceMesh targeting reticle CustomPainter
          _buildFaceMeshOverlay(),
          
          // 🎭 LAYER 3: AR Local Asset Matrix (Tracking Logic)
          if (_selectedStyle != null)
            _buildArOverlay(),
          
          // 🎛️ LAYER 4: UI Controls / Carousel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildStyleCarousel(),
          ),
        ],
      ),
    );
  }

  Widget _buildIspMatrixBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.5,
          colors: [
            Colors.blueGrey.shade900,
            Colors.black87,
            Colors.black,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Grid overlay for "camera stream matrix" feel
          CustomPaint(
            size: Size.infinite,
            painter: _GridPainter(opacity: 0.1),
          ),
          // Subtle glowing center node
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withOpacity(0.15),
                    blurRadius: 120,
                    spreadRadius: 60,
                  )
                ],
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
             .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.15, 1.15), duration: 3.seconds)
             .fade(duration: 3.seconds),
          ),
        ],
      ),
    );
  }

  Widget _buildFaceMeshOverlay() {
    return Center(
      child: AnimatedBuilder(
        animation: _meshPulseController,
        builder: (context, child) {
          return CustomPaint(
            size: const Size(250, 320),
            painter: _FaceMeshPainter(
              pulseValue: _meshPulseController.value,
              color: Colors.cyanAccent,
            ),
          );
        },
      ),
    );
  }

  Widget _buildArOverlay() {
    return Center(
      child: IgnorePointer(
        child: Container(
          width: 300,
          height: 350,
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(color: AppTheme.primaryBlue.withOpacity(0.2), blurRadius: 20)
                      ]
                    ),
                    child: Text(
                      'APPLYING: ${_selectedStyle?.toUpperCase()}',
                      style: const TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ).animate(key: ValueKey(_selectedStyle))
               .slideY(begin: -1.0, end: 0.0, curve: Curves.easeOutBack, duration: 500.ms)
               .fadeIn(duration: 500.ms),
              
              const SizedBox(height: 40),
              Icon(
                Icons.face_retouching_natural,
                size: 150,
                color: Colors.white.withOpacity(0.9),
              ).animate(key: ValueKey('icon_$_selectedStyle'))
               .scale(begin: const Offset(0.3, 0.3), end: const Offset(1.0, 1.0), curve: Curves.elasticOut, duration: 800.ms)
               .fadeIn(duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStyleCarousel() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: 180,
          padding: const EdgeInsets.only(top: 24, bottom: 32),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            border: Border(top: BorderSide(color: Colors.white.withOpacity(0.2))),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _styleAdjustments.length,
            itemBuilder: (context, index) {
              final style = _styleAdjustments[index];
              final isSelected = _selectedStyle == style['name'];
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedStyle = style['name'];
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  width: 130,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryBlue.withOpacity(0.5) : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected ? Colors.white.withOpacity(0.8) : Colors.white.withOpacity(0.2),
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: isSelected 
                      ? [BoxShadow(color: AppTheme.primaryBlue.withOpacity(0.4), blurRadius: 20, spreadRadius: 2)]
                      : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        style['icon']!,
                        style: const TextStyle(fontSize: 32),
                      ).animate(target: isSelected ? 1 : 0)
                       .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.2, 1.2), duration: 200.ms),
                      const SizedBox(height: 16),
                      Text(
                        style['name']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                          fontSize: 13,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate()
               .fadeIn(delay: (index * 150).ms, duration: 600.ms)
               .slideY(begin: 1.0, end: 0.0, curve: Curves.easeOutBack, duration: 700.ms, delay: (index * 150).ms);
            },
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final double opacity;
  _GridPainter({this.opacity = 0.1});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(opacity)
      ..strokeWidth = 0.5;

    const double step = 40.0;
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FaceMeshPainter extends CustomPainter {
  final double pulseValue;
  final Color color;

  _FaceMeshPainter({required this.pulseValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3 + (pulseValue * 0.5))
      ..strokeWidth = 1.5 + (pulseValue * 1.0)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final blurPaint = Paint()
      ..color = color.withOpacity(0.2 + (pulseValue * 0.3))
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5.0);

    final path = Path();

    // Draw a stylized bounding box / mesh outline
    const cornerLength = 40.0;

    void drawCorner(Offset start, Offset control, Offset end) {
      final cornerPath = Path()
        ..moveTo(start.dx, start.dy)
        ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);
      canvas.drawPath(cornerPath, blurPaint);
      canvas.drawPath(cornerPath, paint);
    }

    // Top Left
    drawCorner(
      const Offset(0, cornerLength),
      const Offset(0, 0),
      const Offset(cornerLength, 0),
    );

    // Top Right
    drawCorner(
      Offset(size.width - cornerLength, 0),
      Offset(size.width, 0),
      Offset(size.width, cornerLength),
    );

    // Bottom Right
    drawCorner(
      Offset(size.width, size.height - cornerLength),
      Offset(size.width, size.height),
      Offset(size.width - cornerLength, size.height),
    );

    // Bottom Left
    drawCorner(
      Offset(cornerLength, size.height),
      Offset(0, size.height),
      Offset(0, size.height - cornerLength),
    );

    // Center targeting reticles
    final centerPaint = Paint()
      ..color = color.withOpacity(0.5 + (pulseValue * 0.5))
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
      
    final cx = size.width / 2;
    final cy = size.height / 2;
    final cr = 20.0 + (pulseValue * 5.0);
    
    canvas.drawCircle(Offset(cx, cy), cr, centerPaint);
    canvas.drawLine(Offset(cx, cy - cr - 10), Offset(cx, cy - cr + 5), centerPaint);
    canvas.drawLine(Offset(cx, cy + cr - 5), Offset(cx, cy + cr + 10), centerPaint);
    canvas.drawLine(Offset(cx - cr - 10, cy), Offset(cx - cr + 5, cy), centerPaint);
    canvas.drawLine(Offset(cx + cr - 5, cy), Offset(cx + cr + 10, cy), centerPaint);

    // Some mesh-like lines inside
    final innerMeshPaint = Paint()
      ..color = color.withOpacity(0.1 + (pulseValue * 0.15))
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;
      
    final meshPath = Path()
      ..moveTo(cx - 50, cy - 80)
      ..lineTo(cx + 50, cy - 80)
      ..lineTo(cx + 80, cy)
      ..lineTo(cx + 50, cy + 80)
      ..lineTo(cx - 50, cy + 80)
      ..lineTo(cx - 80, cy)
      ..close();
      
    meshPath.moveTo(cx - 50, cy - 80);
    meshPath.lineTo(cx, cy);
    meshPath.lineTo(cx + 50, cy - 80);
    
    meshPath.moveTo(cx + 80, cy);
    meshPath.lineTo(cx, cy);
    meshPath.lineTo(cx + 50, cy + 80);
    
    meshPath.moveTo(cx - 50, cy + 80);
    meshPath.lineTo(cx, cy);
    meshPath.lineTo(cx - 80, cy);
      
    canvas.drawPath(meshPath, innerMeshPaint);
  }

  @override
  bool shouldRepaint(covariant _FaceMeshPainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue || oldDelegate.color != color;
  }
}
