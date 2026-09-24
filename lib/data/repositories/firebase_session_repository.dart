import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../models/news_model.dart';
import '../models/saved_article.dart';
import '../models/user_profile.dart';
import 'session_repository.dart';

/// Firebase-backed implementation of [SessionRepository].
///
/// Layout:
/// - `users/{uid}`                  → profile (name, email, preferredCategories)
/// - `users/{uid}/interactions/{id}` → per-article user interaction state,
///                                     with a denormalized article snapshot so
///                                     the Saved screen needs no extra fetches.
class FirebaseSessionRepository implements SessionRepository {
  FirebaseSessionRepository({
    fb.FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  }) : _auth = auth ?? fb.FirebaseAuth.instance,
       _db = firestore ?? FirebaseFirestore.instance;

  final fb.FirebaseAuth _auth;
  final FirebaseFirestore _db;

  static UserSession? _toSession(fb.User? user) {
    if (user == null) return null;
    return UserSession(
      uid: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
    );
  }

  @override
  Stream<UserSession?> get sessionChanges =>
      _auth.authStateChanges().map(_toSession);

  @override
  Future<UserSession?> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _toSession(credential.user);
  }

  @override
  Future<UserSession?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user?.updateDisplayName(name);
    return _toSession(credential.user);
  }

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Future<UserProfile?> getProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    final data = doc.data();
    if (data == null) return null;
    return UserProfile(
      uid: uid,
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      preferredCategories: List<String>.from(
        data['preferredCategories'] as List? ?? const [],
      ),
    );
  }

  @override
  Future<UserProfile> createProfile(UserSession session) async {
    await _db.collection('users').doc(session.uid).set({
      'name': session.name,
      'email': session.email,
      'preferredCategories': const <String>[],
      'createdAt': FieldValue.serverTimestamp(),
    });
    return UserProfile(
      uid: session.uid,
      name: session.name,
      email: session.email,
    );
  }

  @override
  Future<void> saveCategories(String uid, List<String> categories) async {
    await _db.collection('users').doc(uid).set({
      'preferredCategories': categories,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<InteractionSnapshot> loadInteractions(String uid) async {
    final interactions = _interactions(uid);
    final disliked = await interactions
        .where('isDisliked', isEqualTo: true)
        .get();
    final liked = await interactions.where('isLiked', isEqualTo: true).get();
    final saved = await interactions.where('isSaved', isEqualTo: true).get();

    return InteractionSnapshot(
      likedIds: {for (final doc in liked.docs) doc.id},
      dislikedIds: {for (final doc in disliked.docs) doc.id},
      savedArticles: [
        for (final doc in saved.docs)
          SavedArticle(
            article: NewsModel.fromJson(
              Map<String, dynamic>.from(
                doc.data()['article'] as Map? ?? const {},
              ),
            ),
            savedAt: _dateFrom(doc.data()['savedAt']) ?? DateTime.now(),
          ),
      ],
    );
  }

  @override
  Future<void> setLike(String uid, NewsModel article, bool liked) =>
      _setInteraction(uid, article, {'isLiked': liked});

  @override
  Future<void> setDislike(String uid, NewsModel article, bool disliked) =>
      _setInteraction(uid, article, {'isDisliked': disliked});

  @override
  Future<void> setSaved(String uid, NewsModel article, bool saved) =>
      _setInteraction(uid, article, {
        'isSaved': saved,
        'savedAt': saved ? FieldValue.serverTimestamp() : FieldValue.delete(),
      });

  CollectionReference<Map<String, dynamic>> _interactions(String uid) =>
      _db.collection('users').doc(uid).collection('interactions');

  Future<void> _setInteraction(
    String uid,
    NewsModel article,
    Map<String, dynamic> fields,
  ) {
    return _interactions(uid).doc('${article.id}').set({
      'article': article.toJson(),
      'timestamp': FieldValue.serverTimestamp(),
      ...fields,
    }, SetOptions(merge: true));
  }

  static DateTime? _dateFrom(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}
