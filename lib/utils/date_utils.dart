import 'package:todo_app/utils/string_utils.dart';

//named record, gồm 2 trường: title, date
({String title, String date}) getDateTitle(DateTime date) {
  final now = DateTime.now();

  final today = DateTime(
    now.year,
    now.month,
    now.day,
  );
  //tính khoảng cách giữa hai ngày, trả về số ngày
  final diff = date.difference(today).inDays;

  //chuyển DateTime thành chuỗi theo định dạng dd/MM/yyyy
  //chuoi.padLeft(độ_dài, ký_tự_thêm) hàm thêm ký tự vào bên trái chuỗi cho đến khi đạt độ dài mong muốn
  final fullDate =
      "${date.day.toString().padLeft(2, '0')}/"
      "${date.month.toString().padLeft(2, '0')}/"
      "${date.year.toString()}";

  if (diff == 1) {
    return (
      title: StringUtils.tomorrow,
      date: fullDate,
    );
  }

  if (diff == 0) {
    return (
      title: StringUtils.today,
      date: fullDate,
    );
  }

  if (diff == -1) {
    return (
      title: StringUtils.yesterday,
      date: fullDate,
    );
  }

  //List bắt đầu từ 0, date.weekday bắt đầu từ 1
  final weekDay = StringUtils.weekDays[date.weekday - 1]; //date.weekday trả về 1(Monday), 2(Tuesday),....

  return (
    title: "$weekDay, ${date.day} tháng ${date.month}",
    date: fullDate,
  );
}