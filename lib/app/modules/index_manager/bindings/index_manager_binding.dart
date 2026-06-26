import 'package:get/get.dart';
import '../controllers/index_manager_controller.dart';

class IndexManagerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IndexManagerController());
  }
}
