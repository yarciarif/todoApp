import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/data/localStorage.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/pages/home_page.dart';

//get_it paketiyle sınıflar arasındaki bağımlılıkları kontrol ediyoruz.

final locator = GetIt.instance;

void setUp() {
  locator.registerSingleton<LocalStorage>(HiveLocalStorage());
}

Future<void> setupHive() async {
  //hive çalıştırmak için de alttaki await kodunu çalıştırmak gerekiyor.
  await Hive.initFlutter();
  //flutter packages pub run build_runner build
  //@hiveType ve @hiveField işlemlerinden sonra çalıştırdıgımız koddan sonra o dosyadaki ADAPTER i burda parametre olarak geçiyoruz.
  Hive.registerAdapter(TaskAdapter());
//register edildikten sonra içinde Task ların oldugu Tasks kutusunu açıyoruz.
  var taskBox = await Hive.openBox<Task>('Tasks');
  for (var task in taskBox.values) {
    if (task.createdAt.day != DateTime.now().day) {
      taskBox.delete(task);
    }
  }
}

Future<void> main() async {
  //mainde uzun süren işlemlerden önce runAppten önce bunu çalıştırmak gerekir.
  WidgetsFlutterBinding.ensureInitialized();
  //dil desteği için bu kodu FLutter Dev den alıyoruz.
  await EasyLocalization.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  await setupHive();
//olusturulan locator dan sonra runApp çalışmadan bu kodları yazmam lazım ki çalışsın.
  setUp();

  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('tr', 'TR')],
        path:
            'assets/translations', // <-- change the path of the translation files
        fallbackLocale: const Locale('en', 'US'),
        child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //flutterın kendi içindeki aramalar,butonlardaki textlerin de değişimi için alttaki kodları Flutter Dev den alıyoruz.
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        //cihazın diliyle başlasın program.
        locale: context.deviceLocale,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black)),
        ),
        home: const HomePage());
  }
}
