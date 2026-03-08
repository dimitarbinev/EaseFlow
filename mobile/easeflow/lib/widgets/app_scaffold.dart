import 'package:flutter/material.dart';

class AppScaffold extends StatefulWidget {
  final Widget body;
  final String title;

  const AppScaffold({super.key, required this.body, this.title = 'EaseFlow'});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _selectedIndex = 0;

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        break;
      case 1:
        Navigator.of(context).pushNamed('/create-task');
        break;
      case 2:
        Navigator.of(context).pushNamed('/manage-tasks');
        break;
      case 3:
        Navigator.of(context).pushNamed('/person-info');
        break;
      case 4:
        Navigator.of(context).pushNamed('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil('/', (route) => false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Image.asset(
                      'assets/images/easeflow.png',
                      height: 90,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 100,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.teal[800],
        ),
      ),
      body: widget.body,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF2a2a2a),
        selectedItemColor: Colors.teal[400],
        unselectedItemColor: Colors.grey[600],
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Create',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.task_alt), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
