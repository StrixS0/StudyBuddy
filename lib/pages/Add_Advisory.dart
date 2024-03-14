import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddAdvisory extends StatefulWidget {
  @override
  _AddAdvisoryState createState() => _AddAdvisoryState();
}

class _AddAdvisoryState extends State<AddAdvisory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isOnline = false;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  XFile? image;
  final ImagePicker _picker = ImagePicker();

  List<String> tags = [
    'ITS',
    'IAS',
    'Java',
    'HTML',
    'CSS',
    'React Js',
    'DevOps',
    'Machine Learning',
  ];
  List<bool> selectedTags = List.generate(8, (_) => false);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = selectedImage;
    });
  }

  void onTagSelected(bool selected, int index) {
    int selectedCount = selectedTags.where((bool val) => val).length;
    if (selected && selectedCount >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Solo puedes seleccionar hasta 5 tags.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    setState(() {
      selectedTags[index] = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creación de Asesoría'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nombre de la materia',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ListTile(
                    title: Text("${selectedDate.toLocal()}".split(' ')[0]),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: ListTile(
                    title: Text(selectedTime.format(context)),
                    trailing: const Icon(Icons.access_time),
                    onTap: () => _selectTime(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Modalidad',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'Presencial', child: Text('Presencial')),
                      DropdownMenuItem(
                          value: 'En línea', child: Text('En línea')),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        isOnline = newValue == 'En línea';
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextFormField(
                    enabled: !isOnline,
                    decoration: const InputDecoration(
                      labelText: 'Lugar',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: List<Widget>.generate(tags.length, (int index) {
                return ChoiceChip(
                  label: Text(tags[index]),
                  selected: selectedTags[index],
                  onSelected: (bool selected) {
                    onTagSelected(selected, index);
                  },
                );
              }),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Subir Foto'),
            ),
            if (image != null) ...[
              const SizedBox(height: 16.0),
              Image.file(File(image!.path)),
            ],
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Acción para agregar los datos del formulario
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 137, 78, 255),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10), // Redondez de las esquinas del botón
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: 0, vertical: 20), // Espacio interior del botón
              ),
              child: const Text('Agregar'),
            ),
          ],
        ),
      ),
    );
  }
}
