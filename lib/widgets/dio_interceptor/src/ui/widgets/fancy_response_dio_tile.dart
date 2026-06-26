import 'package:flutter/material.dart';

import '../../models/fancy_dio_inspector/fancy_dio_inspector_tile_options.dart';
import '../../models/network/network_base_model.dart';
import '../../models/network/network_error_model.dart';
import '../../models/network/network_response_model.dart';
import 'fancy_dio_tile.dart';
import 'fancy_gap.dart';

class FancyResponseNetworkTile<T extends NetworkBaseModel>
    extends StatelessWidget {
  final T component;
  final FancyDioInspectorTileOptions options;
  final String responseTitleText;
  final String errorTitleText;

  const FancyResponseNetworkTile({
    required this.component,
    required this.options,
    required this.responseTitleText,
    required this.errorTitleText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Widget widget;

    switch (T) {
      case NetworkResponseModel:
        final innerComponent = component as NetworkResponseModel;
        widget = FancyDioTile(
          title: '$responseTitleText (${innerComponent.statusCode})',
          description: innerComponent.responseBody,
          options: options,
        );
        break;
      case NetworkErrorModel:
        final innerComponent = component as NetworkErrorModel;
        widget = FancyDioTile(
          title: '$errorTitleText (${innerComponent.statusCode})',
          description: innerComponent.errorBody,
          options: options,
        );
        break;

      default:
        return const SizedBox.shrink();
    }

    return Column(children: [const FancyGap.medium(), widget]);
  }
}
