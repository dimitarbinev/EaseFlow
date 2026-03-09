import 'package:flutter/material.dart';
import '../widgets/app_scaffold.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Container(
        color: const Color(0xFF1a1a1a),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Manage your tasks and learn together',
                      style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Quick Action Cards
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildQuickActionCard(
                      context,
                      icon: Icons.add_circle,
                      title: 'Create Task',
                      route: '/create-task',
                    ),
                    _buildQuickActionCard(
                      context,
                      icon: Icons.task_alt,
                      title: 'Manage Tasks',
                      route: '/manage-tasks',
                    ),
                    _buildQuickActionCard(
                      context,
                      icon: Icons.person,
                      title: 'Person Info',
                      route: '/person-info',
                    ),
                    _buildQuickActionCard(
                      context,
                      icon: Icons.settings,
                      title: 'Settings',
                      route: '/settings',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(route);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.teal[700],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
