import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  group('AuthService Login Tests', () {
    final mockFirebaseAuth = MockFirebaseAuth();
    final mockUserCredential = MockUserCredential();

    setUp(() {
      
    });

    test('Inicio de sesión exitoso', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'jimenezjoseline310@gmail.com',
        password: '123456',
      )).thenAnswer((_) async => mockUserCredential);

      var result = await mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'jimenezjoseline310@gmail.com',
        password: '123456',
      );

      expect(result, isA<UserCredential>());
    });

    test('Inicio de sesión fallido - credenciales incorrectas', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'user.com',
        password: 'Password12',
      )).thenThrow(FirebaseAuthException(code: 'user-not-found'));

      expect(
        () async => await mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'user.com',
          password: 'Password12',
        ),
        throwsA(isA<FirebaseAuthException>()),
      );
    });

    test('Inicio de sesión fallido - credenciales incorrectas', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'user@gmail.com',
        password: 'Password',
      )).thenThrow(FirebaseAuthException(code: 'user-not-found'));

      expect(
        () async => await mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'user@gmail.com.com',
          password: 'Password',
        ),
        throwsA(isA<FirebaseAuthException>()),
      );
    });
  });
}
