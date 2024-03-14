import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Home_Screen.dart';
import 'Search_Page.dart';
import 'My_Asesorias.dart';
import 'Add_Advisory.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Índice para el ítem actualmente seleccionado

  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
  }

  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const SimpleSearchInterface(),
    const Task(),
    AddAdvisory(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 47, 47, 47),
              Color.fromARGB(255, 204, 204, 204),
            ],
          ),
        ),
        child: Center(
          child: _widgetOptions
              .elementAt(_selectedIndex), // Muestra el widget seleccionado
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(
              icon: Icon(Icons.work_history), label: 'Asesorías'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Agregar'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
        type: BottomNavigationBarType
            .fixed, // Asegura que los íconos y textos siempre se muestren
      ),
    );
  }
}
