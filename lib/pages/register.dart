import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pia_moviles/pages/Home_Screen.dart';
import 'package:pia_moviles/pages/home_page.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? selectedCarrera;
  String? selectedSemestre;

  final List<String> carreras = [
    "IAS",
    "IB",
    "IAE",
    "IEA",
    "IEC",
    "IMF",
    "IMT",
    "IMTC",
    "ITS",
    "IMA",
    "IME",
  ];

  final List<String> semestres = [
    '1ero',
    '2do ',
    '3er ',
    '4to ',
    '5to ',
    '6to ',
    '7mo ',
    '8vo ',
    '9no ',
    '10mo'
  ];

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Las contraseñas no coinciden.")));
      return;
    }

    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(userCredential.user!.uid)
            .set({
          'nombre': firstNameController.text.trim(),
          'apellido': lastNameController.text.trim(),
          'telefono': phoneController.text.trim(),
          'email': emailController.text.trim(),
          'carrera': selectedCarrera,
          'semestre': selectedSemestre,
        });

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomePage()));
      }
    } on FirebaseAuthException catch (e) {
      var errorMessage =
          "Ocurrió un error al registrar. Por favor, inténtelo de nuevo.";
      if (e.code == 'weak-password') {
        errorMessage = "La contraseña proporcionada es demasiado débil.";
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "Ya existe una cuenta con este correo electrónico.";
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Image.asset(
                'lib/assets/study_buddy_logo.png', // Asegúrate de tener el logo en tus assets
                height: 120.0,
              ),
              const Text(
                'Regístrate',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 48.0),
              buildTextField(firstNameController, 'Nombre'),
              SizedBox(height: 8.0),
              buildTextField(lastNameController, 'Apellido'),
              SizedBox(height: 8.0),
              buildTextField(phoneController, 'Teléfono',
                  keyboardType: TextInputType.phone),
              SizedBox(height: 8.0),
              buildTextField(emailController, 'Email',
                  keyboardType: TextInputType.emailAddress),
              SizedBox(height: 8.0),
              buildTextField(passwordController, 'Contraseña',
                  obscureText: true),
              SizedBox(height: 8.0),
              buildTextField(confirmPasswordController, 'Confirmar Contraseña',
                  obscureText: true),
              SizedBox(height: 8.0),
              buildDropdown(carreras, selectedCarrera, (newValue) {
                setState(() {
                  selectedCarrera = newValue;
                });
              }, 'Carrera'),
              SizedBox(height: 8.0),
              buildDropdown(semestres, selectedSemestre, (newValue) {
                setState(() {
                  selectedSemestre = newValue;
                });
              }, 'Semestre'),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _registerUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple, 
                  foregroundColor: Colors.white, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text('Agregar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String hintText,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget buildDropdown(List<String> items, String? selectedItem,
      ValueChanged<String?> onChanged, String hintText) {
    return DropdownButtonFormField<String>(
      value: selectedItem,
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
