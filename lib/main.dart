import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sahayak_ai2/core/utils/theme.dart';
import 'package:sahayak_ai2/presentation/providers/ai_assistant_provider.dart';
import 'package:sahayak_ai2/presentation/providers/auth_provider.dart';
import 'package:sahayak_ai2/presentation/providers/lesson_provider.dart';
import 'package:sahayak_ai2/presentation/providers/morningPrep_provider.dart';
import 'package:sahayak_ai2/presentation/screens/auth/login_screen.dart';
import 'package:sahayak_ai2/presentation/screens/home/dashboard_screen.dart';
import 'package:sahayak_ai2/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:sahayak_ai2/presentation/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();

  runApp(const SahayakApp());
}

class SahayakApp extends StatelessWidget {
  const SahayakApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AIAssistantProvider()),
        // ChangeNotifierProvider(create: (_) => TeacherProvider()),
        ChangeNotifierProvider(create: (_) => LessonProvider()),
        ChangeNotifierProvider(create: (_) => MorningPrepProvider()),
      ],
      child: MaterialApp(
        title: 'Sahayak - Teacher Assistant',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const SplashScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/dashboard': (context) => const DashboardScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
