import '../models/news_model.dart';
import '../models/saved_article.dart';
import '../models/user_profile.dart';

class InteractionSnapshot {
  final Set<String> likedIds;
  final Set<String> dislikedIds;
  final List<SavedArticle> savedArticles;

  const InteractionSnapshot({
    this.likedIds = const {},
    this.dislikedIds = const {},
    this.savedArticles = const [],
  });
}

/// Contract for the user accounts + personalization backend.
/// Implemented against Firebase Auth + Cloud Firestore, but kept abstract so
/// widgets can be tested with an in-memory fake.
abstract class SessionRepository {
  Stream<UserSession?> get sessionChanges;

  Future<UserSession?> signIn({
    required String email,
    required String password,
  });

  Future<UserSession?> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<UserProfile?> getProfile(String uid);

  Future<UserProfile> createProfile(UserSession session);

  Future<void> saveCategories(String uid, List<String> categories);

  Future<InteractionSnapshot> loadInteractions(String uid);

  Future<void> setLike(String uid, NewsModel article, bool liked);

  Future<void> setDislike(String uid, NewsModel article, bool disliked);

  Future<void> setSaved(String uid, NewsModel article, bool saved);
}
