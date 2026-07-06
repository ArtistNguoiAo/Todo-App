enum NotePriorityEnum {
  low,
  medium,
  high,
}

extension NotePriorityExtension on NotePriorityEnum {
  String get label {
    switch (this) {
      case NotePriorityEnum.low:
        return 'P1';
      case NotePriorityEnum.medium:
        return 'P2';
      case NotePriorityEnum.high:
        return 'P3';
    }
  }
}