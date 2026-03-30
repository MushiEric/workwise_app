import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/provider/token_provider.dart';
import '../../../../core/provider/tenant_provider.dart';
import '../../../../core/provider/permission_provider.dart';
import '../../../../core/themes/app_colors.dart';
import '../providers/auth_providers.dart';
import '../../../security/presentation/providers/security_providers.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;

  /// Resolved during [_resolveRoute]; used by [_checkAndNavigate] once both
  /// the splash animation and the session check have finished.
  String _targetRoute = '/';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnim = Tween<double>(
      begin: 0.82,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();

    // Run the minimum splash duration and the session check concurrently.
    // Navigation only happens once BOTH have completed.
    _checkAndNavigate();
  }

  /// Waits for the splash animation AND the session check, then navigates.
  Future<void> _checkAndNavigate() async {
    await Future.wait([
      Future.delayed(const Duration(milliseconds: 2200)),
      _resolveRoute(),
    ]);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(_targetRoute);
  }

  /// Determines the correct initial route:
  ///  - Developer Options enabled → `/security/developer_options_blocked`
  ///  - No stored token → `/` (login)
  ///  - Token + API success → `/index` (home)
  ///  - Token + API failure → `/` (login; repository already cleared the
  ///                            stale token on any server-side error)
  Future<void> _resolveRoute() async {
    try {
      // 0. Security gate: block if Android Developer Options is on.
      final securityStatus = await ref.read(deviceSecurityProvider.future);
      if (securityStatus.isDeveloperOptionsEnabled) {
        _targetRoute = '/security/developer_options_blocked';
        return;
      }

      // 1. No stored workspace -> ask the user to enter one.
      final tenantBaseUrl = await ref
          .read(tenantLocalDataSourceProvider)
          .readTenant();
      if (tenantBaseUrl == null || tenantBaseUrl.isEmpty) {
        _targetRoute = '/workspace';
        return;
      }

      // 2. No stored token -> go straight to login.
      final token = await ref.read(tokenLocalDataSourceProvider).readToken();
      if (token == null || token.isEmpty) {
        _targetRoute = '/';
        return;
      }

      // 3. Token found — silently try to restore the session.
      // The spinner on the splash screen acts as the loading indicator;
      // no extra dialog is needed.
      try {
        await ref
            .read(authNotifierProvider.notifier)
            .loadCurrentUser()
            .timeout(const Duration(seconds: 6));
      } on TimeoutException {
        // Prevent the app from hanging at the splash screen if the server
        // is unreachable or the request stalls.
        _targetRoute = '/';
        return;
      }
      if (!mounted) return;

      final s = ref.read(authNotifierProvider);
      bool authenticated = false;
      s.maybeWhen(authenticated: (_) => authenticated = true, orElse: () {});

      if (authenticated) {
        // Ensure permissions are loaded before showing the main UI.
        // This keeps the home screen from flashing with missing modules.
        try {
          await ref.read(permissionsNotifierProvider.notifier).fetch();
        } catch (_) {
          // ignore failures; permissions will fallback to cached/empty
        }
        _targetRoute = '/index';
      } else {
        _targetRoute = '/';
      }
    } catch (_) {
      // Safety net: never leave the user on a blank screen.
      _targetRoute = '/';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background image set to contain to ensure its content (Workwise text) isn't cropped
          FadeTransition(
            opacity: _fadeAnim,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/home.png',
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width * 0.85,
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Work Smarter, ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                            letterSpacing: 0.3,
                          ),
                        ),
                        TextSpan(
                          text: 'Stay Organized',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Subtle overlay only at the bottom for loading text readability
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 200,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.0),
                    Colors.white.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),

          // Standardized Cupertino Loading Indicator at the bottom
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: const Center(
                child: CupertinoActivityIndicator(radius: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
