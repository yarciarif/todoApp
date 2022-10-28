import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'task_model.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  bool isCompleted;
//uuid isimli paketi import ediyoruz.
//birbirinden bagimsiz farkli tarihler olusturuyor.
  Task(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.isCompleted});
//yukardaki constructor bi sey return etmiyor..Ama factory ile return eden nesneler olusturabiliyoruz.
//yeni bir tane task nesnesi olusturuyoruz.
  factory Task.olustur({required String name, required DateTime createdAt}) {
    return Task(
        id: const Uuid().v1(),
        name: name,
        createdAt: createdAt,
        isCompleted: false);
  }
}
