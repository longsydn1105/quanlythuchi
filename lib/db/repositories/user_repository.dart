import 'package:hive/hive.dart';
import '../../models/user.dart';

class UserRepository {
  final String _boxName = 'usersBox';

  Future<Box<User>> _getBox() async {
    return await Hive.openBox<User>(_boxName);
  }

  Future<int> insertUser(User user) async {
    final box = await _getBox();
    return await box.add(user);
  }

  Future<List<User>> getAllUsers() async {
    final box = await _getBox();
    return box.values.toList();
  }

  Future<void> deleteUser(int key) async {
    final box = await _getBox();
    await box.delete(key);
  }

  Future<void> updateUser(int key, User user) async {
    final box = await _getBox();
    await box.put(key, user);
  }
}
