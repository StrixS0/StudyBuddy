// ignore: file_names
import 'package:flutter/material.dart';

// ignore: camel_case_types
class Task extends StatelessWidget {
  const Task({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> courses = [
      {
        'title': 'Temas Selectos de Software',
        'author': 'danilo',
        'date': '28 Jan 2021',
        'views': '20k',
        'image': 'assets/course1.jpg'
      },
      {
        'title': 'Temas Selectos de Software',
        'author': 'danilo',
        'date': '28 Jan 2021',
        'views': '20k',
        'image': 'assets/course1.jpg'
      },
      {
        'title': 'Temas Selectos de Software',
        'author': 'danilo',
        'date': '28 Jan 2021',
        'views': '20k',
        'image': 'assets/course1.jpg'
      },
      {
        'title': 'Temas Selectos de Software',
        'author': 'danilo',
        'date': '28 Jan 2021',
        'views': '20k',
        'image': 'assets/course1.jpg'
      },
      {
        'title': 'Temas Selectos de Software',
        'author': 'danilo',
        'date': '28 Jan 2021',
        'views': '20k',
        'image': 'assets/course1.jpg'
      },
      {
        'title': 'Temas Selectos de Software',
        'author': 'danilo',
        'date': '28 Jan 2021',
        'views': '20k',
        'image': 'assets/course1.jpg'
      },
      {
        'title': 'Temas Selectos de Software',
        'author': 'danilo',
        'date': '28 Jan 2021',
        'views': '20k',
        'image': 'assets/course1.jpg'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cursos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(course['image']),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        course['author'],
                        style: const TextStyle(
                            color: Color.fromARGB(179, 250, 250, 250)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        course['date'],
                        style: const TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.visibility,
                              size: 12, color: Colors.white70),
                          const SizedBox(width: 4),
                          Text(
                            course['views'],
                            style:
                                const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
