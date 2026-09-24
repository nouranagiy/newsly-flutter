import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/news_model.dart';
import '../data/models/saved_article.dart';
import '../data/models/user_profile.dart';
import '../data/repositories/session_repository.dart';
import 'account_state.dart';

/// Owns the signed-in session: auth stream, profile/onboarding gate, and the
/// per-user interaction state (likes, dislikes, saved articles).
///
/// Like/dislike/save are optimistic: the local state flips first, then the
/// Firestore write runs; on failure the previous state is restored.
class AccountCubit extends Cubit<AccountState> {
  AccountCubit(this._repository) : super(const AccountLoading()) {
    _sessionSubscription = _repository.sessionChanges.listen(_onSessionChanged);
  }

  final SessionRepository _repository;
  late final StreamSubscription<UserSession?> _sessionSubscription;
  UserSession? _currentSession;

  Future<void> _onSessionChanged(UserSession? session) async {
    _currentSession = session;
    if (session == null) {
      emit(const AccountSignedOut());
      return;
    }
    emit(const AccountLoading());
    try {
      var profile = await _repository.getProfile(session.uid);
      if (profile == null) {
        await _repository.createProfile(session);
        profile = UserProfile(
          uid: session.uid,
          name: session.name,
          email: session.email,
        );
      }
      final interactions = await _repository.loadInteractions(session.uid);
      if (profile.preferredCategories.isEmpty) {
        emit(AccountNeedsOnboarding(profile: profile));
      } else {
        emit(
          AccountReady(
            profile: profile,
            likedIds: interactions.likedIds,
            dislikedIds: interactions.dislikedIds,
            savedArticles: interactions.savedArticles,
          ),
        );
      }
    } catch (_) {
      emit(const AccountFailure(AccountError.loadProfile));
    }
  }

  Future<void> retry() {
    final session = _currentSession;
    if (session == null) {
      emit(const AccountSignedOut());
      return Future.value();
    }
    return _onSessionChanged(session);
  }

  Future<void> signIn({required String email, required String password}) async {
    await _repository.signIn(email: email, password: password);
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await _repository.signUp(name: name, email: email, password: password);
  }

  Future<void> signOut() async {
    await _repository.signOut();
  }

  /// Persists the chosen category slugs. Used both on first-run onboarding and
  /// when editing interests later from settings.
  Future<void> saveCategories(List<String> categories) async {
    final current = state;
    final uid = switch (current) {
      AccountNeedsOnboarding(:final profile) => profile.uid,
      AccountReady(:final profile) => profile.uid,
      _ => null,
    };
    if (uid == null) return;

    if (current is AccountNeedsOnboarding) {
      emit(current.copyWith(saving: true));
    }
    try {
      await _repository.saveCategories(uid, categories);
      final interactions = await _repository.loadInteractions(uid);
      final profile = current is AccountNeedsOnboarding
          ? current.profile
          : (current as AccountReady).profile;
      emit(
        AccountReady(
          profile: profile.copyWith(preferredCategories: categories),
          likedIds: interactions.likedIds,
          dislikedIds: interactions.dislikedIds,
          savedArticles: interactions.savedArticles,
        ),
      );
    } catch (_) {
      if (current is AccountNeedsOnboarding) {
        emit(current.copyWith(saving: false));
      } else {
        emit(current);
      }
      emit(const AccountFailure(AccountError.saveCategories));
    }
  }

  Future<void> toggleLike(NewsModel article) async {
    final ready = _ready;
    if (ready == null) return;
    final id = '${article.id}';
    final wasLiked = ready.likedIds.contains(id);
    final liked = {...ready.likedIds};
    final disliked = {...ready.dislikedIds};

    if (wasLiked) {
      liked.remove(id);
    } else {
      liked.add(id);
      disliked.remove(id); // like and dislike are mutually exclusive
    }
    emit(ready.copyWith(likedIds: liked, dislikedIds: disliked));

    try {
      await _repository.setLike(ready.profile.uid, article, !wasLiked);
      if (!wasLiked) {
        await _repository.setDislike(ready.profile.uid, article, false);
      }
    } catch (_) {
      emit(ready); // rollback
    }
  }

  Future<void> toggleDislike(NewsModel article) async {
    final ready = _ready;
    if (ready == null) return;
    final id = '${article.id}';
    final wasDisliked = ready.dislikedIds.contains(id);
    final liked = {...ready.likedIds};
    final disliked = {...ready.dislikedIds};

    if (wasDisliked) {
      disliked.remove(id);
    } else {
      disliked.add(id);
      liked.remove(id); // like and dislike are mutually exclusive
    }
    emit(ready.copyWith(likedIds: liked, dislikedIds: disliked));

    try {
      await _repository.setDislike(ready.profile.uid, article, !wasDisliked);
      if (!wasDisliked) {
        await _repository.setLike(ready.profile.uid, article, false);
      }
    } catch (_) {
      emit(ready); // rollback
    }
  }

  Future<void> toggleSave(NewsModel article) async {
    final ready = _ready;
    if (ready == null) return;
    final id = '${article.id}';
    final wasSaved = ready.savedArticleIds.contains(id);

    final List<SavedArticle> saved;
    if (wasSaved) {
      saved = ready.savedArticles
          .where((item) => '${item.article.id}' != id)
          .toList();
    } else {
      saved = [
        SavedArticle(article: article, savedAt: DateTime.now()),
        ...ready.savedArticles,
      ];
    }
    emit(ready.copyWith(savedArticles: saved));

    try {
      await _repository.setSaved(ready.profile.uid, article, !wasSaved);
    } catch (_) {
      emit(ready); // rollback
    }
  }

  AccountReady? get _ready =>
      state is AccountReady ? state as AccountReady : null;

  @override
  Future<void> close() {
    _sessionSubscription.cancel();
    return super.close();
  }
}
