import 'package:get/get.dart';
import '../modules/search/bindings/search_binding.dart';
import '../modules/search/views/search_view.dart';
import '../modules/index_manager/bindings/index_manager_binding.dart';
import '../modules/index_manager/views/index_manager_view.dart';
import '../modules/evaluation/bindings/evaluation_binding.dart';
import '../modules/evaluation/views/evaluation_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
part 'app_routes.dart';
class AppPages {
  static const INITIAL = Routes.DASHBOARD;
  static final routes = [
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.SEARCH,
      page: () => const SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: Routes.INDEX_MANAGER,
      page: () => const IndexManagerView(),
      binding: IndexManagerBinding(),
    ),
    GetPage(
      name: Routes.EVALUATION,
      page: () => const EvaluationView(),
      binding: EvaluationBinding(),
    ),
  ];
}