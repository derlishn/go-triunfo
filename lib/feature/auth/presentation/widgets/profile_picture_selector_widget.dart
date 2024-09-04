import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePictureSelectorWidget extends StatefulWidget {
  final Function(String) onImageUploaded;

  const ProfilePictureSelectorWidget({
    Key? key,
    required this.onImageUploaded, // Callback para pasar la URL de la imagen subida
  }) : super(key: key);

  @override
  _ProfilePictureSelectorWidgetState createState() =>
      _ProfilePictureSelectorWidgetState();
}

class _ProfilePictureSelectorWidgetState
    extends State<ProfilePictureSelectorWidget> {
  File? _imageFile;
  bool isUploading = false;
  final ImagePicker _picker = ImagePicker();

  // Método para elegir imagen desde galería o cámara
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // Guardar la imagen seleccionada
      });
      _uploadImage(_imageFile!); // Subir imagen a Firebase
    }
  }

  // Método para subir la imagen a Firebase
  Future<void> _uploadImage(File image) async {
    try {
      setState(() {
        isUploading = true; // Mostrar el estado de carga
      });

      // Crear referencia en Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child(
          'fotos_de_usuarios/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = await storageRef.putFile(image);

      if (uploadTask.state == TaskState.success) {
        // Obtener el enlace de descarga y pasarlo al callback
        final downloadUrl = await storageRef.getDownloadURL();
        widget.onImageUploaded(downloadUrl); // Devolver la URL al formulario
      } else {
        throw Exception("Error al subir la imagen: Subida fallida.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al subir la imagen: $e')),
      );
    } finally {
      setState(() {
        isUploading = false; // Ocultar el estado de carga
      });
    }
  }

  // Mostrar opciones de galería o cámara
  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Seleccionar desde galería'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery); // Seleccionar desde galería
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Tomar foto con cámara'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera); // Tomar foto con cámara
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Eliminar la imagen seleccionada
  void _removeImage() {
    setState(() {
      _imageFile = null; // Eliminar la imagen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          GestureDetector(
            onTap: _showImageSourceOptions, // Mostrar opciones al hacer clic
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[200],
              backgroundImage: _imageFile != null
                  ? FileImage(_imageFile!)
                  : null, // Mostrar imagen seleccionada
              child: _imageFile == null
                  ? Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey[400],
                    )
                  : null,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(
                Icons.camera_alt,
                color: Colors.grey,
              ),
              onPressed: _showImageSourceOptions, // Mostrar opciones de imagen
            ),
          ),
          if (_imageFile !=
              null) // Si hay una imagen seleccionada, mostrar el botón de eliminar
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                onPressed: _removeImage, // Eliminar la imagen
              ),
            ),
          if (isUploading) // Mostrar indicador de carga si está subiendo
            Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
