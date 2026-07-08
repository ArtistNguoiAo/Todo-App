import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:todo_app/utils/string_utils.dart';

enum NotePriorityEnum {
  low,
  medium,
  high,
}

extension NotePriorityExtension on NotePriorityEnum {
  String get label {
    switch (this) {
      case NotePriorityEnum.low:
        return StringUtils.p3;
      case NotePriorityEnum.medium:
        return StringUtils.p2;
      case NotePriorityEnum.high:
        return StringUtils.p1;
    }
  }

  String get description {
    switch (this) {
      case NotePriorityEnum.low:
        return StringUtils.normal;
      case NotePriorityEnum.medium:
        return StringUtils.important;
      case NotePriorityEnum.high:
        return StringUtils.urgent;
    }
  }

  Color get color {
    switch (this) {
      case NotePriorityEnum.low:
        return Colors.grey;
      case NotePriorityEnum.medium:
        return Colors.blue;
      case NotePriorityEnum.high:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case NotePriorityEnum.low:
        return Icons.remove;
      case NotePriorityEnum.medium:
        return Icons.circle_outlined;
      case NotePriorityEnum.high:
        return Icons.local_fire_department_outlined;
    }
  }
}
