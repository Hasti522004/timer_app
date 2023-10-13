import 'dart:async';

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class ReverseTimer extends StatefulWidget {
  const ReverseTimer({super.key});

  @override
  State<ReverseTimer> createState() => _ReverseTimerState();
}

class _ReverseTimerState extends State<ReverseTimer> {
  Duration duration = Duration();
  var hour = 0;
  var minute = 0;
  var second = 0;
  bool isTimerRunning = false;
  Timer? timer;
  List<String> flagTimestamps = [];

  final TextStyle greyTextStyle =
      const TextStyle(color: Colors.grey, fontSize: 20);
  final TextStyle selectedTextStyle =
      const TextStyle(color: Color.fromARGB(255, 43, 184, 255), fontSize: 30);

  final BoxDecoration commonBoxDecoration = const BoxDecoration(
    border: Border(
      top: BorderSide(color: Colors.white),
      bottom: BorderSide(color: Colors.white),
    ),
  );

  String twodigit(int n) {
    return n.toString().padLeft(2, '0');
  }

  void toggleTimer() {
    setState(() {
      if (isTimerRunning) {
        timer?.cancel();
      } else {
        startTimer();
      }
      isTimerRunning = !isTimerRunning;
    });
  }

  void startTimer() {
    int totalSeconds = (hour * 3600) + (minute * 60) + second;
    duration = Duration(seconds: totalSeconds);

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      addTimer();
      if (duration.inSeconds <= 0) {
        stopTimer();
      }
      setState(() {});
    });
  }

  void addTimer() {
    duration = Duration(seconds: duration.inSeconds - 1);
    setState(() {});
  }

  void stopTimer() {
    timer?.cancel();
  }

  void resetTimer() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    isTimerRunning = false;
    duration = Duration();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    String hr = twodigit(duration.inHours);
    String min = twodigit(duration.inMinutes.remainder(60));
    String sec = twodigit(duration.inSeconds.remainder(60));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.black,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    NumberPicker(
                      minValue: 0,
                      maxValue: 24,
                      value: hour,
                      onChanged: (value) {
                        setState(() {
                          hour = value;
                        });
                      },
                      textStyle: greyTextStyle,
                      selectedTextStyle: selectedTextStyle,
                      decoration: commonBoxDecoration,
                    ),
                    NumberPicker(
                      minValue: 0,
                      maxValue: 60,
                      value: minute,
                      onChanged: (value) {
                        setState(() {
                          minute = value;
                        });
                      },
                      textStyle: greyTextStyle,
                      selectedTextStyle: selectedTextStyle,
                      decoration: commonBoxDecoration,
                    ),
                    NumberPicker(
                      minValue: 0,
                      maxValue: 60,
                      value: second,
                      onChanged: (value) {
                        setState(() {
                          second = value;
                        });
                      },
                      textStyle: greyTextStyle,
                      selectedTextStyle: selectedTextStyle,
                      decoration: commonBoxDecoration,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  width: 300.0,
                  height: 300.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        width: 2.0, color: Color.fromARGB(255, 43, 184, 255)),
                  ),
                  child: Center(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "$hr:$min:$sec",
                        style: TextStyle(fontSize: 50, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                // digitDisply(hr),
                // digitDisply(min),
                // digitDisply(sec),

                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2.0,
                          color: Colors.white,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          resetTimer();
                          flagTimestamps = [];
                        },
                        icon: Icon(
                          Icons.refresh,
                          size: 30,
                          color: Color.fromARGB(255, 43, 184, 255),
                        ),
                      ),
                    ),
                    Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2.0,
                          color: Colors.white,
                        ),
                      ),
                      child: IconButton(
                        onPressed: toggleTimer,
                        icon: Icon(
                          isTimerRunning ? Icons.stop : Icons.play_arrow,
                          size: 30,
                          color: Color.fromARGB(255, 43, 184, 255),
                        ),
                      ),
                    ),
                    Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2.0,
                          color: Colors.white,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            String timestamp = '$hr:$min:$sec';
                            flagTimestamps.add(timestamp);
                          });
                        },
                        icon: Icon(
                          Icons.flag,
                          size: 30,
                          color: Color.fromARGB(255, 43, 184, 255),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // reverse method add the new flag value in start and map will map that value in lst
                Expanded(
                  child: ListView(
                    children: flagTimestamps.reversed
                        .toList()
                        .asMap()
                        .entries
                        .map((entry) => ListTile(
                              //REVERSE INDEXING
                              title: Text(
                                '${flagTimestamps.length - entry.key}. ${entry.value}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              backgroundColor: Color.fromARGB(255, 43, 184, 255),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
