import 'package:http/http.dart' as http;

class WS {
  //constructor
  WS() {
    data();
  }

  Future<void> data() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:8080/api/hello?name=World'));
      print(response.body); //
    } catch (e) {
      print(e);
    }
  }
}
