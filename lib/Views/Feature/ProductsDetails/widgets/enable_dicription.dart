import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Expandable product description with read more/less toggle.
class ExpandableDescription extends StatefulWidget {
  final String text;
  final bool isDark;

  const ExpandableDescription({
    required this.text,
    required this.isDark,
  });

  @override
  State<ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<ExpandableDescription>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _toggle() {
    HapticFeedback.selectionClick();
    _expanded = !_expanded;
    if (_expanded) {
      _anim.forward();
    } else {
      _anim.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState: _expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: Text(
            widget.text,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              height: 1.65,
              color: widget.isDark
                  ? const Color(0xFFAEAEB2)
                  : const Color(0xFF4A4A4A),
            ),
          ),
          secondChild: Text(
            widget.text,
            style: TextStyle(
              fontSize: 14,
              height: 1.65,
              color: widget.isDark
                  ? const Color(0xFFAEAEB2)
                  : const Color(0xFF4A4A4A),
            ),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _toggle,
          child: Text(
            _expanded ? 'Read less ↑' : 'Read more ↓',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFFFF6B00),
            ),
          ),
        ),
      ],
    );
  }
}