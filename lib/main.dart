import 'package:flutter/material.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:flutter_quanlythuchi/models/expense.dart';
=======

// Giữ tất cả các import bạn đã có
>>>>>>> 448e635 (bao cao thong ke)
import 'Screens/login.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
=======
import 'Screens/signup.dart';
<<<<<<< HEAD
>>>>>>> 8bda4eb (Update Code Profile)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Hive
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  
  // Đăng ký adapter
  Hive.registerAdapter(ExpenseAdapter());
  
  // Mở box
  await Hive.openBox<Expense>('expenses');

=======
import 'Screens/welcome.dart';
import 'screens/Welcome/welcome_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/Thongke/report_screen.dart';

void main() {
>>>>>>> 448e635 (bao cao thong ke)
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
<<<<<<< HEAD
      home: LoginPage(),
      // home: (),
      // home: (),
=======

      // home: WelcomeScreen(),
      // home: LoginPage(),
      // home: RegisterPage(),
      // home: DashboardScreen(),
      home: DashboardScreen(), // ← bạn có thể đổi lại cái này
>>>>>>> 448e635 (bao cao thong ke)
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
            const Text('You have pushed the button this many times:'),
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
      ),
    );
  }
}
