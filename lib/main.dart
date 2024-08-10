import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stopwatch/screens/stopwatch.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    MaterialApp(
      home: App(prefs: prefs,),
    ),
  );
}

class App extends StatelessWidget {
  final SharedPreferences prefs;
  const App({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 3,
      child: Scaffold(
        backgroundColor: Color(0xff222222),
        appBar: AppBar(
          backgroundColor: Color(0xff2b2b2e),
          toolbarHeight: 30,
          bottom: TabBar(
            dividerColor: Color(0xff222222),
            tabs: [
              Tab(
                icon: Icon(
                  Icons.alarm,
                  color: Color(0xffbec2c7),
                ),
                child: Text(
                  "Alarm",
                  style: TextStyle(color: Color(0xffbec2c7)),
                ),
              ),
              Tab(
                icon: Icon(Icons.punch_clock, color: Color(0xffbec2c7)),
                text: "Clock",
              ),
              Tab(
                icon: Icon(Icons.hourglass_bottom, color: Color(0xffbec2c7)),
                text: "Timer",
              ),
              Tab(
                icon: Icon(Icons.timer, color: Color(0xffbec2c7)),
                text: "Stopwatch",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [Text("Alarm"), Text("Clock"), Text("Timer"), StopwatchX(prefs: prefs,)],
        ),
      ),
    );
  }
}
