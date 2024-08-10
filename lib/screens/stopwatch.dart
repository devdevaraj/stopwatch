import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StopwatchX extends StatefulWidget {
  const StopwatchX({super.key, required this.prefs});
  final SharedPreferences prefs;

  @override
  State<StopwatchX> createState() => _StopwatchStateX();
}

class _StopwatchStateX extends State<StopwatchX> {
  DateTime? start;
  Duration? time;
  List<Duration> lapse = [];
  Duration? getTime() {
    final timeElapsed = DateTime.now().difference(start!);
    return timeElapsed;
  }

  void call() {
    Future.delayed(Duration(milliseconds: 10), () {
      if (start == null) return;
      setState(() {
        time = getTime();
      });
      call();
    });
  }

  String getMilli(Duration duration) {
    int ms = (duration.inMilliseconds - duration.inSeconds * 1000) ~/ 10;
    return ms.toString();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.prefs.getString("start");
    final lapseData = widget.prefs.getStringList("lapse");
    if (data != null) {
      DateTime startTime = DateTime.parse(data);
      start = startTime;
      call();
    }
    if (lapseData != null) {
      lapse = lapseData.map((e) {
        final a = e.split(":");
        return Duration(
          hours: int.parse(a[0]),
          minutes: int.parse(a[1]),
          seconds: int.parse(a[2].split(".")[0]),
          microseconds: int.parse(a[2].split(".")[1]),
        );
      }).toList();
    }
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 300,
                width: 300,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(150),
                    border: Border.all(color: Color(0xffffffff), width: 6)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      (time?.inSeconds.toString() ?? "00"),
                      style: const TextStyle(
                        fontSize: 90,
                        color: Color(0xff87acf2),
                      ),
                    ),
                    Text(
                      time != null ? getMilli(time ?? Duration.zero) : "00",
                      style: const TextStyle(
                        fontSize: 45,
                        color: Color(0xff87acf2),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: double.infinity),
              SizedBox(
                height: 300,
                width: 300,
                child: ListView(
                  children: [
                    ...lapse.reversed.map((e) => ListTile(
                          leading: const Icon(Icons.more_time_outlined),
                          title: Text(
                            "${e.inSeconds}:${getMilli(e)}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ))
                  ],
                ),
              )
            ],
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.all(35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      start = null;
                      time = null;
                      lapse.clear();
                    });
                    widget.prefs.remove("lapse");
                    widget.prefs.remove("start");
                  },
                  child: const Text(
                    "Reset",
                    style: TextStyle(color: Color(0xffffffff), fontSize: 17),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (start == null) {
                      setState(() {
                        start = DateTime.now();
                      });
                      widget.prefs.setString("start", start.toString());
                      call();
                    } else {
                      setState(() {
                        start = null;
                      });
                      widget.prefs.remove("start");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 30,
                      padding: const EdgeInsets.all(30),
                      shape: const CircleBorder(),
                      backgroundColor: const Color(0xff8ab4f8)),
                  child: Icon(
                    start == null
                        ? Icons.play_arrow_outlined
                        : Icons.pause_outlined,
                    size: 30,
                    color: const Color(0xff212120),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (start != null) {
                      final lap = DateTime.now().difference(start!);
                      lapse.add(lap);
                      List<String> parsed =
                          lapse.map((e) => e.toString()).toList();
                      widget.prefs.setStringList("lapse", parsed);
                    }
                  },
                  child: const Text(
                    "Lapse",
                    style: TextStyle(color: Color(0xffffffff), fontSize: 17),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
