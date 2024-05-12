import 'package:get/get.dart';

class LoginController extends GetxController {
  var response = ''.obs;

  void changeResponse(String value) {
    //convert to Case First letter capitale
    value = value[0].toUpperCase() + value.substring(1);
    response.value = value;
  }
}
