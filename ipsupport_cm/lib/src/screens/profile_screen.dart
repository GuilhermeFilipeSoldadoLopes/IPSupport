import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ipsupport_cm/src/screens/settings_screen.dart';
import 'package:ipsupport_cm/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();

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
                    radius: 70,
                    backgroundImage: NetworkImage(FirebaseAuth
                            .instance.currentUser?.photoURL ??
                        'https://firebasestorage.googleapis.com/v0/b/ipsupport-28bbe.appspot.com/o/default%2Fdefault_profile.jpg?alt=media&token=83373b6a-6399-4bd4-ac8c-d7f8c203f48a')),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () async {
                      final results = await FilePicker.platform.pickFiles(
                        allowMultiple: false,
                        type: FileType.custom,
                        allowedExtensions: ['png', 'jpg'],
                      );
                      if (results == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Nenhum ficheiros selecionado.')));
                      }
                      final path = results?.files.single.path!;
                      final fileName = results?.files.single.name;
                      if (path != null || fileName != null) {
                        storage
                            .uploadFile(path!, fileName!)
                            .then((value) => print('Uploaded'));
                      }

                      //print(path);
                      //print(fileName);

                      // Acrescentar código para clicar no botão
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
                        Icons.edit,
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
              subtitle:
                  FirebaseAuth.instance.currentUser?.displayName ?? "Error...",
              iconData: Icons.person,
            ),
            const SizedBox(height: 20),
            ProfileItem(
              title: 'Email',
              subtitle: FirebaseAuth.instance.currentUser?.email ?? "Error...",
              iconData: Icons.email,
            ),
            const SizedBox(height: 20),
            const Text(
              'Reportes realizados: ' '15',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
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

  const ProfileItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.iconData,
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
      ),
    );
  }
}
