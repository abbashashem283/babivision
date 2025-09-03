import 'package:babivision/Utils/Http.dart';
import 'package:babivision/data/storage/SecureStorage.dart';
import 'package:babivision/views/debug/B.dart';
import 'package:flutter/material.dart';

class Playground extends StatefulWidget {
  const Playground({super.key});

  @override
  State<Playground> createState() => _PlaygroundState();
}

class _PlaygroundState extends State<Playground> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: B(
          color: "g",
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder(
                future: Http.get("/api/auth/test"),
                builder: (context, snapshot) {
                  // Check the connection state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    // The data is available here
                    return Text(
                      'Data received: ${snapshot.data!.data.toString()}',
                    );
                  } else {
                    return const Text('No data');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
