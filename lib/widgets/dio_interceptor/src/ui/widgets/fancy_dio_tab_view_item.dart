import 'package:flutter/material.dart';
import '../../models/fancy_dio_inspector/fancy_dio_inspector_l10n_options.dart';
import '../../models/fancy_dio_inspector/fancy_dio_inspector_tile_options.dart';
import '../../models/network/network_base_model.dart';
import '../../models/network/network_error_model.dart';
import '../../models/network/network_response_model.dart';
import '../../utils/extensions/context_extensions.dart';
import '../../utils/extensions/date_time_extensions.dart';
import 'fancy_dio_tile.dart';
import 'fancy_elevated_button.dart';
import 'fancy_gap.dart';
import 'fancy_response_dio_tile.dart';
class FancyDioTabViewItem<T extends NetworkBaseModel> extends StatelessWidget {
  final T component;
  final FancyDioInspectorTileOptions tileOptions;
  final FancyDioInspectorL10nOptions l10nOptions;
  const FancyDioTabViewItem({
    required this.component,
    required this.tileOptions,
    required this.l10nOptions,
    super.key,
  });
  String get time {
    final innerTime = component.time.toFormattedString();
    if (component is NetworkResponseModel) {
      final model = component as NetworkResponseModel;
      return model.getFormattedTime();
    } else if (component is NetworkErrorModel) {
      final model = component as NetworkErrorModel;
      return model.getFormattedTime();
    } else {
      return innerTime;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (tileOptions.showButtons) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: FancyElevatedButton.cURL(
                  text: l10nOptions.cURLText,
                  onPressed: () {
                    context
                      ..showSnackBar(l10nOptions.cURLCopiedText)
                      ..copyToClipboard(component.cURL);
                  },
                ),
              ),
              const FancyGap.medium(),
              Expanded(
                child: FancyElevatedButton.copy(
                  text: l10nOptions.copyText,
                  onPressed: () {
                    context
                      ..showSnackBar(l10nOptions.copiedText)
                      ..copyToClipboard(component.toClipboardText());
                  },
                ),
              ),
            ],
          ),
          const FancyGap.medium(),
        ],
        FancyDioTile(
          title: '${l10nOptions.urlTitleText} (${component.method})',
          description: component.url,
          options: tileOptions,
        ),
        if (component.method != 'GET') ...[
          const FancyGap.medium(),
          FancyDioTile(
            title: l10nOptions.requestTitleText,
            description: component.requestBody,
            options: tileOptions,
          ),
        ],
        FancyResponseNetworkTile(
          component: component,
          options: tileOptions,
          responseTitleText: l10nOptions.responseTitleText,
          errorTitleText: l10nOptions.errorTitleText,
        ),
        const FancyGap.medium(),
        FancyDioTile(
          title: l10nOptions.headersTitleText,
          description: component.headers,
          options: tileOptions,
        ),
        const FancyGap.medium(),
        FancyDioTile(description: time, options: tileOptions),
      ],
    );
  }
}