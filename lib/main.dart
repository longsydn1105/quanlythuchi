import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quanlythuchi/models/expense.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'db/repositories/expense_repository.dart'; // Thêm dòng này nếu ExpenseRepository nằm ở đây
import 'controllers/expense_controller.dart'; // Thêm dòng này nếu ExpenseController nằm ở đây
import 'package:flutter/foundation.dart' show kIsWeb;
import 'Screens/login.dart'; // Bạn có thể thay bằng signup.dart nếu muốn
import 'controllers/user_controller.dart'; // Thêm dòng này
import 'db/repositories/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final expenseRepository = ExpenseRepository();
  Get.put(ExpenseController(expenseRepository));

  final userRepository = UserRepository(); // Thêm dòng này
  Get.put(UserController(userRepository)); // Thêm dòng này
  // Đảm bảo khởi tạo Hive trước khi chạy ứng dụng
  initHive();
  runApp(const MyApp());
}

Future<void> initHive() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    if (kIsWeb) {
      // Chạy trên web - không dùng path_provider
      await Hive.initFlutter(); // hoặc await Hive.initFlutter(); (tùy phiên bản Hive)
    } else {
      // Chạy trên mobile/desktop
      final appDocumentDir = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(appDocumentDir.path);
    }

    if (!Hive.isAdapterRegistered(ExpenseAdapter().typeId)) {
      Hive.registerAdapter(ExpenseAdapter());
    }

    if (!Hive.isBoxOpen('expenses')) {
      await Hive.openBox<Expense>('expenses');
    }
    print('Khởi tạo Hive thành công');
  } catch (e) {
    print('❌ Lỗi khởi tạo Hive: $e');
  }
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: LoginPage(),
      // home: LoginPage(), // 👉 Bỏ comment dòng này nếu LoginPage đã hoạt động tốt
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
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Bạn đã nhấn nút bao nhiêu lần:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
