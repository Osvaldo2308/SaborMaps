import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Mock de FirebaseAuth y UserCredential
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUserCredential extends Mock implements UserCredential {}

// Ejemplo de AuthService (esquema simplificado)
class AuthService {
  final FirebaseAuth _auth;
  
  AuthService(this._auth);

  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      throw FirebaseAuthException(code: 'password-mismatch', message: 'Las contraseñas no coinciden');
    }
    
    // Registro en Firebase
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }
}

void main() {
  final mockFirebaseAuth = MockFirebaseAuth();
  final authService = AuthService(mockFirebaseAuth);
  final mockUserCredential = MockUserCredential();

  group('Pruebas de registro', () {
    test('Registro exitoso', () async {
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: 'joss12@gmail.com',
        password: 'Joss123',
      )).thenAnswer((_) async => mockUserCredential);

      var result = await authService.register(
        name: 'Joseline',
        email: 'joss12@gmail.com',
        password: 'Joss123',
        confirmPassword: 'Joss123',
      );

      expect(result, isA<UserCredential>());
    });

    test('Registro fallido - cuenta ya existente', () async {
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: 'jimenezjoseline310@gmail.com',
        password: 'Jim123',
      )).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

      expect(
        () async => await authService.register(
          name: 'Joseline',
          email: 'Jimenezjoseline310@gmail.com',
          password: 'Jim123',
          confirmPassword: 'Jim123',
        ),
        throwsA(isA<FirebaseAuthException>()),
      );
    });

    test('Registro fallido ', () async {
      expect(
        () async => await authService.register(
          name: 'Usuario',
          email: 'user@example.com',
          password: 'password123',
          confirmPassword: 'password456',
        ),
        throwsA(predicate((e) =>
          e is FirebaseAuthException &&
          e.code == 'password-mismatch' &&
          e.message == 'Las contraseñas no coinciden'
        )),
      );
    });
    
  });
}
