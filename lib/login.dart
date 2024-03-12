import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pia_moviles/register.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  void signUserIn(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inicio de sesión exitoso'),
          backgroundColor: Colors.green,
        ),
      );
      // Aquí podrías navegar a la siguiente pantalla después de un inicio de sesión exitoso
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      var errorMessage = 'Ocurrió un error al iniciar sesión';
      if (e.code == 'user-not-found') {
        print("No usuario");
        errorMessage = 'No se encontró un usuario con ese email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Contraseña incorrecta';
        print("password mala pa");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 47, 47, 47),
              const Color.fromARGB(255, 204, 204, 204)
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Icon(Icons.account_circle, size: 100.0, color: Colors.white),
                  SizedBox(height: 48.0),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Contraseña',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  ElevatedButton(
                    child: Text('Iniciar Sesión'),
                    onPressed: () => signUserIn(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.white, // background (button) color
                      foregroundColor: const Color.fromARGB(
                          255, 0, 0, 0), // foreground (text) color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextButton(
                    child: Text('¿No tienes una cuenta? Regístrate'),
                    onPressed: () {
                      // Aquí podrías navegar a la pantalla de registro
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => RegisterScreen()));
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
