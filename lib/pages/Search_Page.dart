import 'package:flutter/material.dart';

class SimpleSearchInterface extends StatelessWidget {
  const SimpleSearchInterface({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barra de Búsqueda'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200], // Color de fondo del campo de búsqueda
              ),
            ),
            // Agrega aquí más Widgets según necesites
          ],
        ),
      ),
    );
  }
}

