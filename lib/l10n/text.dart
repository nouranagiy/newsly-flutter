import '../cubit/account_state.dart';
import 'app_localizations.dart';

/// Maps an [AccountError] to the localized message shown to the user.
String accountErrorMessage(AppLocalizations l10n, AccountError error) {
  return switch (error) {
    AccountError.loadProfile => l10n.errorLoadProfile,
    AccountError.saveCategories => l10n.errorSavePreferences,
  };
}

/// Returns the localized label for a category slug (see kNewsCategories).
String categoryLabel(AppLocalizations l10n, String slug) {
  return switch (slug) {
    'technology' => l10n.categoryTechnology,
    'sports' => l10n.categorySports,
    'business' => l10n.categoryBusiness,
    'politics' => l10n.categoryPolitics,
    'health' => l10n.categoryHealth,
    'entertainment' => l10n.categoryEntertainment,
    'science' => l10n.categoryScience,
    'world' => l10n.categoryWorld,
    'automotive' => l10n.categoryAutomotive,
    'travel' => l10n.categoryTravel,
    'food' => l10n.categoryFood,
    'education' => l10n.categoryEducation,
    'fashion' => l10n.categoryFashion,
    'lifestyle' => l10n.categoryLifestyle,
    _ => slug,
  };
}
