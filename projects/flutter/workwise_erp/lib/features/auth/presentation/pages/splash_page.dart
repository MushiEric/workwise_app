import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/provider/tenant_provider.dart';
import '../../../../core/provider/token_provider.dart';
import '../providers/auth_providers.dart';

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
    _scaleAnim = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

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
  ///  - No tenant configured  → `/workspace`
  ///  - No stored token       → `/` (login)
  ///  - Token + API success   → `/index` (home)
  ///  - Token + API failure   → `/` (login; repository already cleared the
  ///                            stale token on any server-side error)
  Future<void> _resolveRoute() async {
    try {
      // 1. Tenant must be configured before any API calls.
      final tenant = ref.read(tenantProvider);
      if (tenant == null) {
        _targetRoute = '/workspace';
        return;
      }

      // 2. No stored token → go straight to login.
      final token = await ref.read(tokenLocalDataSourceProvider).readToken();
      if (token == null || token.isEmpty) {
        _targetRoute = '/';
        return;
      }

      // 3. Token found — silently try to restore the session.
      // The spinner on the splash screen acts as the loading indicator;
      // no extra dialog is needed.
      await ref.read(authNotifierProvider.notifier).loadCurrentUser();
      if (!mounted) return;

      final s = ref.read(authNotifierProvider);
      s.maybeWhen(
        authenticated: (_) => _targetRoute = '/index',
        // Any failure (network, server, etc.) → send to login.
        // The repository already wiped the token for server errors.
        orElse: () => _targetRoute = '/',
      );
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
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 240,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: CupertinoActivityIndicator(
                      radius: 15.r,
                      
                  )
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
