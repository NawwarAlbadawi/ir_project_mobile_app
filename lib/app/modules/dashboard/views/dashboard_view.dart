import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/design_config.dart';
import '../controllers/dashboard_controller.dart';
import '../../search/views/search_view.dart';
import '../../index_manager/views/index_manager_view.dart';
import '../../evaluation/views/evaluation_view.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  static const _pages = [SearchView(), IndexManagerView(), EvaluationView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      extendBody: true,
      body: Obx(() => _pages[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => CrystalNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeIndex,
          backgroundColor: AppColors.bgSurface.withOpacity(0.85),
          borderRadius: 24,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          outlineBorderColor: AppColors.border,
          enableFloatingNavBar: true,
          selectedItemColor: AppColors.accent,
          unselectedItemColor: AppColors.textMuted,
          items: [
            CrystalNavigationBarItem(
              icon: Icons.search_rounded,
              unselectedIcon: Icons.search_rounded,
            ),
            CrystalNavigationBarItem(
              icon: Icons.storage_rounded,
              unselectedIcon: Icons.storage_rounded,
            ),
            CrystalNavigationBarItem(
              icon: Icons.bar_chart_rounded,
              unselectedIcon: Icons.bar_chart_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
