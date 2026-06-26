// =============================================================================
// lib/app/modules/dashboard/controllers/dashboard_controller.dart
// Exactly mirrors gym_mobile_app's DashboardController pattern.
// =============================================================================

import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class DashboardController extends GetxController {
  final selectedIndex = 0.obs;

  final pageRoutes = [
    Routes.SEARCH,
    Routes.INDEX_MANAGER,
    Routes.EVALUATION,
  ];

  void changeIndex(int index) => selectedIndex.value = index;
}
