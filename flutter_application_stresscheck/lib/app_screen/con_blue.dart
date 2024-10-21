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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // 모서리 둥글게 설정
      ),
      child: Container(
        
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0), // 모서리 둥글게 설정
          image: DecorationImage(
            image: AssetImage('image/bg.png'), // 배경 이미지 설정
            fit: BoxFit.cover, // 이미지가 팝업 크기를 덮도록 설정
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bluetooth,
              size: 100,
              color: isConnected ? Colors.blue : Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              isConnected ? '블루투스 연결됨' : '블루투스 연결 필요',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[50], // 버튼 배경색
                foregroundColor: Colors.black, // 글씨 색
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8), // 패딩 설정
              ),
              onPressed: () {
                setState(() {
                  isConnected = !isConnected;
                });

                if (isConnected) {
                  // 팝업을 닫고 First 페이지로 이동
                  Navigator.pop(context); // 팝업 닫기
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => First()), // First 페이지로 이동
                  );
                }
              },
              child: Text(isConnected ? '연결 해제' : '블루투스 연결'),
            ),
          ],
        ),
      ),
    );
  }
}
