import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../search/controllers/search_controller.dart';
import '../../index_manager/controllers/index_manager_controller.dart';
import '../../evaluation/controllers/evaluation_controller.dart';
class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => AppSearchController());
    Get.lazyPut(() => IndexManagerController());
    Get.lazyPut(() => EvaluationController());
  }
}