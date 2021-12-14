import 'dart:math';
import 'package:flutter/material.dart';

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  const SeekBar({
    required this.duration,
    required this.position,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  late SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 2.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SliderTheme(
        data: _sliderThemeData.copyWith(
          activeTrackColor: Colors.orange,
          thumbColor: Colors.orange,
          inactiveTrackColor: Colors.grey.shade300,
        ),
        child: Slider(
          min: 0.0,
          max: widget.duration.inMilliseconds.toDouble(),
          value: min(widget.position.inMilliseconds.toDouble(),
              widget.duration.inMilliseconds.toDouble()),
          onChanged: (value) {
            setState(() {
            });
            if (widget.onChanged != null) {
              widget.onChanged!(Duration(milliseconds: value.round()));
            }
          },
          onChangeEnd: (value) {
            if (widget.onChangeEnd != null) {
              widget.onChangeEnd!(Duration(milliseconds: value.round()));
            }
          },
        ),
      ),
      Positioned(
        left: 20.0,
        bottom: -4,
        child: Text(
            RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                    .firstMatch('$_position')
                    ?.group(1) ??
                '$_position',
            style: const TextStyle(color: Colors.black,fontSize: 15)),
      ),
      Positioned(
        right: 20.0,
        bottom: -4,
        child:Text(
            RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                .firstMatch('$_remaining')
                ?.group(1) ??
                '$_remaining',
            style: const TextStyle(color: Colors.black,fontSize: 15)),
      ),
    ]);
  }

  Duration get _remaining => widget.duration;
  Duration get _position => widget.position;
}
