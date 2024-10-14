import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: Text('마이 페이지', style: TextStyle(fontSize: 18)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              '이름',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '임재환',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              '나이',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '26세',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              '성별',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '남성',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              '수면 시간',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '8 시간',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
