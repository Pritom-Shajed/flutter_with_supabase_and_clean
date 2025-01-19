part of '../extensions.dart';

extension DateUtils on DateTime {
  String get toDateString =>
      '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';

  String get toTimeString12 => TimeOfDay.fromDateTime(this).toTimeString12;

  String get toDateTimeString => '$toDateString $toTimeString12';

  static DateTime get tomorrow => DateTime.now().nextDay;

  static DateTime get yesterday => DateTime.now().previousDay;

  static DateTime get today => DateTime.now();

  static Iterable<DateTime> daysInRange(DateTime start, DateTime end) sync* {
    var i = start;
    var offset = start.timeZoneOffset;
    while (i.isBefore(end)) {
      yield i;
      i = i.addDays(1);
      var timeZoneDiff = i.timeZoneOffset - offset;
      if (timeZoneDiff.inSeconds != 0) {
        offset = i.timeZoneOffset;
        i = i.subtract(Duration(seconds: timeZoneDiff.inSeconds));
      }
    }
  }

  DateTime get previous => copyWith(day: day - 1);
  DateTime get lastWeek => copyWith(day: day - 7);
  DateTime get thisMonth => copyWith(month: month - 1);
  DateTime get last3Month => copyWith(month: month - 3);
  DateTime get last100Years => copyWith(year: year - 100);

  DateTime get onlyDate => DateTime(year, month, day);

  int get daysInCurrentMonth {
    final nextMonth = (today.month == 12)
        ? DateTime(today.year + 1, 1, 1)
        : DateTime(today.year, today.month + 1, 1);
    final lastDayOfCurrentMonth = nextMonth.subtract(const Duration(days: 1));
    return lastDayOfCurrentMonth.day;
  }

  int get daysInPreviousMonth {
    final thisMonthFirstDay = DateTime(today.year, today.month, 1);
    final previousMonthLastDay =
        thisMonthFirstDay.subtract(const Duration(days: 1));
    final previousMonthFirstDay =
        DateTime(previousMonthLastDay.year, previousMonthLastDay.month, 1);
    return previousMonthLastDay.difference(previousMonthFirstDay).inDays + 1;
  }

  DateTime get dateOnly => DateTime(year, month, day);

  String get monthName => DateFormat.MMMM().format(this);

  bool get isToday {
    final nowDate = DateTime.now();
    return year == nowDate.year && month == nowDate.month && day == nowDate.day;
  }

  int get totalDaysInMonth => DateTime(year, month + 1, 0).day;

  bool get isYesterday {
    final nowDate = DateTime.now();
    return year == nowDate.year &&
        month == nowDate.month &&
        day == nowDate.day - 1;
  }

  bool get isTomorrow {
    final nowDate = DateTime.now();
    return year == nowDate.year &&
        month == nowDate.month &&
        day == nowDate.day + 1;
  }

  DateTime addDays(int amount) => DateTime(
        year,
        month,
        day + amount,
        hour,
        minute,
        second,
        millisecond,
        microsecond,
      );

  DateTime addHours(int amount) => DateTime(
        year,
        month,
        day,
        hour + amount,
        minute,
        second,
        millisecond,
        microsecond,
      );

  DateTime get nextDay => addDays(1);

  DateTime get previousDay => addDays(-1);

  bool isSameDay(DateTime b) =>
      year == b.year && month == b.month && day == b.day;

  List<DateTime> get daysInMonth {
    var first = firstDayOfMonth;
    var daysBefore = first.weekday;
    var firstToDisplay = first.subtract(Duration(days: daysBefore));
    var last = lastDayOfMonth;

    var daysAfter = 7 - last.weekday;

    if (daysAfter == 0) {
      daysAfter = 7;
    }

    var lastToDisplay = last.add(Duration(days: daysAfter));
    return daysInRange(firstToDisplay, lastToDisplay).toList();
  }

  bool get isFirstDayOfMonth => isSameDay(firstDayOfMonth);

  bool get isLastDayOfMonth => isSameDay(lastDayOfMonth);

  DateTime get firstDayOfMonth => DateTime(year, month);

  DateTime get firstDayOfWeek {
    final day = DateTime.utc(year, month, this.day, 12);
    var decreaseNum = day.weekday % 7;
    return subtract(Duration(days: decreaseNum));
  }

  DateTime get lastDayOfWeek {
    final day = DateTime.utc(year, month, this.day, 12);
    var increaseNum = day.weekday % 7;
    return day.add(Duration(days: 7 - increaseNum));
  }

  DateTime get lastDayOfMonth {
    var beginningNextMonth =
        (month < 12) ? DateTime(year, month + 1, 1) : DateTime(year + 1, 1, 1);
    return beginningNextMonth.subtract(const Duration(days: 1));
  }

  DateTime get previousMonth {
    var year = this.year;
    var month = this.month;
    if (month == 1) {
      year--;
      month = 12;
    } else {
      month--;
    }
    return DateTime(
        year, month, day, hour, minute, second, millisecond, microsecond);
  }

  DateTime get previousYear => DateTime(
      year - 1, month, day, hour, minute, second, millisecond, microsecond);

  DateTime get nextMonth {
    var year = this.year;
    var month = this.month;

    if (month == 12) {
      year++;
      month = 1;
    } else {
      month++;
    }
    return DateTime(
        year, month, day, hour, minute, second, millisecond, microsecond);
  }

  DateTime get nextYear => DateTime(
      year + 1, month, day, hour, minute, second, millisecond, microsecond);

  DateTime get previousWeek => subtract(const Duration(days: 7));

  DateTime get nextWeek => add(const Duration(days: 7));

  bool isSameWeek(DateTime b) {
    final a = DateTime.utc(year, month, day);
    b = DateTime.utc(b.year, b.month, b.day);

    final diff = a.toUtc().difference(b.toUtc()).inDays;
    if (diff.abs() >= 7) {
      return false;
    }

    final min = a.isBefore(b) ? a : b;
    final max = a.isBefore(b) ? b : a;
    final result = max.weekday % 7 - min.weekday % 7 >= 0;
    return result;
  }

  Duration get remaining => difference(DateTime(year, month, day + 1));

  int numOfWeeks([int? year2]) {
    DateTime dec28 = DateTime(year2 ?? year, 12, 28);
    int dayOfDec28 = int.parse(DateFormat('D').format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  int get weekNumber {
    int dayOfYear = int.parse(DateFormat('D').format(this));
    int woy = ((dayOfYear - weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = numOfWeeks(year - 1);
    } else if (woy > numOfWeeks(year)) {
      woy = 1;
    }
    return woy;
  }

  bool isBetween(DateTime start, DateTime end) =>
      isAfter(start) && isBefore(end);
}

extension TimeOfDayExt on TimeOfDay {
  DateTime get toDateTime =>
      DateTime.now().copyWith(hour: hour, minute: minute);
  DateTime get toUtcDateTime =>
      DateTime.now().toUtc().copyWith(hour: hour, minute: minute);
  DateTime get toLocalDateTime =>
      DateTime.now().toLocal().copyWith(hour: hour, minute: minute);

  String get toTimeString =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  String get toTimeString12 =>
      '${hourOfPeriod.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} ${period.name}';
}
