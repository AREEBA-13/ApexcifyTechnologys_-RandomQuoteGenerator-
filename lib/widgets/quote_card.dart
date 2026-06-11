import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/quote.dart';

class QuoteCard extends StatelessWidget {
  final Quote quote;

  const QuoteCard({Key? key, required this.quote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Random rotation between -3 and 3 degrees
    // We use a fixed seed based on quote id to keep the rotation stable for the same quote
    final random = math.Random(quote.id.hashCode);
    final double rotationDegrees = (random.nextDouble() * 6) - 3;
    final double rotationRadians = rotationDegrees * (math.pi / 180);

    // Pick a random bookmark color from the predefined palette
    final List<Color> bookmarkColors = [
      const Color(0xFF9EABA2), // Sage
      const Color(0xFFC88270), // Terracotta
      const Color(0xFFD4B872), // Mustard
      const Color(0xFF7A8B99), // Slate blue
      const Color(0xFFB5A1A5), // Dusty rose
    ];
    final Color bookmarkColor = bookmarkColors[random.nextInt(bookmarkColors.length)];

    return Transform.rotate(
      angle: rotationRadians,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        switchInCurve: Curves.easeOutBack,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (Widget child, Animation<double> animation) {
          final scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(animation);
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: child,
            ),
          );
        },
        child: Stack(
          key: ValueKey<String>(quote.id),
          children: [
            // Bottom paper in the stack
            Positioned.fill(
              child: Transform.translate(
                offset: const Offset(4, 12),
                child: Transform.rotate(
                  angle: 0.04,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCFBF7),
                      borderRadius: BorderRadius.circular(4.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 4.0,
                          offset: const Offset(2, 2),
                        ),
                      ],
                      border: Border.all(color: Colors.black.withOpacity(0.03)),
                    ),
                  ),
                ),
              ),
            ),
            // Middle paper in the stack
            Positioned.fill(
              child: Transform.translate(
                offset: const Offset(-2, 6),
                child: Transform.rotate(
                  angle: -0.02,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCFBF7),
                      borderRadius: BorderRadius.circular(4.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 4.0,
                          offset: const Offset(2, 2),
                        ),
                      ],
                      border: Border.all(color: Colors.black.withOpacity(0.03)),
                    ),
                  ),
                ),
              ),
            ),
            // Top paper (Main content)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFCFBF7), // Warm off-white paper color
                borderRadius: BorderRadius.circular(4.0), // Slight rounding
                boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8.0,
                offset: const Offset(2, 2),
              ),
              // Subtle inner-like shadow using a border
              Border.all(color: Colors.black.withOpacity(0.02), width: 1.0) == null ? const BoxShadow() : const BoxShadow(color: Colors.transparent)
            ],
            border: Border.all(color: Colors.black.withOpacity(0.03)),
          ),
          child: Stack(
            children: [
              // Bookmark ribbon
              Positioned(
                top: 0,
                left: 32,
                child: Container(
                  width: 24,
                  height: 48,
                  decoration: BoxDecoration(
                    color: bookmarkColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32.0, 64.0, 32.0, 48.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      quote.text,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.merriweather(
                        fontSize: 22,
                        height: 1.6,
                        color: const Color(0xFF2D2D2D),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '— ${quote.author}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: const Color(0xFF6B6B6B),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
            ),
          ],
        ),
      ),
    );
  }
}
