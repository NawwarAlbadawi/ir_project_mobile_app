import 'package:get/get.dart';
import '../controllers/evaluation_controller.dart';

class EvaluationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EvaluationController());
  }
}
