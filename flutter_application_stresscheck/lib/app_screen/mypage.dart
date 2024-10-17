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
      body: Stack(
        children: [
          // 배경 이미지 추가
          Image.asset(
            'image/bg.png',  // 배경 이미지 경로
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover, // 이미지가 화면을 덮도록 설정
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // 위쪽부터 시작
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'image/logo.png',
                  width: MediaQuery.of(context).size.width * 1.0,
                  height: MediaQuery.of(context).size.width * 0.4,
                ),
                SizedBox(height: 32), // 로고 아래에 여백 추가
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '임재환',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '  님',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    buildInfoRow('성별', '남성'),
                    SizedBox(height: 25),
                    buildInfoRow('나이', '26세'),
                    SizedBox(height: 25),
                    buildInfoRow('수면시간', '8 시간'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 반복되는 Row 생성을 위한 메소드
  Widget buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          '   :   ',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
