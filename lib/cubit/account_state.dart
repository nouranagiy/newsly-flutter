import '../data/models/saved_article.dart';
import '../data/models/user_profile.dart';

sealed class AccountState {
  const AccountState();
}

class AccountLoading extends AccountState {
  const AccountLoading();
}

class AccountSignedOut extends AccountState {
  const AccountSignedOut();
}

class AccountFailure extends AccountState {
  final AccountError error;

  const AccountFailure(this.error);
}

enum AccountError { loadProfile, saveCategories }

/// Authenticated but no categories chosen yet → show onboarding.
class AccountNeedsOnboarding extends AccountState {
  final UserProfile profile;
  final bool saving;

  const AccountNeedsOnboarding({required this.profile, this.saving = false});

  AccountNeedsOnboarding copyWith({UserProfile? profile, bool? saving}) {
    return AccountNeedsOnboarding(
      profile: profile ?? this.profile,
      saving: saving ?? this.saving,
    );
  }
}

/// Fully set up user: profile + interaction state ready to drive feeds.
class AccountReady extends AccountState {
  final UserProfile profile;
  final Set<String> likedIds;
  final Set<String> dislikedIds;
  final List<SavedArticle> savedArticles;

  const AccountReady({
    required this.profile,
    required this.likedIds,
    required this.dislikedIds,
    required this.savedArticles,
  });

  Set<String> get savedArticleIds => {
    for (final saved in savedArticles) '${saved.article.id}',
  };

  AccountReady copyWith({
    UserProfile? profile,
    Set<String>? likedIds,
    Set<String>? dislikedIds,
    List<SavedArticle>? savedArticles,
  }) {
    return AccountReady(
      profile: profile ?? this.profile,
      likedIds: likedIds ?? this.likedIds,
      dislikedIds: dislikedIds ?? this.dislikedIds,
      savedArticles: savedArticles ?? this.savedArticles,
    );
  }
}
