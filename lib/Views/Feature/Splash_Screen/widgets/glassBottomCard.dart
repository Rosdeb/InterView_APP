import 'dart:ui';
import 'package:app_interview/Views/Base/Ios_effect/iosTapEffect.dart';
import 'package:flutter/material.dart';

import '../../../Base/AppText/appText.dart';

class GlassBottomCard extends StatefulWidget {
  final String badge;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const GlassBottomCard({
    super.key,
    this.badge = 'GET START',
    this.title = 'Start exploring',
    this.subtitle = 'Every great adventure begins\nwith a single word.',
    required this.onTap,
  });

  @override
  State<GlassBottomCard> createState() => _GlassBottomCardState();
}

class _GlassBottomCardState extends State<GlassBottomCard> with SingleTickerProviderStateMixin{
  late final AnimationController _anim;
  late final Animation<double> _scale;


  @override
  void initState() {

    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));


  }
  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.fromLTRB(28, 28, 28, 48),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
              border: Border(
                top: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [
                          const Icon(Icons.menu_book_rounded, color: Colors.white, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            widget.badge,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      AppText(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Subtitle
                      Text(
                        widget.subtitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Glass Arrow Button
                IosTapEffect(
                  onTap: () {
                    _anim.forward(from: 0);
                    Future.delayed(const Duration(milliseconds: 500));
                    widget.onTap();
                  },
                  child: ScaleTransition(
                    scale: _scale,
                    child: ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.18),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.35),
                              width: 1.2,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}