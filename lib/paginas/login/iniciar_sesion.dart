import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'crear_usuario.dart';
import '../maps/map.dart';

class IniciarSesion extends StatefulWidget {
  @override
  _IniciarSesionState createState() => _IniciarSesionState();
}

class _IniciarSesionState extends State<IniciarSesion> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isKeyboardVisible = false;
  bool _isPasswordVisible = false;
  String _errorMessage = '';
  String _emailError = ''; // Error específico para el correo
  String _passwordError = ''; // Error específico para la contraseña

  void _login() async {
    setState(() {
      _errorMessage = ''; // Limpia el mensaje de error general
      _emailError = ''; // Limpia el error de correo
      _passwordError = ''; // Limpia el error de contraseña
    });

    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Si el inicio de sesión es exitoso, navega a otra pantalla
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PantallaEjemplo()),
        );
      } on FirebaseAuthException catch (e) {
        _handleFirebaseAuthError(e); // Maneja el error específico de Firebase
      } catch (e) {
        setState(() {
          _errorMessage = 'Error desconocido: $e';
        });
      }

      _showErrorSnackBar();
    }
  }

  void _handleFirebaseAuthError(FirebaseAuthException e) {
    setState(() {
      switch (e.code) {
        case 'user-not-found':
          _emailError = 'No se encontró una cuenta con ese correo.';
          break;
        case 'wrong-password':
          _passwordError = 'Contraseña incorrecta.';
          break;
        case 'invalid-email':
          _emailError = 'El formato del correo es incorrecto.';
          break;
        case 'user-disabled':
          _errorMessage = 'La cuenta ha sido deshabilitada.';
          break;
        case 'invalid-credential':  // Añadir este caso
          _errorMessage = 'Las credenciales proporcionadas son incorrectas o han expirado.';
        break;
        default:
          _errorMessage = 'Ocurrió un error inesperado. Inténtalo de nuevo.';
      }
    });
    print('Firebase Auth Error: ${e.code} - ${e.message}');
  }

  void _showErrorSnackBar() {
    if (_errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage),
          backgroundColor: const Color(0xFF06141B),
          
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/im1.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: _isKeyboardVisible
                  ? MediaQuery.of(context).size.height * 0.50
                  : MediaQuery.of(context).size.height * 0.55,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Bienvenido de vuelta',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Ingresa tus credenciales',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 24),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Ingresa tu email',
                              filled: true,
                              fillColor: Colors.grey[100],
                              prefixIcon: Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              errorText: _emailError.isNotEmpty ? _emailError : null, // Muestra el error del correo
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa tu correo electrónico';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                return 'Por favor ingresa un correo electrónico válido';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              hintText: 'Ingresa tu contraseña',
                              filled: true,
                              fillColor: Colors.grey[100],
                              prefixIcon: Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              errorText: _passwordError.isNotEmpty ? _passwordError : null, // Muestra el error de la contraseña
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa tu contraseña';
                              }
                              if (value.length < 6) {
                                return 'La contraseña debe tener al menos 6 caracteres';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: Colors.blue,
                              ),
                              child: Text(
                                'Iniciar sesión',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Align(
                            alignment: Alignment.center,
                            child: RichText(
                              text: TextSpan(
                                text: 'No tienes cuenta? ',
                                style: TextStyle(color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Crea una',
                                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => RegistroScreen(),
                                          ),
                                        );
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: _isKeyboardVisible ? 20 : 0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
