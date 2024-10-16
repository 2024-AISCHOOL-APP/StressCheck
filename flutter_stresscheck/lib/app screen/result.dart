import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'stress_map.dart'; // stress_map 페이지 임포트

class ResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedTime = DateFormat('MM월 dd일 HH:mm').format(now); // 'MM월 dd일 HH:mm' 형식으로 시간 포맷팅

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: Row(
          children: [
            Expanded(child: Container()),
            Text('임재환 님', style: TextStyle(fontSize: 18)),
          ],
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedTime, // 현재 시간을 표시
                  style: TextStyle(fontSize: 25),
                ),
                Text(
                  '26세 남성',
                  style: TextStyle(fontSize: 25),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('심박수', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text('90', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Text('BPM', style: TextStyle(fontSize: 20)),
                  ],
                ),
                Row(
                  children: [
                    Text('산소포화도', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text('90', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Text('BPM', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    color: Colors.blue,
                    alignment: Alignment.center,
                    child: Text('낮음', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    color: Colors.lightGreen,
                    alignment: Alignment.center,
                    child: Text('주의', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    color: Colors.green,
                    alignment: Alignment.center,
                    child: Text('정상', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    color: Colors.yellow,
                    alignment: Alignment.center,
                    child: Text('주의', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    color: Colors.red,
                    alignment: Alignment.center,
                    child: Text('높음', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
              ],
            ),
            Container(
              child: Column(
                children: [
                  SizedBox(height: 15,),
                  Row(
                    children: [
                      Text('체온:  ',style: TextStyle(fontSize: 25)),
                      Text('36.5 ',style: TextStyle(fontSize: 25)),
                      Text('도',style: TextStyle(fontSize: 25)),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text('혈압:  ',style: TextStyle(fontSize: 25)),
                      Text('118 ',style: TextStyle(fontSize: 25)),
                      Text('mmHg',style: TextStyle(fontSize: 25)),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(

                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('스트레스 지수', style: TextStyle(fontSize: 16)),
                  Text('높음', style: TextStyle(fontSize: 24, color: Colors.red)),
                  SizedBox(height: 250, width: double.infinity),
                ],
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StressMapPage()),
                  );
                },
                child: Text('캘린더로 이동'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
