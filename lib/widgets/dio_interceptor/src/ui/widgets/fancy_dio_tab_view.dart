import 'package:flutter/material.dart';
import '../../models/fancy_dio_inspector/fancy_dio_inspector_l10n_options.dart';
import '../../models/fancy_dio_inspector/fancy_dio_inspector_tile_options.dart';
import '../../models/network/network_base_model.dart';
import 'fancy_dio_tab_view_item.dart';
import 'fancy_search_field.dart';
class FancyDioTabView<T extends NetworkBaseModel> extends StatefulWidget {
  final FancyDioInspectorTileOptions tileOptions;
  final FancyDioInspectorL10nOptions l10nOptions;
  final List<T> components;
  const FancyDioTabView({
    required this.tileOptions,
    required this.l10nOptions,
    required this.components,
    super.key,
  });
  @override
  State<FancyDioTabView<T>> createState() => _FancyDioTabViewState<T>();
}
class _FancyDioTabViewState<T extends NetworkBaseModel>
    extends State<FancyDioTabView<T>> {
  String searchText = '';
  List<T> get filteredComponents {
    if (searchText.isEmpty) {
      return widget.components;
    }
    return widget.components
        .where((component) => component.contains(searchText))
        .toList();
  }
  void _onSearchChanged(String newValue) {
    setState(() {
      searchText = newValue;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.tileOptions.showSearch) ...[
          Padding(
            padding: const EdgeInsets.all(16),
            child: FancySearchField(
              hintText: widget.l10nOptions.searchHintText,
              onChanged: _onSearchChanged,
            ),
          ),
          const Divider(height: 1),
        ],
        Expanded(
          child: ListView.separated(
            itemCount: filteredComponents.length,
            separatorBuilder: (context, index) => const Divider(height: 8),
            itemBuilder: (context, index) {
              final filteredComponent = filteredComponents[index];
              return Padding(
                padding: const EdgeInsets.all(16),
                child: FancyDioTabViewItem(
                  component: filteredComponent,
                  l10nOptions: widget.l10nOptions,
                  tileOptions: widget.tileOptions,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}