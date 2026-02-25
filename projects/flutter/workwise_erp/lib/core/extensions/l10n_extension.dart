import 'package:flutter/widgets.dart';
import 'package:workwise_erp/l10n/app_localizations.dart';

/// Convenience accessor so pages can call `context.l10n.someKey`
/// instead of the verbose `AppLocalizations.of(context)!.someKey`.
extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
