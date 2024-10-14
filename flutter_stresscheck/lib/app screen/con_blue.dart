import 'package:flutter/material.dart';
import 'first.dart';

class ConBluePage extends StatefulWidget {
  @override
  _ConBluePageState createState() => _ConBluePageState();
}

class _ConBluePageState extends State<ConBluePage> {
  bool isConnected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: Text('블루투스 연결', style: TextStyle(fontSize: 18)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.bluetooth,
                size: 100,
                color: isConnected ? Colors.blue : Colors.grey,
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: Text(
                  isConnected ? '블루투스 연결됨' : '블루투스 연결 필요',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isConnected = !isConnected;
                  });

                  if (isConnected) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => First()),
                    );
                  }
                },
                child: Text(isConnected ? '연결 해제' : '블루투스 연결'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
