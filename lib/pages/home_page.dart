// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_interpolation_to_compose_strings

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:to_do_app/data/localStorage.dart';
import 'package:to_do_app/helper/translation_helper.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/widgets/search.dart';
import 'package:to_do_app/widgets/task_list_item.dart';

import '../models/task_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTasks;

  late LocalStorage _localStorage;

//INTERNET VERI ALIP KULLANABILECEGIMIZ YAPILAR INITSTATE'TE TANIMLANIR
  @override
  void initState() {
    //locator ile LocalStorage türünde bir nesne oluşturuyoruz.
    _localStorage = locator<LocalStorage>();
    super.initState();
    //BU SEKILDE BOS BIR LISTE TANIMLANIR
    _allTasks = <Task>[];
    _allTasks
        .add(Task.olustur(name: 'Default Task ', createdAt: DateTime.now()));
    getAllTaskFromDB();
  }

  @override
  Widget build(BuildContext context) {
    //uygulamanın dilini Translation Helperdakine göre kontrol etmek amaçlı yazıldı.
    /* TranslationHelper.getDeviceLanguage(context); */
    return Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            //ALTTA BIR MODAL OLUSTURUR.
            onTap: () {
              _showAddTaskBottomSheet();
            },
            child: const Text(
              'title',
              style: TextStyle(color: Colors.black),
            ).tr(),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  _showSearchPage();
                },
                icon: const Icon(Icons.search)),
            IconButton(
                onPressed: () {
                  _showAddTaskBottomSheet();
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: _allTasks.isNotEmpty
            ? ListView.builder(
                itemBuilder: (context, index) {
                  var _oankiEleman = _allTasks[index];
                  return Dismissible(
                    key: Key(_oankiEleman.id),
                    // onDismissed metodu ile o satırdaki elemani listeden çıkarıyoruz.
                    onDismissed: (direction) {
                      _allTasks.removeAt(index);
                      _localStorage.deleteTask(task: _oankiEleman);
                      setState(() {});
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
                      task: _oankiEleman,
                    ),

                    /* ListTile(
                      title: Text(_oankiEleman.name + ' ' + _oankiEleman.id),
                      subtitle: Text(_oankiEleman.createdAt.toString()),
                    ), */
                  );
                },
                itemCount: _allTasks.length,
              )
            : Center(
                child: const Text('empty_task_list').tr(),
              ));
  }
  //task_list_item sayfasinda Task modelinde bir parametre zorunlu kılıp o nesneyi buraya geçiyoruz.
  //Listview içinde tüm task elemanlarının oldugu bir liste tanımlıyoruz.

  void _showAddTaskBottomSheet() {
    //sayfanın alttan modal acilir sayfa seklinde cıkmasını saglayan metod.
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding:
              //textfield yazarken ekranın klavyenin üstünde cıkmasını saglıyor.
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          //ekranın genisligi kadar yer tutuyor.
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            title: TextField(
              autofocus: true,
              style: const TextStyle(fontSize: 20),
              decoration: InputDecoration(
                  hintText: ('add_task').tr(), border: InputBorder.none),
              onSubmitted: (value) {
                Navigator.of(context).pop();
                if (value.length > 3) {
                  //flutter date_picker paketini import edip burda kullanıyoruz.
                  DatePicker.showTimePicker(context,
                      showSecondsColumn: false,
                      //DateTime için dil kontrolü yapıldıgında locale ile TranslationHelper'dan ilgili dili alıyoruz.
                      locale: TranslationHelper.getDeviceLanguage(context),
                      //onConfirm ile olusturulan zaman degerini alabiliriz.
                      onConfirm: (task) async {
                    var yeniNesne = Task.olustur(name: value, createdAt: task);
                    //yeni eklenen bir görevin en üstte çıkması için insert metoduyla indexini 0 vererek en üstte oluşmasını sağlayabiliyoruz.
                    _allTasks.insert(0, yeniNesne);
                    await _localStorage.addTask(task: yeniNesne);
                    setState(() {});
                  });
                }
              },
            ),
          ),
        );
      },
    );
  }

  void getAllTaskFromDB() async {
    _allTasks = await _localStorage.getAllTask();
    setState(() {});
  }

  void _showSearchPage() async {
    await showSearch(
        context: context, delegate: CustomSearchDelegate(allTask: _allTasks));
    getAllTaskFromDB();
  }
}
