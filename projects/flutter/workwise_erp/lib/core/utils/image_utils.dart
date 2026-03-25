// Helpers to safely convert a backend-provided image string into an ImageProvider.
// Handles: http(s) URLs, file:// URIs, server-relative paths (/storage/...), data: base64 URIs and simple fallbacks.

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:workwise_erp/core/constants/api_constant.dart';

/// Returns an [ImageProvider] for the given [src] or `null` when the source is empty
/// or cannot be interpreted. This prevents passing invalid URIs to `NetworkImage`.
ImageProvider? imageProviderFromUrl(String? src) {
  if (src == null) return null;
  var s = src.trim();
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

  // Support explicit file URIs (e.g. file:///path/to/image.jpg or file://somefile.jpg)
  if (s.toLowerCase().startsWith('file://')) {
    // On web, FileImage is not supported and the file path is meaningless.
    // Fall back to showing a placeholder (null) so the UI can render initials.
    if (kIsWeb) return null;

    // Strip the scheme. The remaining string may be a valid file path or a
    // host-like string (e.g. "file://123.jpg").
    final raw = s.substring(7);
    if (raw.isEmpty || raw == '/') return null;
    return FileImage(File(raw));
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
      // Some servers may return file:// URIs without a host (e.g. "file:///1234.jpg").
      // Uri.toFilePath can throw in such cases, so fall back to using the raw path.
      try {
        final path = uri.toFilePath();
        return FileImage(File(path));
      } catch (_) {
        final path = uri.path;
        if (path.isNotEmpty) return FileImage(File(path));
        return null;
      }
    }
  }

  // server-relative path like: /storage/avatar.png or /profile/profile/... --> prefix host
  if (s.startsWith('/profile/')) {
    s = s.replaceFirst('/profile/', '/storage/');
  }

  if (s.startsWith('/')) {
    final base = ApiConstant.baseUrl.replaceFirst(RegExp(r'/api/?$'), '');
    return NetworkImage('$base$s');
  }

  // relative path without scheme but looks like "profile/..."
  if (!s.contains('://') && s.contains('/')) {
    final base = ApiConstant.baseUrl.replaceFirst(RegExp(r'/api/?$'), '');
    return NetworkImage('$base/$s');
  }

  // Bare filename with no scheme and no path separator (e.g. "1773479095.jpg").
  // Passing such a string to NetworkImage causes HttpClient to resolve it against
  // the app's base URI (file:///), producing "No host specified in URI file:///..."
  // errors. Return null so the UI can show initials instead.
  if (!s.contains('://') && !s.contains('/')) return null;

  // fallback: attempt network image (this may still fail but is last-resort)
  return NetworkImage(s);
}
