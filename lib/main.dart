import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: IosSlider(),
        ),
      ),
    );
  }
}

const height = 385.0;

class IosSlider extends StatefulWidget {
  const IosSlider({super.key});

  @override
  State<IosSlider> createState() => _IosSliderState();
}

class _IosSliderState extends State<IosSlider> {
  double progress = 0.0;

  double stretch = 0.0;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue,
            Colors.blue.shade800,
            Colors.blue.shade900,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Transform.translate(
          offset: Offset(0, -stretch * 10),
          child: SizedBox(
            width: 140 - (stretch.abs() * 7),
            height: height + (stretch.abs() * 10),
            child: GestureDetector(
              onVerticalDragEnd: (details) async {
                for (var i = 0.0; i < 1; i += 0.05) {
                  setState(() {
                    stretch = lerpDouble(stretch, 0.0, i)!;
                  });
                  await Future.delayed(const Duration(milliseconds: 25));
                }
              },
              onVerticalDragUpdate: (details) {
                final double delta = -(details.delta.dy / height);
                final newProgress = progress + delta;

                if (newProgress > 1.0 || newProgress <= 0.0) {
                  setState(() {
                    stretch += delta;
                  });
                } else {
                  setState(() {
                    progress = newProgress;
                  });
                }
              },
              child: ClipPath(
                clipBehavior: Clip.antiAlias,
                clipper: const ShapeBorderClipper(
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                  ),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ColoredBox(
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    if (progress > 0.0)
                      FractionallySizedBox(
                        heightFactor: progress,
                        alignment: Alignment.bottomCenter,
                        child: const ColoredBox(
                          color: Colors.white,
                        ),
                      )
                    else
                      SizedBox.shrink(),
                    Positioned(
                      bottom: 40,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: AnimatedIcon(
                          size: 48,
                          icon: AnimatedIcons.ellipsis_search,
                          progress: AlwaysStoppedAnimation(progress),
                        ),
                      ),
                    ),
                    // Center(
                    //   child: Text(
                    //     stretch.toStringAsFixed(2),
                    //     style: const TextStyle(
                    //       color: Colors.black,
                    //       fontSize: 24,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



// double getProgress(Offset globalPostition) {
//   final double localY = globalPostition.dy;
//   final double progress = height / localY;
//   return progress.clamp(0.0, 1.0);
// }
