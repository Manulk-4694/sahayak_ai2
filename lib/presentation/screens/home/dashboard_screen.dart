// screens/home/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahayak_ai2/presentation/screens/ai_assistant/ai_assistant_screen.dart';
import 'package:sahayak_ai2/presentation/screens/lessonPlans/lessonPlans_screen.dart';
import 'package:sahayak_ai2/presentation/screens/morningPreparation/morningPrep_screen.dart';
import 'package:sahayak_ai2/presentation/screens/splash_screen.dart';
import '../../providers/auth_provider.dart';
// import 'morning_prep_screen.dart';
// import 'lesson_planning_screen.dart';
// import 'in_class_support_screen.dart';
// import 'assessment_tools_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardHome(),
    // const LessonPlanningScreen(),
    // const InClassSupportScreen(),
    // const AssessmentToolsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Lessons'),
          BottomNavigationBarItem(icon: Icon(Icons.class_), label: 'Classroom'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Assessment'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sahayak Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final teacher = authProvider.teacher;
          if (teacher == null) return const SizedBox.shrink();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          child: Text(teacher.name[0].toUpperCase()),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome, ${teacher.name}!',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              Text(
                                'Classes: ${teacher.classesHandling.join(", ")}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Quick Actions
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),

                Container(
                  width: double.infinity, // 👈 Takes full width
                  height: 160, // Optional padding
                  child: _buildActionCard(
                    context,
                    'AIAssistant',
                    Icons.book,
                    Colors.blue,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AIAssistantScreen(),
                      ),
                    ),
                  ),
                ),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildActionCard(
                      context,
                      'Morning Prep',
                      Icons.wb_sunny,
                      Colors.orange,
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const MorningPrepScreen())),
                    ),
                    _buildActionCard(
                      context,
                      'Lesson Plans',
                      Icons.book,
                      Colors.blue,
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LessonPlanningScreen())),
                    ),
                    _buildActionCard(
                      context,
                      'Student Progress',
                      Icons.analytics,
                      Colors.green,
                      //  Colors.blue,
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AIAssistantScreen())),
                    ),
                    _buildActionCard(
                      context,
                      'Wellness Check',
                      Icons.favorite,
                      Colors.red,
                      () {},
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Today's Schedule
                Text(
                  'Today\'s Schedule',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildScheduleItem('9:00 AM', 'Math - Class 5',
                            'Addition & Subtraction'),
                        _buildScheduleItem('10:30 AM', 'Science - Class 6',
                            'Plants & Animals'),
                        _buildScheduleItem(
                            '12:00 PM', 'English - Class 4', 'Story Reading'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionCard1(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleItem(String time, String subject, String topic) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                Text(time, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(topic, style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Personal Information'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('App Settings'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Help & Support'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out'),
                onTap: () => authProvider.signOut(),
              ),
            ],
          );
        },
      ),
    );
  }
}
