import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({Key? key}) : super(key: key);

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  final List<double> values = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  final String _audioUrl =
      // "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";
      "https://mazekaty.com/wp-content/uploads/2022/05/Nafsana-Demo.mp3";
  double _wavePercent = 0;

  @override
  void initState() {
    super.initState();
    getValues();
    listenAudio();
    _audioPlayer.setUrl(_audioUrl);
  }

  listenAudio() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
      print("**Duration${duration.inSeconds}");
    });

    _audioPlayer.onAudioPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
        final percent = (newPosition.inSeconds / duration.inSeconds) * 100;
        _wavePercent = percent;
      });
      print("***position ${position.inSeconds}");
      print("*****waveper $_wavePercent");
    });
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.PLAYING;
      });
    });
  }

  void getValues() {
    var rng = Random();
    for (var i = 0; i < 200; i++) {
      values.add(rng.nextInt(50) * 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            height: 100.0,
            alignment: Alignment.center,
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (isPlaying) {
                            _audioPlayer.pause();
                          } else {
                            _audioPlayer.play(_audioUrl);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                          child:
                              Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                        ),
                      ),
                      // Container(
                      //   alignment: Alignment.center,
                      //   margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      //   width: MediaQuery.of(context).size.width * 0.75,
                      //   child: Stack(
                      //     alignment: Alignment.center,
                      //     children: [
                      //       WaveProgressBar(
                      //         width: MediaQuery.of(context).size.width * 0.75,
                      //         listOfHeights: values,
                      //         progressPercentage: _wavePercent,
                      //         timeInMilliSeconds: 200,
                      //         isHorizontallyAnimated: true,
                      //         isVerticallyAnimated: true,
                      //         initalColor: Colors.blue,
                      //       ),
                      //       Container(
                      //         width: MediaQuery.of(context).size.width * 0.75,
                      //         height: 60.0,
                      //         alignment: Alignment.centerLeft,
                      //         child: Opacity(
                      //           opacity: 0.1,
                      //           child: SliderTheme(
                      //             data: SliderThemeData(
                      //               overlayShape: SliderComponentShape.noThumb,
                      //             ),
                      //             child: Slider(
                      //               value: position.inSeconds.isNaN
                      //                   ? 0
                      //                   : position.inSeconds.toDouble(),
                      //               max: duration.inSeconds.toDouble() + 1.0,
                      //               min: 0,
                      //               onChanged: (value) async {
                      //                 final position =
                      //                     Duration(seconds: value.toInt());
                      //                 await _audioPlayer.seek(position);
                      //                 await _audioPlayer.resume();
                      //               },
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // )
                    ]),
                Container(
                  margin: const EdgeInsets.only(left: 70.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatedTime(position.inSeconds),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        formatedTime(duration.inSeconds),
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatedTime(int secTime) {
    String getParsedTime(String time) {
      if (time.length <= 1) return "0$time";
      return time;
    }

    int min = secTime ~/ 60;
    int sec = secTime % 60;

    String parsedTime =
        getParsedTime(min.toString()) + ":" + getParsedTime(sec.toString());

    return parsedTime;
  }
}
