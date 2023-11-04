import 'package:flutter/material.dart';
import 'package:my_schedule/utils/theme/colorTheme.dart';

class RenameDialog extends AlertDialog {
  RenameDialog({super.key, required Widget contentWidget})
      : super(
          content: contentWidget,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: primary, width: 1)),
        );
}
