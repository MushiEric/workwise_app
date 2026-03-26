import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/themes/app_colors.dart';

/// Full-screen blocker shown when Android Developer Options is detected.
/// The user cannot dismiss this screen; the only action is to exit the app.
class DeveloperOptionsBlockedPage extends StatelessWidget {
  const DeveloperOptionsBlockedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Prevent hardware back-button dismissal.
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Shield / warning icon
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3CD),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.security,
                    size: 48,
                    color: Color(0xFFF59E0B),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  context.l10n.developerOptionsBlockedTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  context.l10n.developerOptionsBlockedMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.55,
                    color: AppColors.white,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => SystemNavigator.pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      context.l10n.exitApp,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
