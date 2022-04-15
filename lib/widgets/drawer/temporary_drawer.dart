import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../common/wave_clipper.dart';

class TemporaryDrawer extends StatelessWidget {
  const TemporaryDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        body: Column(
          children: [
            SizerUtil.orientation == Orientation.portrait
                ? ClipPath(
                    clipper: WaveClipper(),
                    child: Container(
                      height: 30.h,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                : SizedBox(
                    height: 5.h,
                  ),
            SizedBox(
              height:
                  SizerUtil.orientation == Orientation.portrait ? 20.h : 50.w,
            ),
            const CircularProgressIndicator(),
            const SizedBox(
              height: 10,
            ),
            Container(
              child: const Center(child: Text("Loading...")),
            ),
          ],
        ),
      ),
    );
  }
}
