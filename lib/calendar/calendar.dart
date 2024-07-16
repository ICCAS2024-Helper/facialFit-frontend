import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:SmileHelper/calendar/events_provider.dart';
import 'package:SmileHelper/calendar/user_info_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late final ValueNotifier<List> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    _loadEventsIfNeeded();
  }

  Future<void> _loadEventsIfNeeded() async {
    final eventsProvider = context.read<EventsProvider>();
    if (eventsProvider.getEvents().isEmpty) {
      await _fetchUserEvents();
    } else {
      _selectedEvents.value = _getEventsForDay(_selectedDay!);
    }
  }

  Future<void> _fetchUserEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    final response = await http.get(
      Uri.parse('http://34.47.88.29:8082/api/user/events'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final eventsProvider = context.read<EventsProvider>();
      eventsProvider.clearEvents(); // 기존 이벤트 클리어
      jsonResponse.forEach((date, events) {
        events.forEach((event) {
          eventsProvider.setEvents(
              DateTime.parse(date), '', event['iconIndex']);
        });
      });
      _selectedEvents.value = _getEventsForDay(_selectedDay!);
    } else {
      print('Failed to load user events: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  List _getEventsForDay(DateTime day) {
    String dayT = DateFormat('yy/MM/dd').format(day);
    Map<String, List<Map<String, dynamic>>> events =
        context.read<EventsProvider>().getEvents();
    return events[dayT] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Image.asset(
          'assets/images/Logo.png',
          fit: BoxFit.contain,
          height: 32,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                side: BorderSide(color: Colors.grey, width: 2.w),
              ),
              child: TableCalendar(
                headerStyle: HeaderStyle(
                  headerMargin: EdgeInsets.only(bottom: 20.h),
                  titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFF48AA7B),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  formatButtonVisible: false,
                  titleCentered: true,
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 28,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                rowHeight: 60.h,
                locale: 'en-US',
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: _onDaySelected,
                eventLoader: _getEventsForDay,
                calendarStyle: CalendarStyle(
                  markersAlignment: Alignment.bottomCenter,
                  canMarkersOverflow: true,
                  markersMaxCount: 2,
                  markersAnchor: 0.7,
                  todayDecoration: BoxDecoration(
                    color: Color(0xff93bebd),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Color(0xFF207F66),
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle(color: Colors.red),
                ),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) {
                    if (events.isNotEmpty) {
                      List<Map<String, dynamic>> iconEvents =
                          List<Map<String, dynamic>>.from(events);
                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          Map key = iconEvents[index];
                          if (key['iconIndex'] == 1) {
                            return Container(
                              margin: EdgeInsets.only(top: 40.h),
                              child: Image.asset(
                                'assets/images/011-unicorn.png',
                                width: 20.sp,
                                height: 20.sp,
                              ),
                            );
                          } else if (key['iconIndex'] == 2) {
                            return Container(
                              margin: EdgeInsets.only(top: 40.h),
                              child: Image.asset(
                                'assets/images/018-unicorn.png',
                                width: 20.sp,
                                height: 20.sp,
                              ),
                            );
                          } else if (key['iconIndex'] == 3) {
                            return Container(
                              margin: EdgeInsets.only(top: 40.h),
                              child: Image.asset(
                                'assets/images/037-cat.png',
                                width: 20.sp,
                                height: 20.sp,
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                  dowBuilder: (context, day) {
                    if (day.weekday == DateTime.saturday ||
                        day.weekday == DateTime.sunday) {
                      final text = DateFormat.E('en_US').format(day);
                      return Center(
                        child: Text(
                          text,
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }
                  },
                ),
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: ValueListenableBuilder<List>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                    itemCount: value.length < 3 ? value.length : 3,
                    itemBuilder: (context, index) {
                      Map event_icon_index = value[index];
                      String description = '';
                      if (event_icon_index['iconIndex'] == 1) {
                        description = 'Attendance';
                      } else if (event_icon_index['iconIndex'] == 2) {
                        description = 'Bonus Mode Clear';
                      } else if (event_icon_index['iconIndex'] == 3) {
                        description = 'Story Mode Clear';
                      }
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          title: Text(description),
                          trailing: event_icon_index['iconIndex'] == 1
                              ? Image.asset(
                                  'assets/images/011-unicorn.png',
                                  width: 20.sp,
                                  height: 20.sp,
                                )
                              : event_icon_index['iconIndex'] == 2
                                  ? Image.asset(
                                      'assets/images/018-unicorn.png',
                                      width: 20.sp,
                                      height: 20.sp,
                                    )
                                  : Image.asset(
                                      'assets/images/037-cat.png',
                                      width: 20.sp,
                                      height: 20.sp,
                                    ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}