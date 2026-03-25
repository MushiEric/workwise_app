import 'package:flutter/material.dart';
import 'package:workwise_erp/core/utils/image_utils.dart';

/// A circular avatar that gracefully falls back to initials when the network
/// image fails (e.g. 404). Uses [imageProviderFromUrl] so that server-relative
/// avatars (e.g. "/storage/..." or "/profile/...) are correctly resolved.
class AppCircleAvatar extends StatelessWidget {
  const AppCircleAvatar({
    super.key,
    required this.initials,
    required this.backgroundColor,
    this.imageUrl,
    this.radius,
  });

  final String initials;
  final Color backgroundColor;
  final String? imageUrl;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = radius ?? 20.0;
    final diameter = effectiveRadius * 2;
    final url = imageUrl;
    final imageProvider = url != null && url.isNotEmpty
        ? imageProviderFromUrl(url)
        : null;

    return ClipOval(
      child: Container(
        width: diameter,
        height: diameter,
        color: backgroundColor,
        alignment: Alignment.center,
        child: imageProvider != null
            ? Image(
                image: imageProvider,
                width: diameter,
                height: diameter,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
