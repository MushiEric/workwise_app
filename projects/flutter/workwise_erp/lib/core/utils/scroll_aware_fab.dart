import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // <-- add this

/// A FloatingActionButton that reacts to scroll direction.
///
/// - Expands when scrolling up or when near top
/// - Collapses when scrolling down
/// - Uses hysteresis to avoid flicker
/// - Safely handles controller changes
class ScrollAwareFab extends StatefulWidget {
  final ScrollController controller;
  final VoidCallback? onPressed;
  final Widget icon;
  final String label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final ShapeBorder? shape;
  final Duration animationDuration;
  final double collapseThreshold; // how far user must scroll before toggling

  const ScrollAwareFab({
    super.key,
    required this.controller,
    required this.icon,
    required this.label,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.shape,
    this.animationDuration = const Duration(milliseconds: 250),
    this.collapseThreshold = 16,
  });

  @override
  State<ScrollAwareFab> createState() => _ScrollAwareFabState();
}

class _ScrollAwareFabState extends State<ScrollAwareFab> {
  bool _isExtended = true;
  double _lastOffset = 0;

  @override
  void initState() {
    super.initState();
    _attachController(widget.controller);
  }

  @override
  void didUpdateWidget(covariant ScrollAwareFab oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      _detachController(oldWidget.controller);
      _attachController(widget.controller);
    }
  }

  void _attachController(ScrollController controller) {
    controller.addListener(_handleScroll);

    if (controller.hasClients) {
      _lastOffset = controller.position.pixels;
    }
  }

  void _detachController(ScrollController controller) {
    controller.removeListener(_handleScroll);
  }

  @override
  void dispose() {
    _detachController(widget.controller);
    super.dispose();
  }

  void _handleScroll() {
    if (!widget.controller.hasClients) return;

    final offset = widget.controller.position.pixels;
    final direction = widget.controller.position.userScrollDirection;

    // Always extend when near top
    if (offset <= 50 && !_isExtended) {
      setState(() => _isExtended = true);
      _lastOffset = offset;
      return;
    }

    // Collapse on scroll down
    if (direction == ScrollDirection.reverse &&
        offset > _lastOffset + widget.collapseThreshold &&
        _isExtended) {
      setState(() => _isExtended = false);
    }

    // Extend on scroll up
    if (direction == ScrollDirection.forward &&
        offset < _lastOffset - widget.collapseThreshold &&
        !_isExtended) {
      setState(() => _isExtended = true);
    }

    _lastOffset = offset;
  }

  @override
 @override
Widget build(BuildContext context) {
  return Align(
    alignment: Alignment.bottomRight,
    child: AnimatedContainer(
      duration: widget.animationDuration,
      curve: Curves.easeOut,
      width: _isExtended ? 160 : 56, // expand from left
      height: 56,
      child: FloatingActionButton(
        onPressed: widget.onPressed,
        backgroundColor: widget.backgroundColor,
        foregroundColor: widget.foregroundColor,
        shape: widget.shape,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.icon,
            if (_isExtended) ...[
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  widget.label,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
              ),
            ]
          ],
        ),
      ),
    ),
  );
}
}