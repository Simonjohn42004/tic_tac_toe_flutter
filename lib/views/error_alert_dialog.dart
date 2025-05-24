import 'package:flutter/widgets.dart';
import 'package:tic_tac_toe/utilities/generic_alert_box.dart';

Future<void> showErrorDialogBox(BuildContext context, String error) {
  return showGenericDialog<void>(
    context: context,
    title: "Error Loading content",
    content: error,
    optionsBuilder: () {
      return {"ok" : null};
    },
  );
}
