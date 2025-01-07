import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:myapp_536_semlister/models/course_subject.dart';
import 'package:myapp_536_semlister/models/cpe3b_courseSubjects.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const MainHome());

class MainHome extends StatelessWidget {
  const MainHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Semester1",
      home: HomeSemester(),
    );
  }
}

class HomeSemester extends StatefulWidget {
  const HomeSemester({super.key});

  @override
  State<HomeSemester> createState() => HomeSemesterState();
}
//"MONDAY"[TimeSlot(inseconds: 59400), TimeSlot(inseconds: 63000)]}

class HomeSemesterState extends State<HomeSemester> {
  bool checkIfDateIsToday(int givenDate) {
    return (DateTime.now().weekday == givenDate + 1);
  }

  Map<String, WeekDay> day = {
    "MONDAY": WeekDay.MONDAY,
    "TUESDAY": WeekDay.TUESDAY,
    "WEDNESDAY": WeekDay.WEDNESDAY,
    "THURSDAY": WeekDay.THURSDAY,
    "FRIDAY": WeekDay.FRIDAY,
  };

  List<Subject> subjects = [
    Bscpe3b.CPE311,
    Bscpe3b.CPE312,
    Bscpe3b.CPE313,
    Bscpe3b.CPE314,
    Bscpe3b.CPE315,
    Bscpe3b.CPE316,
    Bscpe3b.CPE317,
    Bscpe3b.CPE318,
    Bscpe3b.CPE319,
    Bscpe3b.TE01
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.teal,
        child: Padding(
          padding: const EdgeInsets.all(80.0),
          child: Container(
            child: Column(
              children: [
                Card(
                    color: Colors.red,
                    child: Container(
                        padding: const EdgeInsets.all(40),
                        child: const Text("BY PAUL ANDRE"))),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.tealAccent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "BSCPE 3B - SEMESTER 2",
          style: TextStyle(color: Colors.pinkAccent),
        ),
      ),
      body: Column(
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.amberAccent,
            child: const Center(
              child: Text(
                "S C H E D U L E",
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ),
          Expanded(
            child: Container(
                padding: const EdgeInsets.all(8),
                width: double.maxFinite,
                child: SchedLister()),
          )
        ],
      ),
    );
  }

  ListView SchedLister() {
    return ListView.builder(
      itemCount: day.length,
      physics: const BouncingScrollPhysics(
          decelerationRate: ScrollDecelerationRate.normal),
      itemBuilder: (context, index) {
        final daykeys = day.keys.toList()[index];
        return Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(
                      color: Colors.yellowAccent,
                      width: (checkIfDateIsToday(index) ? 5 : 0))),
              color: Colors.pink,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    ListTile(
                      trailing: Icon(
                        Icons.sunny,
                        color: checkIfDateIsToday(index)
                            ? Colors.yellow
                            : Colors.grey,
                      ),
                      title: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: (checkIfDateIsToday(index))
                            ? Colors.yellow
                            : Colors.blue.shade400,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            daykeys,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SubjectLister(
                        subjects: subjects,
                        day: day,
                        daykeys: daykeys,
                        isToday: checkIfDateIsToday(index))
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        );
      },
    );
  }
}

class SubjectLister extends StatelessWidget {
  const SubjectLister(
      {super.key,
      required this.subjects,
      required this.day,
      required this.daykeys,
      required this.isToday});

  final List<Subject> subjects;
  final Map<String, WeekDay> day;
  final String daykeys;
  final bool isToday;

  bool activeTimeHighlight(double start, double end) {
    var now = DateTime.now();
    int hour = now.hour;
    int minute = now.minute;
    int second = now.second;

    int totalSeconds = hour * 3600 + minute * 60 + second;
    print("right now - $totalSeconds seconds == ${now}");

    return (start < totalSeconds && totalSeconds < end && isToday);
  }

  @override
  Widget build(BuildContext context) {
    String currentActive = "";
    Future<bool> isInstalled() async {
      return await LaunchApp.isAppInstalled(
          androidPackageName: 'com.google.android.apps.classroom');
    }

    void openGoogleClassroom() async {
      // Get the Google Classroom app URI.
      String classroomUri = 'https://classroom.google.com/';

      // Try to launch the Google Classroom app.
      await launch(classroomUri);
    }

    print("IS BROTHER INSTALLED: ${isInstalled().toString()}");

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.pinkAccent,
      child: SizedBox(
        // height: 200,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(
              decelerationRate: ScrollDecelerationRate.fast),
          shrinkWrap: true,
          itemCount: subjects.length,
          itemBuilder: (context, bindex) {
            Subject current = subjects[bindex];
            Map<WeekDay, List<TimeSlot>> timeslots = current.timeslots.scheds;

            return (timeslots[day[daykeys]]!.isNotEmpty)
                ? Column(
                    children: [
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          showModalBottomSheet(
                            enableDrag: true,
                            elevation: 15,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            color: Colors.pink,
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                "SUBJECT NAME : ${current.subjectName}",
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            color: Colors.pink,
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                "SUBJECT CODE : ${current.subjectCode}",
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            color: Colors.pink,
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                "INSTRUCTOR : ${current.instructor}",
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          // ElevatedButton(
                                          //     style: const ButtonStyle(
                                          //         backgroundColor:
                                          //             MaterialStatePropertyAll(
                                          //                 Colors.green)),
                                          //     onPressed: () async {
                                          //       await LaunchApp.openApp(
                                          //           androidPackageName:
                                          //               'com.google.android.apps.classroom',
                                          //           // appStoreLink:
                                          //           //     "https://play.google.com/store/apps/details?id=com.google.android.apps.classroom&hl=en&gl=US",
                                          //           openStore:
                                          //               await isInstalled());
                                          //     },
                                          //     child: Text("LAUNCH CLASSROOM")),
                                          ElevatedButton(
                                              style: const ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStatePropertyAll(
                                                          Colors.green)),
                                              onPressed: () async {
                                                Uri classroomURL = Uri.parse(
                                                    current.classRoomUrl);
                                                if (await canLaunchUrl(
                                                    classroomURL)) {
                                                  launchUrl(classroomURL);
                                                }
                                              },
                                              child: Text("LAUNCH CLASSROOM")),
                                        ],
                                      ),
                                    ),
                                  ));
                            },
                          );
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                        minWidth: 0,
                        child: Card(
                          color: Colors.blue.shade100,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                  color: Colors.greenAccent,
                                  width: (activeTimeHighlight(
                                          timeslots[day[daykeys]]![0].inseconds,
                                          timeslots[day[daykeys]]![1]
                                              .inseconds))
                                      ? 2
                                      : 0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Card(
                                    color: activeTimeHighlight(
                                            timeslots[day[daykeys]]![0]
                                                .inseconds,
                                            timeslots[day[daykeys]]![1]
                                                .inseconds)
                                        ? Colors.greenAccent
                                        : Colors.lightBlue.shade200,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 8),
                                      child: Text(
                                        current.subjectCode,
                                        style: const TextStyle(),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    width: 150,
                                    child: Text(
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.redAccent.shade700),
                                        overflow: TextOverflow.ellipsis,
                                        current.subjectName),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Card(
                                    color: activeTimeHighlight(
                                            timeslots[day[daykeys]]![0]
                                                .inseconds,
                                            timeslots[day[daykeys]]![1]
                                                .inseconds)
                                        ? Colors.greenAccent
                                        : Colors.lightBlue.shade200,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomLeft: Radius.circular(20),
                                            topRight: Radius.circular(5),
                                            bottomRight: Radius.circular(5))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        timeslots[day[daykeys]]![0]
                                            .formatHourMinute(),
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ),
                                  Card(
                                    color: activeTimeHighlight(
                                            timeslots[day[daykeys]]![0]
                                                .inseconds,
                                            timeslots[day[daykeys]]![1]
                                                .inseconds)
                                        ? Colors.greenAccent
                                        : Colors.lightBlue.shade200,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            bottomLeft: Radius.circular(5),
                                            topRight: Radius.circular(20),
                                            bottomRight: Radius.circular(20))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        timeslots[day[daykeys]]![1]
                                            .formatHourMinute(),
                                        style: const TextStyle(
                                            color: Colors.purpleAccent),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  )
                : const SizedBox();
          },
        ),
      ),
    );
  }
}
