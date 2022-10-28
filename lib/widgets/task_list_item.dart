// ignore_for_file: implementation_imports, must_be_immutable, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/data/localStorage.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/models/task_model.dart';

class TaskItem extends StatefulWidget {
  //önce burda bir değişken olusturuyoruz ki burdaki oluşan Task türündeki nesneyi diğer sayfada kullanabilelim.
  Task task;
  TaskItem({required this.task, super.key});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  //textField da değişikliğin algılanabilmesi için bir tane controller tanımlıyoruz.TextEditing Sınıfından.
  final TextEditingController _taskNameController = TextEditingController();

  late LocalStorage _localStorage;
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    //Bu nesnenin textini de illk başta görünmesi gereken Task nesnesindeki name e eşitliyoruz.
    super.initState();
    //yukarda olusturulan localStorage nesnesinden verileri alabilmek için LOCALSTORAGE türünde locator yardımıyla bir değişken tanımlıyoruz.
    _localStorage = locator<LocalStorage>();
    debugPrint('init state tetiklendi.');
  }

  @override
  Widget build(BuildContext context) {
    //init statteydi normalde ama init state bir defa çalıştığı için arama yaptıktan sonra ana sayfada tekrar bu değişikliği yani bu taskı görüntüleyemiyoruz.
    _taskNameController.text = widget.task.name;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 10),
        ],
      ),
      child: ListTile(
          //anlık olarak bi şeyin değişikliğini görmek için bu GESTORDETECTOR.
          leading: GestureDetector(
              onTap: () {
                widget.task.isCompleted = !widget.task.isCompleted;
                //localStorage'taki verileri update edebilmek için veritanında oluşturulan metodlara tanımlama yapıyoruz.
                _localStorage.updateTask(task: widget.task);

                setState(() {});
              },
              child: Container(
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                decoration: BoxDecoration(
                    color:
                        widget.task.isCompleted ? Colors.green : Colors.white,
                    border: Border.all(color: Colors.grey, width: 0.8),
                    shape: BoxShape.circle),
              )),
          title: widget.task.isCompleted
              ? Text(
                  widget.task.name,
                  style:
                      const TextStyle(decoration: TextDecoration.lineThrough),
                )
              : TextField(
                  controller: _taskNameController,
                  minLines: 1,
                  maxLines: null,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(border: InputBorder.none),
                  onSubmitted: (yeniDeger) {
                    widget.task.name = yeniDeger;
                    _localStorage.updateTask(task: widget.task);
                  },
                ),
          trailing: Text(
            DateFormat('hh:mm a').format(widget.task.createdAt),
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          )),
    );
  }
}
