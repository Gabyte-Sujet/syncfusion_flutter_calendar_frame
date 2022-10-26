import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:quiver/time.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CalendarController _calendarController = CalendarController();
  late DateTime today;

  // void tst2() {
  //   _calendarController.displayDate = DateTime(2022, 10, 28);
  // }

  void tst() {
    // setState(() {});
    // _calendarController.view = CalendarView.day;
    // _calendarController.selectedDate = DateTime(2022, 10, 27);

    // _calendarController.displayDate = DateTime(2022, 10, 28);

    // var today = DateTime.now().day - 1;
    itemScrollController.scrollTo(
        index: today.day - 1,
        duration: Duration(seconds: 1),
        curve: Curves.easeInOutCubic);
  }

  List get daysOfMonth {
    var MonthDays = daysInMonth(2022, 10);
    print(MonthDays);
    List days = [];

    for (int i = 0; i < MonthDays; i++) {
      days.add(DateTime(2022, 10).add(Duration(days: i)));
    }

    var lst = List.generate(days.length, (index) {
      return {
        'weekDay': '${DateFormat.E().format(days[index])}',
        'day': days[index].day,
        'tst2': days[index],
      };
      // return {'${DateFormat.E().format(days[index])}': days[index].day};
    });
    return lst;
  }

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  Widget build(BuildContext context) {
    // var x = DateTime.now();
    // print(daysOfMonth);
    // print(DateTime(2021, 10).add(Duration(days: 4)));
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Row(
          //   children: daysOfMonth.map((e) => Text('${e}')).toList(),
          // ),
          Flexible(
            child: ScrollablePositionedList.builder(
              scrollDirection: Axis.horizontal,
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,
              itemCount: daysOfMonth.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  _calendarController.displayDate = daysOfMonth[index]['tst2'];
                  today = daysOfMonth[index]['tst2'];
                  tst();
                  print(daysOfMonth[index]['tst2']);
                },
                child: Container(
                  height: 70,
                  width: 40,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Color(0xffB01E76),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        daysOfMonth[index]['weekDay'],
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        daysOfMonth[index]['day'].toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 8,
            child: Container(
              height: 500,
              child: SfCalendar(
                controller: _calendarController,
                // initialDisplayDate: DateTime.now().add(Duration(days: 1)),
                view: CalendarView.month,
                allowViewNavigation: true,
                allowedViews: <CalendarView>[
                  CalendarView.day,
                  CalendarView.month,
                ],

                showNavigationArrow: true,
                firstDayOfWeek: 1,
                dataSource: MeetingDataSource(_getDataSource()),

                headerHeight:
                    _calendarController.view == CalendarView.day ? 0 : 40,
                // viewHeaderHeight: 0,

                // onTap: (d) => print(d.resource),

                headerStyle: CalendarHeaderStyle(
                  textAlign: TextAlign.center,
                ),
                viewHeaderStyle: ViewHeaderStyle(
                  dayTextStyle: TextStyle(
                    color: Color(0xff8F9BB3),
                  ),
                ),
                onSelectionChanged: (d) {
                  print(d.date);
                  today = d.date!;
                  tst();
                  // setState(() {});
                },
                appointmentBuilder: (context, details) {
                  Meeting detail = details.appointments.first;
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xffFC45B2),
                          // gradient: LinearGradient(
                          //   stops: [
                          //     0.02,
                          //     0.02,
                          //   ],
                          //   colors: [
                          //     Colors.red,
                          //     Colors.white,
                          //   ],
                          // ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 3),
                        padding: EdgeInsets.all(20),
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xffFFF1F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(detail.eventName),
                            // Spacer(),
                            Row(
                              children: [
                                Icon(Icons.timelapse),
                                SizedBox(width: 10),
                                Text(
                                    '${DateFormat('Hm').format(detail.from)} - ${DateFormat('Hm').format(detail.to)}'),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
                timeSlotViewSettings: const TimeSlotViewSettings(
                  // dateFormat: '',
                  // dayFormat: '',
                  // allDayPanelColor: null,
                  startHour: 9,
                  endHour: 22,
                  timeInterval: Duration(minutes: 15),
                  timeFormat: 'hh:mm',
                  timeRulerSize: 50,
                ),

                monthCellBuilder: (context, details) {
                  // if today == datetime.now -->> mashin .....
                  var today = DateTime.now();
                  var appDate = details.date;
                  var appLength = details.appointments.length;
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            color: today.day == appDate.day &&
                                    today.month == appDate.month
                                ? Color(0xffB01E76)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        child: Text(
                          appDate.day.toString(),
                          style: TextStyle(
                              color: today.day == appDate.day &&
                                      today.month == appDate.month
                                  ? Colors.white
                                  : appDate.month == today.month
                                      ? Color(
                                          0xff222B45,
                                        )
                                      : Color(0xff8F9BB3),
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Positioned(
                        left: 35,
                        bottom: 45,
                        child: Container(
                          width: 15,
                          height: 15,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: details.appointments.length > 0
                                ? Color(0xff00B383)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(
                            details.appointments.length > 0
                                ? details.appointments.length.toString()
                                : '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
                monthViewSettings: const MonthViewSettings(
                  appointmentDisplayMode: MonthAppointmentDisplayMode.none,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => tst(),
      ),
    );
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(
      Meeting('Conference', startTime, endTime, const Color(0xFF0F8644), false),
    );

    return meetings;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
