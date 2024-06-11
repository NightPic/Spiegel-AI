import 'package:flutter/material.dart';
import 'package:remote_app/drawer.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final buttonWidth =
        screenSize.width / 3; // Divide screen width into 3 equal parts
    final buttonHeight =
        screenSize.height / 3; // Divide screen height into 3 equal parts

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 212, 230, 25),
        title: const Text('Spiegel AI Remote'),
      ),
      endDrawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(
            9,
            (index) => SizedBox(
              width: buttonWidth,
              height: buttonHeight,
              child: Card(
                key: ValueKey(index),
                color: const Color.fromARGB(255, 235, 235, 235),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: const BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    // Handle button tap
                  },
                  child: Center(
                    child: Text('Widget ${index + 1}'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
