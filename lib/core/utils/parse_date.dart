String parseDate(DateTime endDate) {
  final months = ['янв', 'фев', 'мар', 'апр', 'май', 'июн', 'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'];
  final day = endDate.day.toString();
  final month = months[endDate.month - 1];
  final hours = endDate.hour.toString().padLeft(2, '0');
  final minutes = endDate.minute.toString().padLeft(2, '0');
  return '$day $month $hours:$minutes Мск';
}