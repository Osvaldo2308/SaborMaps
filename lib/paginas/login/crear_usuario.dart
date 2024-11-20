import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'iniciar_sesion.dart'; // Asegúrate de que este es el nombre correcto de tu pantalla de inicio de sesión

class RegistroScreen extends StatefulWidget {
  @override
  _RegistroScreenState createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isKeyboardVisible = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _acceptedTerms = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (!_acceptedTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Debes aceptar los Términos y Condiciones.')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        User? user = userCredential.user;
        if (user != null) {
          await user.updateDisplayName(_nameController.text.trim());
          await user.reload();
          user = _auth.currentUser;
        }

        print('Usuario registrado exitosamente: ${userCredential.user?.uid}');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registro exitoso. Redirigiendo al inicio de sesión...')),
        );

        await Future.delayed(Duration(seconds: 2));

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => IniciarSesion()),
          (Route<dynamic> route) => false,
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          _isLoading = false;
        });
        String errorMessage = '';

        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'Este correo ya está en uso.';
            break;
          case 'invalid-email':
            errorMessage = 'El formato del correo es inválido.';
            break;
          case 'operation-not-allowed':
            errorMessage = 'El registro de cuentas con correo y contraseña no está habilitado.';
            break;
          case 'weak-password':
            errorMessage = 'La contraseña es demasiado débil. Debe tener al menos 6 caracteres.';
            break;
          default:
            errorMessage = 'Ha ocurrido un error. Por favor, intenta de nuevo.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$errorMessage')),
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error inesperado: $e')),
        );
      }
    }
  }

  Future<void> _showTermsAndConditions() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Términos y Condiciones'),
          content: Container(
            width: double.maxFinite,
            child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Text(
                    'Términos y Condiciones',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Bienvenido/a a nuestra aplicación de recomendaciones de restaurantes. '
                    'Al utilizar esta aplicación, aceptas los siguientes términos y condiciones:',
                  ),
                  SizedBox(height: 12),
                  Text(
                    '1. Uso de la ubicación:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'La aplicación utilizará tu ubicación para mostrar restaurantes cercanos. '
                    'Asegúrate de otorgar los permisos necesarios para una experiencia óptima.',
                  ),
                  SizedBox(height: 12),
                  Text(
                    '2. Publicación de comentarios:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Puedes publicar comentarios sobre los restaurantes que visitas. '
                    'Sin embargo, estos serán anónimos y no se asociarán a tu identidad.',
                  ),
                  SizedBox(height: 12),
                  Text(
                    '3. Responsabilidad del contenido:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Nos reservamos el derecho de eliminar contenido ofensivo, inapropiado '
                    'o que incumpla las políticas de uso de la aplicación.',
                  ),
                  SizedBox(height: 12),
                  Text(
                    '4. Propósito de la aplicación:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'La aplicación tiene un propósito exclusivamente informativo. No garantizamos '
                    'la calidad o disponibilidad de los servicios de los restaurantes recomendados.',
                  ),
                  SizedBox(height: 12),
                  Text(
                    '5. Privacidad:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Los datos que recopilamos se utilizan únicamente para mejorar la experiencia '
                    'de la aplicación. Consulta nuestra política de privacidad para más detalles.',
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Si tienes preguntas o inquietudes, puedes contactarnos a través de nuestro soporte técnico.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
            ),
          ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/im1.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: _isKeyboardVisible
                  ? MediaQuery.of(context).size.height * 0.67
                  : MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Regístrate",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Crea una cuenta para explorar nuestra aplicación',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        label: "Nombre",
                        controller: _nameController,
                        icon: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu nombre';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        label: "Correo",
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        icon: Icons.email,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu correo electrónico';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Por favor ingresa un correo válido';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      _buildPasswordField(
                        label: "Contraseña",
                        controller: _passwordController,
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
                      _buildConfirmPasswordField(
                        label: "Confirmar Contraseña",
                        controller: _confirmPasswordController,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Las contraseñas no coinciden';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: _acceptedTerms,
                            onChanged: (value) {
                              setState(() {
                                _acceptedTerms = value!;
                              });
                            },
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: 'Acepto los ',
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: 'Términos y Condiciones',
                                    style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = _showTermsAndConditions,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      _isLoading
                          ? Center(child: CircularProgressIndicator())
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: _register,
                                child: Text(
                                  "Registrar",
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ),
                      SizedBox(height: 20),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: "Ya tienes una cuenta? ",
                            style: TextStyle(color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                text: "Inicia sesión",
                                style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => IniciarSesion(),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        hintText: label,
        prefixIcon: Icon(Icons.lock, color: Colors.black54),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.black54,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildConfirmPasswordField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !_isConfirmPasswordVisible,
      decoration: InputDecoration(
        hintText: label,
        prefixIcon: Icon(Icons.lock, color: Colors.black54),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.black54,
          ),
          onPressed: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    required String? Function(String?) validator,
    IconData? icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: label,
        prefixIcon: icon != null ? Icon(icon, color: Colors.black54) : null,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      validator: validator,
    );
  }
}
