import 'package:get/get.dart';

class TableController extends GetxController {
  final RxList<int> selectedTables = <int>[].obs;

  void toggleTable(int index, bool isAvailable) {
    if (!isAvailable) return;

    if (selectedTables.contains(index)) {
      selectedTables.remove(index);
    } else {
      selectedTables.add(index);
    }
  }

  int get selectedCount => selectedTables.length;
}
