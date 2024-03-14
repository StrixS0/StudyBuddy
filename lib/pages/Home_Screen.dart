import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart'; // Asegúrate de que esta ruta sea correcta para tu proyecto

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? userName; // Variable para almacenar el nombre completo del usuario

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    User? user = _auth.currentUser;
    final uid = user?.uid;

    if (uid != null) {
      var userData = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .get();
      setState(() {
        // Aquí concatenamos el nombre y el apellido
        userName =
            "${userData.data()?['nombre']} ${userData.data()?['apellido']}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hola ${userName ?? 'Usuario'}!"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName:
                  Text(userName ?? 'Usuario'), // Muestra el nombre y apellido
              accountEmail: Text(_auth.currentUser?.email ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  userName?.substring(0, 1) ?? 'U', // Iniciales del usuario
                  style: const TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Editar Perfil'),
              onTap: () {
                // Acción al presionar 'Editar Perfil'
                Navigator.pop(context); // Cierra el Drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Política de Privacidad'),
              onTap: () {
                // Acción al presionar 'Política de Privacidad'
                Navigator.pop(context); // Cierra el Drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Cerrar sesión'),
              onTap: () async {
                await _auth.signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginScreen()));
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Bienvenido a la aplicación, ${userName ?? 'Usuario'}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
                const SizedBox(height: 20),
                // Aquí puedes añadir más widgets según la lógica de tu aplicación
              ],
            ),
          ),
        ),
      ),
    );
  }
}
