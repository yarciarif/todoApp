import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/data/localStorage.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/widgets/task_list_item.dart';

import '../models/task_model.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Task> allTask;

  CustomSearchDelegate({required this.allTask});

  //arama kısmının sağ tarafındaki iconları
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = '';
          },
          icon: const Icon(Icons.clear)),
    ];
  }

//arama kısmının sol başındaki iconları
  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
      onTap: () {
        close(context, null);
      },
      child: const Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
        size: 24,
      ),
    );
  }

//arama yapıp arama sayfasındaki sonucları nasıl göstermek istediğimizi ayarlıyoruz.
  @override
  Widget buildResults(BuildContext context) {
    List<Task> filteredList = allTask
        .where(
          (element) => element.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return filteredList.isNotEmpty
        ? ListView.builder(
            itemBuilder: (context, index) {
              var oankiEleman = filteredList[index];
              return Dismissible(
                key: Key(oankiEleman.id),
                // onDismissed metodu ile o satırdaki elemani listeden çıkarıyoruz.
                onDismissed: (direction) async {
                  filteredList.removeAt(index);
                  await locator<LocalStorage>().deleteTask(task: oankiEleman);
                },
                background: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.delete,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text('remove_task').tr(),
                  ],
                ),
                child: TaskItem(
                  task: oankiEleman,
                ),

                /* ListTile(
                      title: Text(_oankiEleman.name + ' ' + _oankiEleman.id),
                      subtitle: Text(_oankiEleman.createdAt.toString()),
                    ), */
              );
            },
            itemCount: filteredList.length,
          )
        : Center(
            child: const Text('searhcNotFound').tr(),
          );
  }

  //kullanıcı bir şeyler yazdıgında görünmesini istediğimiz sonuçlar burda
  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
