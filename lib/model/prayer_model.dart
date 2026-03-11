class PrayerModel {
  int? code;
  String? status;
  Data? data;

  PrayerModel({this.code, this.status, this.data});

  PrayerModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['code'] = code;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Times? times;
  Date? date;
  Qibla? qibla;
  ProhibitedTimes? prohibitedTimes;
  Timezone? timezone;

  Data({this.times, this.date, this.qibla, this.prohibitedTimes, this.timezone});

  Data.fromJson(Map<String, dynamic> json) {
    times = json['times'] != null ? Times.fromJson(json['times']) : null;
    date = json['date'] != null ? Date.fromJson(json['date']) : null;
    qibla = json['qibla'] != null ? Qibla.fromJson(json['qibla']) : null;
    prohibitedTimes = json['prohibited_times'] != null
        ? ProhibitedTimes.fromJson(json['prohibited_times'])
        : null;
    timezone =
    json['timezone'] != null ? Timezone.fromJson(json['timezone']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (times != null) data['times'] = times!.toJson();
    if (date != null) data['date'] = date!.toJson();
    if (qibla != null) data['qibla'] = qibla!.toJson();
    if (prohibitedTimes != null) {
      data['prohibited_times'] = prohibitedTimes!.toJson();
    }
    if (timezone != null) data['timezone'] = timezone!.toJson();
    return data;
  }
}

class Times {
  String? fajr;
  String? sunrise;
  String? dhuhr;
  String? asr;
  String? sunset;
  String? maghrib;
  String? isha;
  String? imsak;
  String? midnight;
  String? firstthird;
  String? lastthird;

  Times({
    this.fajr,
    this.sunrise,
    this.dhuhr,
    this.asr,
    this.sunset,
    this.maghrib,
    this.isha,
    this.imsak,
    this.midnight,
    this.firstthird,
    this.lastthird,
  });

  Times.fromJson(Map<String, dynamic> json) {
    fajr = json['Fajr'];
    sunrise = json['Sunrise'];
    dhuhr = json['Dhuhr'];
    asr = json['Asr'];
    sunset = json['Sunset'];
    maghrib = json['Maghrib'];
    isha = json['Isha'];
    imsak = json['Imsak'];
    midnight = json['Midnight'];
    firstthird = json['Firstthird'];
    lastthird = json['Lastthird'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['Fajr'] = fajr;
    data['Sunrise'] = sunrise;
    data['Dhuhr'] = dhuhr;
    data['Asr'] = asr;
    data['Sunset'] = sunset;
    data['Maghrib'] = maghrib;
    data['Isha'] = isha;
    data['Imsak'] = imsak;
    data['Midnight'] = midnight;
    data['Firstthird'] = firstthird;
    data['Lastthird'] = lastthird;
    return data;
  }
}

class Date {
  String? readable;
  String? timestamp;
  Hijri? hijri;
  Gregorian? gregorian;

  Date({this.readable, this.timestamp, this.hijri, this.gregorian});

  Date.fromJson(Map<String, dynamic> json) {
    readable = json['readable'];
    timestamp = json['timestamp'];
    hijri = json['hijri'] != null ? Hijri.fromJson(json['hijri']) : null;
    gregorian =
    json['gregorian'] != null ? Gregorian.fromJson(json['gregorian']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['readable'] = readable;
    data['timestamp'] = timestamp;
    if (hijri != null) data['hijri'] = hijri!.toJson();
    if (gregorian != null) data['gregorian'] = gregorian!.toJson();
    return data;
  }
}

class Hijri {
  String? date;
  String? format;
  String? day;
  Weekday? weekday;
  Month? month;
  String? year;
  Designation? designation;
  List<dynamic>? holidays;
  List<dynamic>? adjustedHolidays;
  String? method;
  int? shift;

  Hijri({
    this.date,
    this.format,
    this.day,
    this.weekday,
    this.month,
    this.year,
    this.designation,
    this.holidays,
    this.adjustedHolidays,
    this.method,
    this.shift,
  });

  Hijri.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    format = json['format'];
    day = json['day'];
    weekday =
    json['weekday'] != null ? Weekday.fromJson(json['weekday']) : null;
    month = json['month'] != null ? Month.fromJson(json['month']) : null;
    year = json['year'];
    designation = json['designation'] != null
        ? Designation.fromJson(json['designation'])
        : null;
    holidays = json['holidays'];
    adjustedHolidays = json['adjustedHolidays'];
    method = json['method'];
    shift = json['shift'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['date'] = date;
    data['format'] = format;
    data['day'] = day;
    if (weekday != null) data['weekday'] = weekday!.toJson();
    if (month != null) data['month'] = month!.toJson();
    data['year'] = year;
    if (designation != null) data['designation'] = designation!.toJson();
    data['holidays'] = holidays;
    data['adjustedHolidays'] = adjustedHolidays;
    data['method'] = method;
    data['shift'] = shift;
    return data;
  }
}

class Gregorian {
  String? date;
  String? format;
  String? day;
  Weekday? weekday;
  GregorianMonth? month;
  String? year;
  Designation? designation;

  Gregorian(
      {this.date,
        this.format,
        this.day,
        this.weekday,
        this.month,
        this.year,
        this.designation});

  Gregorian.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    format = json['format'];
    day = json['day'];
    weekday =
    json['weekday'] != null ? Weekday.fromJson(json['weekday']) : null;
    month = json['month'] != null
        ? GregorianMonth.fromJson(json['month'])
        : null;
    year = json['year'];
    designation = json['designation'] != null
        ? Designation.fromJson(json['designation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['date'] = date;
    data['format'] = format;
    data['day'] = day;
    if (weekday != null) data['weekday'] = weekday!.toJson();
    if (month != null) data['month'] = month!.toJson();
    data['year'] = year;
    if (designation != null) data['designation'] = designation!.toJson();
    return data;
  }
}

class Weekday {
  String? en;
  String? ar;

  Weekday({this.en, this.ar});

  Weekday.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['en'] = en;
    data['ar'] = ar;
    return data;
  }
}

class Month {
  int? number;
  String? en;
  String? ar;
  int? days;

  Month({this.number, this.en, this.ar, this.days});

  Month.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    en = json['en'];
    ar = json['ar'];
    days = json['days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['number'] = number;
    data['en'] = en;
    data['ar'] = ar;
    data['days'] = days;
    return data;
  }
}

class GregorianMonth {
  int? number;
  String? en;

  GregorianMonth({this.number, this.en});

  GregorianMonth.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['number'] = number;
    data['en'] = en;
    return data;
  }
}

class Designation {
  String? abbreviated;
  String? expanded;

  Designation({this.abbreviated, this.expanded});

  Designation.fromJson(Map<String, dynamic> json) {
    abbreviated = json['abbreviated'];
    expanded = json['expanded'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['abbreviated'] = abbreviated;
    data['expanded'] = expanded;
    return data;
  }
}

class Qibla {
  Direction? direction;
  Distance? distance;

  Qibla({this.direction, this.distance});

  Qibla.fromJson(Map<String, dynamic> json) {
    direction =
    json['direction'] != null ? Direction.fromJson(json['direction']) : null;
    distance =
    json['distance'] != null ? Distance.fromJson(json['distance']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (direction != null) data['direction'] = direction!.toJson();
    if (distance != null) data['distance'] = distance!.toJson();
    return data;
  }
}

class Direction {
  double? degrees;
  String? from;
  bool? clockwise;

  Direction({this.degrees, this.from, this.clockwise});

  Direction.fromJson(Map<String, dynamic> json) {
    degrees = (json['degrees'] as num?)?.toDouble();
    from = json['from'];
    clockwise = json['clockwise'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['degrees'] = degrees;
    data['from'] = from;
    data['clockwise'] = clockwise;
    return data;
  }
}

class Distance {
  double? value;
  String? unit;

  Distance({this.value, this.unit});

  Distance.fromJson(Map<String, dynamic> json) {
    value = (json['value'] as num?)?.toDouble();
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['value'] = value;
    data['unit'] = unit;
    return data;
  }
}

class ProhibitedTimes {
  TimeRange? sunrise;
  TimeRange? noon;
  TimeRange? sunset;

  ProhibitedTimes({this.sunrise, this.noon, this.sunset});

  ProhibitedTimes.fromJson(Map<String, dynamic> json) {
    sunrise =
    json['sunrise'] != null ? TimeRange.fromJson(json['sunrise']) : null;
    noon = json['noon'] != null ? TimeRange.fromJson(json['noon']) : null;
    sunset =
    json['sunset'] != null ? TimeRange.fromJson(json['sunset']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (sunrise != null) data['sunrise'] = sunrise!.toJson();
    if (noon != null) data['noon'] = noon!.toJson();
    if (sunset != null) data['sunset'] = sunset!.toJson();
    return data;
  }
}

class TimeRange {
  String? start;
  String? end;

  TimeRange({this.start, this.end});

  TimeRange.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['start'] = start;
    data['end'] = end;
    return data;
  }
}

class Timezone {
  String? name;
  String? utcOffset;
  String? abbreviation;

  Timezone({this.name, this.utcOffset, this.abbreviation});

  Timezone.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    utcOffset = json['utc_offset'];
    abbreviation = json['abbreviation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['utc_offset'] = utcOffset;
    data['abbreviation'] = abbreviation;
    return data;
  }
}