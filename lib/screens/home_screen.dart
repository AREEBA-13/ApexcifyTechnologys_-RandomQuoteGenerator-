import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/quote_provider.dart';
import '../widgets/quote_card.dart';

class PulsingText extends StatefulWidget {
  final String text;
  const PulsingText({Key? key, required this.text}) : super(key: key);

  @override
  State<PulsingText> createState() => _PulsingTextState();
}

class _PulsingTextState extends State<PulsingText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Text(
        widget.text,
        style: GoogleFonts.merriweather(
          fontStyle: FontStyle.italic,
          color: const Color(0xFF6B6B6B),
          fontSize: 16,
        ),
      ),
    );
  }
}

class NoisePatternPainter extends CustomPainter {
  final Color noiseColor;

  NoisePatternPainter({required this.noiseColor});

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);
    final paint = Paint()..color = noiseColor;
    for (int i = 0; i < 3000; i++) {
      final dx = random.nextDouble() * size.width;
      final dy = random.nextDouble() * size.height;
      canvas.drawRect(Rect.fromLTWH(dx, dy, 1.5, 1.5), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _fetchNewQuote(BuildContext context) async {
    final provider = Provider.of<QuoteProvider>(context, listen: false);
    await provider.fetchQuote();
    if (provider.errorMessage == null) {
      HapticFeedback.lightImpact();
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage!),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () {
              _fetchNewQuote(context);
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCD6D0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2D2D),
        elevation: 2,
        centerTitle: true,
        title: Text(
          'Quotes',
          style: GoogleFonts.merriweather(
            color: const Color(0xFFF5F5F0),
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background noise
          Positioned.fill(
            child: CustomPaint(
              painter: NoisePatternPainter(
                noiseColor: Colors.black.withOpacity(0.015),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Consumer<QuoteProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading && provider.currentQuote == null) {
                    return const PulsingText(text: "Gathering ink...");
                  }

                  if (provider.errorMessage != null && provider.currentQuote == null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Color(0xFF6B6B6B)),
                        const SizedBox(height: 16),
                        const Text(
                          "Couldn't load quote",
                          style: TextStyle(fontSize: 18, color: Color(0xFF2D2D2D)),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => _fetchNewQuote(context),
                          child: const Text(
                            "Tap to retry",
                            style: TextStyle(color: Color(0xFF7A8B99), fontSize: 16),
                          ),
                        ),
                      ],
                    );
                  }

                  if (provider.currentQuote != null) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onHorizontalDragEnd: (details) {
                            if (details.primaryVelocity != null && details.primaryVelocity!.abs() > 300) {
                              if (!provider.isLoading) {
                                HapticFeedback.lightImpact();
                                _fetchNewQuote(context);
                              }
                            }
                          },
                          child: AnimatedOpacity(
                            opacity: provider.isLoading ? 0.3 : 1.0,
                            duration: const Duration(milliseconds: 300),
                            child: QuoteCard(quote: provider.currentQuote!),
                          ),
                        ),
                        if (provider.isLoading)
                           const Positioned(
                             child: PulsingText(text: "Writing..."),
                           )
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: InkWell(
        onTap: () {
          final provider = Provider.of<QuoteProvider>(context, listen: false);
          if (!provider.isLoading) {
            HapticFeedback.lightImpact();
            _fetchNewQuote(context);
          }
        },
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFFCFBF7),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFF2D2D2D).withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.edit_outlined, color: Color(0xFF2D2D2D), size: 20),
              const SizedBox(width: 8),
              Text(
                'New Quote',
                style: GoogleFonts.roboto(
                  color: const Color(0xFF2D2D2D),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
