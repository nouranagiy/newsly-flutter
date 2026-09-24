import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:newsly/core/network/api_service.dart';
import 'package:newsly/cubit/account_cubit.dart';
import 'package:newsly/cubit/news_cubit.dart';
import 'package:newsly/cubit/news_state.dart';
import 'package:newsly/data/models/news_model.dart';
import 'package:newsly/data/models/user_profile.dart';
import 'package:newsly/data/repositories/news_repository.dart';
import 'package:newsly/data/repositories/session_repository.dart';
import 'package:newsly/main.dart';

class _StubNewsCubit extends NewsCubit {
  _StubNewsCubit(this.articles) : super(NewsRepository(ApiService()));

  final List<NewsModel> articles;

  @override
  Future<void> fetchNews() async {
    emit(NewsSuccess(articles));
  }
}

class _FakeSessionRepository implements SessionRepository {
  _FakeSessionRepository({this.profile, this.snapshot});

  final UserProfile? profile;
  final InteractionSnapshot? snapshot;

  @override
  Stream<UserSession?> get sessionChanges async* {
    yield UserSession(uid: 'u1', name: 'Test User', email: 'test@newsly.app');
  }

  @override
  Future<UserProfile?> getProfile(String uid) async => profile;

  @override
  Future<UserProfile> createProfile(UserSession session) async =>
      UserProfile(uid: session.uid, name: session.name, email: session.email);

  @override
  Future<void> saveCategories(String uid, List<String> categories) async {}

  @override
  Future<InteractionSnapshot> loadInteractions(String uid) async =>
      snapshot ?? const InteractionSnapshot();

  @override
  Future<void> setLike(String uid, NewsModel article, bool liked) async {}

  @override
  Future<void> setDislike(String uid, NewsModel article, bool disliked) async {}

  @override
  Future<void> setSaved(String uid, NewsModel article, bool saved) async {}

  @override
  Future<UserSession?> signIn({
    required String email,
    required String password,
  }) async => null;

  @override
  Future<UserSession?> signUp({
    required String name,
    required String email,
    required String password,
  }) async => null;

  @override
  Future<void> signOut() async {}
}

NewsModel _article({
  required int id,
  required String title,
  required List<String> tags,
}) {
  return NewsModel(
    id: id,
    title: title,
    body: '$title — full story.',
    tags: tags,
    views: 1000,
    likes: 50,
    dislikes: 2,
  );
}

const UserProfile _techProfile = UserProfile(
  uid: 'u1',
  name: 'Test User',
  email: 'test@newsly.app',
  preferredCategories: ['technology'],
);

Future<void> _pumpApp(
  WidgetTester tester, {
  List<NewsModel> articles = const [],
  UserProfile profile = _techProfile,
  InteractionSnapshot? snapshot,
}) async {
  // Tall viewport so the whole Profile tab (incl. the language switch at the
  // bottom) is built without scrolling.
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider<NewsCubit>(create: (_) => _StubNewsCubit(articles)),
        BlocProvider<AccountCubit>(
          create: (_) => AccountCubit(
            _FakeSessionRepository(profile: profile, snapshot: snapshot),
          ),
        ),
      ],
      child: const NewslyApp(),
    ),
  );
  // Let the fake account stream resolve from Loading → Ready and flush the
  // scheduled news fetch, then settle the first frame.
  await tester.pump();
  await tester.pump();
}

Brightness _brightness(WidgetTester tester) =>
    Theme.of(tester.element(find.byType(NavigationBar))).brightness;

void main() {
  testWidgets('renders the personalized feed with the first article', (
    tester,
  ) async {
    await _pumpApp(
      tester,
      articles: [
        _article(
          id: 1,
          title: 'Flutter 3.42 has landed',
          tags: ['flutter', 'tech'],
        ),
      ],
    );

    expect(find.text('Newsly'), findsOneWidget);
    expect(find.text('Search news...'), findsOneWidget);
    expect(find.text('Flutter 3.42 has landed'), findsOneWidget);
  });

  testWidgets('hides disliked articles from the feed', (tester) async {
    await _pumpApp(
      tester,
      articles: [
        _article(
          id: 1,
          title: 'Flutter 3.42 has landed',
          tags: ['flutter', 'tech'],
        ),
        _article(id: 2, title: 'The ocean is shrinking', tags: ['world']),
      ],
      profile: const UserProfile(
        uid: 'u1',
        name: 'Test User',
        email: 'test@newsly.app',
        preferredCategories: ['technology', 'world'],
      ),
      snapshot: const InteractionSnapshot(dislikedIds: {'2'}),
    );

    expect(find.text('Flutter 3.42 has landed'), findsOneWidget);
    expect(find.text('The ocean is shrinking'), findsNothing);
  });

  testWidgets('toggles between light and dark theme from Profile', (
    tester,
  ) async {
    await _pumpApp(
      tester,
      articles: [
        _article(
          id: 1,
          title: 'Flutter 3.42 has landed',
          tags: ['flutter', 'tech'],
        ),
      ],
    );

    final firstTheme = _brightness(tester);
    expect(firstTheme, equals(Brightness.light));

    // The dark-mode switch lives on the Profile tab.
    await tester.tap(find.byIcon(Icons.person_outline_rounded));
    await tester.pump();
    await tester.tap(find.byType(Switch));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(_brightness(tester), isNot(equals(firstTheme)));
  });

  testWidgets('switches the interface language to Arabic', (tester) async {
    await _pumpApp(
      tester,
      articles: [
        _article(
          id: 1,
          title: 'Flutter 3.42 has landed',
          tags: ['flutter', 'tech'],
        ),
      ],
    );

    await tester.tap(find.byIcon(Icons.person_outline_rounded));
    await tester.pump();

    expect(find.text('Profile'), findsNWidgets(2));
    await tester.tap(find.text('عربي'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('الملف الشخصي'), findsNWidgets(2));
  });
}
