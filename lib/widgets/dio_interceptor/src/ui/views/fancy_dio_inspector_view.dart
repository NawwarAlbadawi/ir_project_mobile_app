import 'package:flutter/material.dart';
import '../../loggers/fancy_dio_logger.dart';
import '../../models/fancy_dio_inspector/fancy_dio_inspector_l10n_options.dart';
import '../../models/fancy_dio_inspector/fancy_dio_inspector_tile_options.dart';
import '../../models/network/network_error_model.dart';
import '../../models/network/network_request_model.dart';
import '../../models/network/network_response_model.dart';
import '../../utils/extensions/context_extensions.dart';
import '../widgets/fancy_dio_tab_view.dart';
class FancyDioInspectorView extends StatelessWidget {
  final FancyDioInspectorTileOptions tileOptions;
  final FancyDioInspectorL10nOptions l10nOptions;
  final Widget? leading;
  final List<Widget>? actions;
  final ThemeData? themeData;
  const FancyDioInspectorView({
    this.tileOptions = const FancyDioInspectorTileOptions(),
    this.l10nOptions = const FancyDioInspectorL10nOptions(),
    this.leading,
    this.actions,
    this.themeData,
    super.key,
  });
  FancyDioLogger get _logger => FancyDioLogger.instance;
  List<NetworkRequestModel> get _requests => _logger.apiRequests;
  List<NetworkResponseModel> get _responses => _logger.apiResponses;
  List<NetworkErrorModel> get _errors => _logger.apiErrors;
  @override
  Widget build(BuildContext context) {
    final tabs = [
      Tab(
        text: l10nOptions.requestsText,
        icon: const Icon(Icons.network_check),
      ),
      Tab(text: l10nOptions.responsesText, icon: const Icon(Icons.list)),
      Tab(text: l10nOptions.errorsText, icon: const Icon(Icons.error)),
    ];
    final tabBarViews = [
      FancyDioTabView(
        components: _requests,
        l10nOptions: l10nOptions,
        tileOptions: tileOptions,
      ),
      FancyDioTabView(
        components: _responses,
        l10nOptions: l10nOptions,
        tileOptions: tileOptions,
      ),
      FancyDioTabView(
        components: _errors,
        l10nOptions: l10nOptions,
        tileOptions: tileOptions,
      ),
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Theme(
        data: themeData ?? context.currentTheme,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(l10nOptions.appBarText),
            bottom: TabBar(tabs: tabs),
            leading: leading,
            actions: actions,
          ),
          body: TabBarView(children: tabBarViews),
        ),
      ),
    );
  }
}