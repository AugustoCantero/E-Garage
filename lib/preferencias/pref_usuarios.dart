import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario{

static late  SharedPreferences _prefs;

static Future init() async{
  _prefs = await SharedPreferences.getInstance();
}

String get token{
  return _prefs.getString('token') ?? '' ;
}

set token(String value){
  _prefs.setString('token', value);
}

}