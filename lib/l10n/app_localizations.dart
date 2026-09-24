import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get tabSaved;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search news...'**
  String get searchHint;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @loadingNews.
  ///
  /// In en, this message translates to:
  /// **'Loading news...'**
  String get loadingNews;

  /// No description provided for @loadingProfile.
  ///
  /// In en, this message translates to:
  /// **'Loading your profile...'**
  String get loadingProfile;

  /// No description provided for @loadingSaved.
  ///
  /// In en, this message translates to:
  /// **'Loading saved articles...'**
  String get loadingSaved;

  /// No description provided for @preparingFeed.
  ///
  /// In en, this message translates to:
  /// **'Preparing your feed...'**
  String get preparingFeed;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitle;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @newsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load news. Please check your internet connection.'**
  String get newsLoadError;

  /// No description provided for @errorLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Unable to load your profile. Please check your connection and try again.'**
  String get errorLoadProfile;

  /// No description provided for @errorSavePreferences.
  ///
  /// In en, this message translates to:
  /// **'Could not save your preferences. Please try again.'**
  String get errorSavePreferences;

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline - showing cached news'**
  String get offlineBanner;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @modeForYou.
  ///
  /// In en, this message translates to:
  /// **'For You'**
  String get modeForYou;

  /// No description provided for @modeTopStories.
  ///
  /// In en, this message translates to:
  /// **'Top Stories'**
  String get modeTopStories;

  /// No description provided for @emptyForYouTitle.
  ///
  /// In en, this message translates to:
  /// **'No stories match your interests'**
  String get emptyForYouTitle;

  /// No description provided for @emptyForYouMessage.
  ///
  /// In en, this message translates to:
  /// **'Try \"Top Stories\", or edit your interests from the header.'**
  String get emptyForYouMessage;

  /// No description provided for @emptyTopStoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'No news here yet'**
  String get emptyTopStoriesTitle;

  /// No description provided for @emptyTopStoriesMessage.
  ///
  /// In en, this message translates to:
  /// **'Check back soon or refresh the feed.'**
  String get emptyTopStoriesMessage;

  /// No description provided for @read.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get read;

  /// No description provided for @views.
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get views;

  /// No description provided for @likes.
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get likes;

  /// No description provided for @dislikes.
  ///
  /// In en, this message translates to:
  /// **'Dislikes'**
  String get dislikes;

  /// No description provided for @like.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get like;

  /// No description provided for @removeLike.
  ///
  /// In en, this message translates to:
  /// **'Remove like'**
  String get removeLike;

  /// No description provided for @dislike.
  ///
  /// In en, this message translates to:
  /// **'Dislike'**
  String get dislike;

  /// No description provided for @dislikedHidden.
  ///
  /// In en, this message translates to:
  /// **'Disliked - hidden from your feeds'**
  String get dislikedHidden;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @removeBookmark.
  ///
  /// In en, this message translates to:
  /// **'Remove bookmark'**
  String get removeBookmark;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @liked.
  ///
  /// In en, this message translates to:
  /// **'Liked'**
  String get liked;

  /// No description provided for @disliked.
  ///
  /// In en, this message translates to:
  /// **'Disliked'**
  String get disliked;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Newsly'**
  String get welcomeTitle;

  /// No description provided for @signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create an account to personalize your feed.'**
  String get signUpSubtitle;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to keep your news personalized.'**
  String get signInSubtitle;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameHint;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get nameRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get emailInvalid;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleaseWait;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @switchToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get switchToSignIn;

  /// No description provided for @switchToSignUp.
  ///
  /// In en, this message translates to:
  /// **'New here? Create an account'**
  String get switchToSignUp;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get invalidEmail;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get invalidCredentials;

  /// No description provided for @emailInUse.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists. Try signing in.'**
  String get emailInUse;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password should be at least 6 characters.'**
  String get weakPassword;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network problem. Check your connection and try again.'**
  String get networkError;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get genericError;

  /// No description provided for @pickInterestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick your interests'**
  String get pickInterestsTitle;

  /// No description provided for @pickInterestsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the topics you care about - your feed will be tuned to them.'**
  String get pickInterestsSubtitle;

  /// No description provided for @editInterestsHint.
  ///
  /// In en, this message translates to:
  /// **'Select the categories you want to see in \"For You\".'**
  String get editInterestsHint;

  /// No description provided for @editInterests.
  ///
  /// In en, this message translates to:
  /// **'Edit interests'**
  String get editInterests;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// No description provided for @categoryTechnology.
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get categoryTechnology;

  /// No description provided for @categorySports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get categorySports;

  /// No description provided for @categoryBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get categoryBusiness;

  /// No description provided for @categoryPolitics.
  ///
  /// In en, this message translates to:
  /// **'Politics'**
  String get categoryPolitics;

  /// No description provided for @categoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get categoryHealth;

  /// No description provided for @categoryEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get categoryEntertainment;

  /// No description provided for @categoryScience.
  ///
  /// In en, this message translates to:
  /// **'Science'**
  String get categoryScience;

  /// No description provided for @categoryWorld.
  ///
  /// In en, this message translates to:
  /// **'World'**
  String get categoryWorld;

  /// No description provided for @categoryAutomotive.
  ///
  /// In en, this message translates to:
  /// **'Automotive'**
  String get categoryAutomotive;

  /// No description provided for @categoryTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get categoryTravel;

  /// No description provided for @categoryFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get categoryFood;

  /// No description provided for @categoryEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get categoryEducation;

  /// No description provided for @categoryFashion.
  ///
  /// In en, this message translates to:
  /// **'Fashion'**
  String get categoryFashion;

  /// No description provided for @categoryLifestyle.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle'**
  String get categoryLifestyle;

  /// No description provided for @emptySavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing saved yet'**
  String get emptySavedTitle;

  /// No description provided for @emptySavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Tap the bookmark icon on any article to read it later.'**
  String get emptySavedMessage;

  /// No description provided for @newsDetails.
  ///
  /// In en, this message translates to:
  /// **'News Details'**
  String get newsDetails;

  /// No description provided for @articleStats.
  ///
  /// In en, this message translates to:
  /// **'Article stats'**
  String get articleStats;

  /// No description provided for @interests.
  ///
  /// In en, this message translates to:
  /// **'Interests'**
  String get interests;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @emptyInterests.
  ///
  /// In en, this message translates to:
  /// **'You have no interests selected yet - pick some so \"For You\" can tune your feed.'**
  String get emptyInterests;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @darkModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap to switch the look of the app'**
  String get darkModeSubtitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'English / العربية'**
  String get languageSubtitle;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
