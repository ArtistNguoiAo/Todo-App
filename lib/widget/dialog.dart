import 'package:flutter/material.dart';

import 'custom_text.dart';
import 'custom_widgets.dart';
import '../utils/string_utils.dart';


class AppDialog {
  static Future<void> showDeleteDialog({
    required BuildContext context,
    required Future<void> Function() onDelete,
  }) {
    return showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          content: SizedBox(
            width: 200,
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info,
                  color: Colors.grey[600],
                ),
                const SizedBox(height: 20),
                Text(
                  StringUtils.confirmDelete,
                  style: AppTextStyles.bodyLarge(),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DeleteInkWell(
                      bgColor: Colors.grey,
                      text: StringUtils.cancel,
                      onTap: () {
                        Navigator.pop(dialogContext);
                      },
                    ),
                    const SizedBox(width: 30),
                    DeleteInkWell(
                      bgColor: Colors.red,
                      text: StringUtils.delete,
                      onTap: () async {
                        await onDelete();
                        Navigator.pop(dialogContext);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}