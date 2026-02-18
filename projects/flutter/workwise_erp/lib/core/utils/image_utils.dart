// Helpers to safely convert a backend-provided image string into an ImageProvider.
// Handles: http(s) URLs, file:// URIs, server-relative paths (/storage/...), data: base64 URIs and simple fallbacks.

import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:workwise_erp/core/constants/api_constant.dart';

/// Returns an [ImageProvider] for the given [src] or `null` when the source is empty
/// or cannot be interpreted. This prevents passing invalid URIs to `NetworkImage`.
ImageProvider? imageProviderFromUrl(String? src) {
  if (src == null) return null;
  final s = src.trim();
  if (s.isEmpty) return null;

  // data URI (base64)
  if (s.startsWith('data:')) {
    try {
      final comma = s.indexOf(',');
      if (comma <= 0) return null;
      final payload = s.substring(comma + 1);
      final bytes = base64Decode(payload);
      return MemoryImage(bytes);
    } catch (_) {
      return null;
    }
  }

  // parse as URI when possible
  Uri? uri;
  try {
    uri = Uri.parse(s);
  } catch (_) {
    uri = null;
  }

  if (uri != null) {
    if (uri.scheme == 'http' || uri.scheme == 'https') return NetworkImage(s);
    if (uri.scheme == 'file') {
      try {
        final path = uri.toFilePath();
        return FileImage(File(path));
      } catch (_) {
        return null;
      }
    }
  }

  // server-relative path like: /storage/avatar.png --> prefix host (remove trailing /api from base)
  if (s.startsWith('/')) {
    final base = ApiConstant.baseUrl.replaceFirst(RegExp(r'/api/?$'), '');
    return NetworkImage('$base$s');
  }

  // relative path without scheme but looks like "profile/..."
  if (!s.contains('://') && s.contains('/')) {
    final base = ApiConstant.baseUrl.replaceFirst(RegExp(r'/api/?$'), '');
    return NetworkImage('$base/$s');
  }

  // fallback: attempt network image (this may still fail but is last-resort)
  return NetworkImage(s);
}
