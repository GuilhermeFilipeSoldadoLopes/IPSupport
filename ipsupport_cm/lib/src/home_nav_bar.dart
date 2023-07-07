import 'package:flutter/material.dart';
import 'package:ipsupport_cm/src/screens/home_map_screen.dart';
import 'package:ipsupport_cm/src/screens/report_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/edit_profile_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTab = 1;
  final List<Widget> screens = [
    const Report(),
    HomeMapScreen(),
    const EditProfile()
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = HomeMapScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.assistant_navigation),
        onPressed: () {
          if (currentTab == 1) {
            currentScreen = HomeMapScreen();
          } else {
            setState(() {
              currentScreen = HomeMapScreen();
              currentTab = 1;
            });
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currentScreen = const Report();
                          currentTab = 0;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 60.0), // Padding para o ícone
                            child: Icon(
                              Icons.report_problem_rounded,
                              color: currentTab == 0 ? Colors.blue : Colors.grey,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 60.0), // Padding para o texto
                            child: Text(
                              'Reporte',
                              style: TextStyle(
                                color: currentTab == 0 ? Colors.blue : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Profile Button
                  MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currentScreen = const EditProfile();
                          currentTab = 2;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person,
                            color: currentTab == 2 ? Colors.blue : Colors.grey,
                          ),
                          Text(
                            'Perfil',
                            style: TextStyle(
                                color: currentTab == 2
                                    ? Colors.blue
                                    : Colors.grey),
                          )
                        ],
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
