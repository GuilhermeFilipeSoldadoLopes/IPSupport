import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ipsupport_cm/src/screens/settings_screen.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String displayName = '';

  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
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
          title: Text('Editar nome'),
          content: TextField(
            onChanged: (value) {
              newName = value; // Atualiza a variável com o novo nome escrito
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            ),
            TextButton(
              child: Text('Salvar'),
              onPressed: () async {
                await FirebaseAuth.instance.currentUser?.updateDisplayName(newName);
                Navigator.of(context).pop(); 
                _updateProfileName(newName); // Chama a função de callback para atualizar o nome na página
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
                CircleAvatar(
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
                    onTap: () {
                      _editImageDialog(context);
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 4,
                          color: Colors.white,
                        ),
                        color: const Color.fromARGB(255, 255, 255, 255),
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

  void _editImageDialog(BuildContext context) {
    // TODO: Implementar a lógica para editar a imagem de perfil
    
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


//código do Lopes
/*Uint8List? _image;
  File? _imageFile;
  final imagePicker = ImagePicker();

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  Future imagePickerMethod() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pick != null) {
        _imageFile = File(pick.path);
      } else {
        showSnackBar("No file selected", const Duration(milliseconds: 4000));
      }
    });
  }

  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }*/

