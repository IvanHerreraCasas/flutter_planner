extension DateTimeJson on DateTime {
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'year': year,
      'month': month,
      'day': day,
      'hour': hour,
      'minute': minute,
      'second': second,
      'millisecond': millisecond,
      'microsecond': microsecond,
    };
  }

  static DateTime fromJson(Map<String, dynamic> json) {
    return DateTime(
      json['year'] as int? ?? 1970,
      json['month'] as int? ?? 1,
      json['day'] as int? ?? 1,
      json['hour'] as int? ?? 0,
      json['minute'] as int? ?? 0,
      json['second'] as int? ?? 0,
      json['millisecond'] as int? ?? 0,
      json['microsecond'] as int? ?? 0,
    );
  }
}

extension DateTimeCopyWith on DateTime {
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    if (isUtc) {
      return DateTime.utc(
        year ?? this.year,
        month ?? this.month,
        day ?? this.day,
        hour ?? this.hour,
        minute ?? this.minute,
        second ?? this.second,
        millisecond ?? this.millisecond,
        microsecond ?? this.microsecond,
      );
    }
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
}
