import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipsupport_cm/src/screens/settings_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String displayName = '';
  String imageUrl = '';
  bool isImageNew = false;

  GlobalKey<FormState> key = GlobalKey();

  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('imagesURL');

  final storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
    imageUrl = '';
  }

  Future<void> fetchCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        displayName = user.displayName ?? '';
      });
    }
  }

  void _editNameDialog(BuildContext context) {
    String newName = "";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar nome'),
          content: TextField(
            onChanged: (value) {
              newName = value; // Atualiza a variável com o novo nome escrito
            },
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () async {
                await FirebaseAuth.instance.currentUser
                    ?.updateDisplayName(newName);
                Navigator.of(context).pop();
                _updateProfileName(
                    newName); // Chama a função de callback para atualizar o nome na página
              },
            ),
          ],
        );
      },
    );
  }

  void _updateProfileName(String newName) {
    setState(() {
      displayName = newName; // Atualiza o nome na página
    });
  }

  void _editImageDialog(BuildContext context) async {
    var pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery, //pick from device gallery
        maxWidth: 520,
        maxHeight: 520, //specify size and quality
        imageQuality: 80); //so image_picker will resize for you

    //upload and get download url
    Reference ref = FirebaseStorage.instance.ref().child(
        FirebaseAuth.instance.currentUser?.email ??
            "Error"); //generate a unique name

    await ref.putFile(File(pickedImage!.path)); //you need to add path here
    imageUrl = await ref.getDownloadURL();

    setState(() {
      FirebaseAuth.instance.currentUser?.updatePhotoURL(imageUrl);
      isImageNew = true;
    });

    if (imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Altere a sua imagem de perfil")));
      return;
    }
  }

  void setFalse() {
    isImageNew = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Perfil",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()));
            },
            icon: const Icon(
              Icons.settings_outlined,
              size: 30,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                isImageNew
                    ? CircleAvatar(
                        radius: 65,
                        backgroundImage: NetworkImage(imageUrl),
                      )
                    : CircleAvatar(
                        radius: 65,
                        backgroundImage: NetworkImage(
                          FirebaseAuth.instance.currentUser?.photoURL ??
                              'https://firebasestorage.googleapis.com/v0/b/ipsupport-28bbe.appspot.com/o/default%2Fdefault_profile.jpg?alt=media&token=83373b6a-6399-4bd4-ac8c-d7f8c203f48a',
                        ),
                      ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () async {
                      _editImageDialog(context);
                      if (key.currentState!.validate()) {
                        Map<String, String> dataToSend = {
                          'name': FirebaseAuth.instance.currentUser?.email ??
                              "Error",
                          'quatity': 1.toString(),
                          'image': imageUrl,
                        };

                        _reference.add(dataToSend);
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 1,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                        color: Color.fromARGB(255, 199, 236, 253),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ProfileItem(
              title: 'Nome',
              subtitle: displayName,
              iconData: Icons.person,
              isEditable: true,
              onPressed: () {
                _editNameDialog(context);
              },
            ),
            const SizedBox(height: 20),
            ProfileItem(
              title: 'Email',
              subtitle: FirebaseAuth.instance.currentUser?.email ?? 'Error...',
              iconData: Icons.email,
              isEditable: false,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData iconData;
  final bool isEditable;
  final VoidCallback? onPressed;

  const ProfileItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.iconData,
    this.isEditable = true,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: const Color.fromARGB(255, 70, 181, 255).withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
        trailing: isEditable
            ? IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onPressed,
              )
            : null,
      ),
    );
  }
}
