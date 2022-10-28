import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class TranslationHelper {
  //herhangi bir nesne üretilmesini istemiyosak böyle gizli bir constructor yazılabilir.

  TranslationHelper._();

  static getDeviceLanguage(BuildContext context) {
    //home_page te device localin diline göre bir mantık geliştiriliyor.
    //ordaki context.deviceLocale i alıp country coduna göre işlemler yapılıyor.
    //null olabileceği için '!' kullanıldı.
    var deviceLanguage = context.deviceLocale.countryCode!.toLowerCase();

    switch (deviceLanguage) {
      case 'tr':
        return LocaleType.tr;
      case 'us':
        return LocaleType.en;
    }
    print(deviceLanguage);
  }
}
