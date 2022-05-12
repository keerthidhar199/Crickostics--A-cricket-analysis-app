import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class DataController extends GetxController {
  List<String> Mdns = [];
  List<String> name = [];
  List<String> overs = [];

  void addName(String text) {
    name[0] = 'Name';
    name.add(text);
    update();
  }

  void addMdns(String text) {
    Mdns[0] = 'Maidens';
    Mdns.add(text);
    update();
  }

  void addOvers(String text) {
    overs[0] = 'Overs';
    overs.add(text);
    update();
  }
}
