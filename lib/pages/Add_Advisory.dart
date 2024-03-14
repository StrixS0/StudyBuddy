import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pia_moviles/pages/home_page.dart';

class AddAdvisory extends StatefulWidget {
  @override
  _AddAdvisoryState createState() => _AddAdvisoryState();
}

class _AddAdvisoryState extends State<AddAdvisory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreMateriaController =
      TextEditingController();
  final TextEditingController _lugarController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

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

  @override
  void dispose() {
    _nombreMateriaController.dispose();
    _lugarController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

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
    if (selectedImage != null) {
      setState(() {
        image = selectedImage;
      });
    }
  }

  void onTagSelected(bool selected, int index) {
    if (selected && selectedTags.where((val) => val).length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Solo puedes seleccionar hasta 5 tags.')),
      );
      return;
    }
    setState(() {
      selectedTags[index] = selected;
    });
  }

  Future<String?> _uploadImageToStorage(XFile image) async {
    String fileName =
        'asesorias/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
    try {
      await FirebaseStorage.instance.ref(fileName).putFile(File(image.path));
      String downloadURL =
          await FirebaseStorage.instance.ref(fileName).getDownloadURL();
      return downloadURL;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> _addAdvisoryToFirestore() async {
    String? imageUrl;
    if (image != null) {
      imageUrl = await _uploadImageToStorage(image!);
    }

    List<String> selectedTagsNames = tags
        .asMap()
        .entries
        .where((entry) => selectedTags[entry.key])
        .map((entry) => entry.value)
        .toList();

    await FirebaseFirestore.instance.collection('asesorias').add({
      'nombreMateria': _nombreMateriaController.text,
      'fecha': selectedDate,
      'hora': "${selectedTime.hour}:${selectedTime.minute}",
      'modalidad': isOnline ? 'En línea' : 'Presencial',
      'lugar': isOnline ? '' : _lugarController.text,
      'descripcion': _descripcionController.text,
      'tags': selectedTagsNames,
      'imagenURL': imageUrl,
      'userId': FirebaseAuth.instance.currentUser!.uid,
// Guarda la URL de la imagen de Firebase Storage
    }).then((docRef) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Asesoría agregada con éxito')),
      );

      // Navegar al HomePage después de un registro exitoso
      if (Navigator.canPop(context)) {
        Navigator.pop(
            context); // Si AddAdvisory fue empujado al stack, simplemente pop back
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) =>
                  HomePage()), // Asegúrate de importar HomePage
        );
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar asesoría: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Creación de Asesoría'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreMateriaController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la materia',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, ingrese el nombre de la materia';
                  }
                  return null; // El valor es válido
                },
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
                      value: isOnline ? 'En línea' : 'Presencial',
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      controller: _lugarController,
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
                controller: _descripcionController,
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
                const SizedBox(height: 16.0),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0), // Añade espacio en los lados
                child: ElevatedButton(
                  onPressed: _addAdvisoryToFirestore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context)
                        .primaryColor, // Usa el color primario del tema
                    foregroundColor:
                        Colors.white, // El color del texto del botón
                    padding: EdgeInsets.symmetric(
                        vertical:
                            20.0), // Añade espacio arriba y abajo dentro del botón
                    shape: RoundedRectangleBorder(
                      // Esto hace que las esquinas sean redondeadas
                      borderRadius: BorderRadius.circular(
                          8.0), // Ajusta el radio de las esquinas según lo que necesites
                    ),
                    minimumSize: Size(double.infinity,
                        56.0), // Asegura que el botón sea largo y tenga un mínimo de alto
                  ),
                  child: const Text('Agregar Asesoría',
                      style: TextStyle(
                          fontSize:
                              16)), // Ajusta el tamaño de la fuente si es necesario
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
