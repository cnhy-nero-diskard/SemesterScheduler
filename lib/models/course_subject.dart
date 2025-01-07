class Subject {
  late final String subjectCode;
  late final String subjectName;
  late final String instructor;
  late final DaysWeekMap timeslots;
  late final String classRoomUrl;
  Subject(
      {required this.subjectCode,
      required this.subjectName,
      required this.instructor,
      required this.timeslots,
      required this.classRoomUrl});
}

class TimeSlot {
  late final double inseconds;

  String formatHourMinute() {
    String formattedString = "";

    double hours = this.inseconds / (3600);
    double minutes = (this.inseconds % 3600);
    int seconds = (minutes % 60).floor();

    formattedString =
        "${hours.floor()} : ${(minutes / 60).floor()}"; //}${seconds}";
    return formattedString;
  }

  TimeSlot({required this.inseconds});
}

class DaysWeekMap {
  late final Map<WeekDay, List<TimeSlot>> scheds;
  DaysWeekMap({required this.scheds});
}

enum WeekDay {
  MONDAY,
  TUESDAY,
  WEDNESDAY,
  THURSDAY,
  FRIDAY,
}
/*
7:30 = 27000
8:30 = 30600
9:30 = 34200
10:30 = 37800
11:30 = 41400
12:30 = 45000
13:30 = 48600
14:30 = 52200
15:30 = 55800
16:30 = 59400
17:30 = 63000
18:30 = 66600
19:30 = 70200
20:30 = 73800 
*/