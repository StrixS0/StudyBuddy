import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart'; // Asegúrate de que esta ruta sea correcta para tu proyecto

// Definición de la clase Asesoria

class Asesoria {
  final String nombreMateria;
  final DateTime fecha;
  final String hora;
  final String modalidad;
  final String lugar;
  final String descripcion;
  final List<String> tags;
  final String? imagenURL;

  Asesoria({
    required this.nombreMateria,
    required this.fecha,
    required this.hora,
    required this.modalidad,
    required this.lugar,
    required this.descripcion,
    required this.tags,
    this.imagenURL,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? userName;
  List<Asesoria> asesorias = [];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadAsesorias();
  }

  Future<void> _loadUserInfo() async {
    User? user = _auth.currentUser;
    final uid = user?.uid;

    if (uid != null) {
      var userData = await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
      setState(() {
        userName = "${userData.data()?['nombre']} ${userData.data()?['apellido']}";
      });
    }
  }

  Future<void> _loadAsesorias() async {
    var asesoriasSnapshot = await FirebaseFirestore.instance.collection('asesorias').get();

    setState(() {
      asesorias = asesoriasSnapshot.docs.map((doc) => Asesoria(
        nombreMateria: doc['nombreMateria'],
        fecha: (doc.data()['fecha'] as Timestamp).toDate(),
        hora: doc.data()['hora'],
        modalidad: doc.data()['modalidad'],
        lugar: doc.data()['lugar'],
        descripcion: doc.data()['descripcion'],
        tags: List<String>.from(doc.data()['tags']),
        imagenURL: doc.data()['imagenURL'],
      )).toList();
    });
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
              children: asesorias.map((asesoria) {
                // fecha con formato
                String formattedDate = '${asesoria.fecha.year}-${asesoria.fecha.month.toString().padLeft(2, '0')}-${asesoria.fecha.day.toString().padLeft(2, '0')}';

                return Container(
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Text(
                          asesoria.nombreMateria,
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Fecha: $formattedDate", 
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              "Hora: ${asesoria.hora}",
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              "Modalidad: ${asesoria.modalidad}",
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              "Lugar: ${asesoria.lugar}",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 10),
                            Text(
                              asesoria.descripcion,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
