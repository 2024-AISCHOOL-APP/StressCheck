import 'package:abcd/screens/uuid_scan.dart'; // uuid_scan.dart 파일을 import
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart'; // 권한 패키지 추가

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final title = 'Flutter BLE Scan Demo';

  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const MyHomePage(title: 'BLE Device Scanner'), // 홈 화면을 MyHomePage로 설정
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ScanResult> scanResultList = [];
  ValueNotifier<bool> isScanning = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    initBle();
  }

  // BLE 스캔 상태 리스너 초기화
  void initBle() {
    FlutterBluePlus.isScanning.listen((scanning) {
      isScanning.value = scanning;
    });
  }

  // 권한 요청 함수
  Future<void> requestPermissions() async {
    if (await Permission.bluetoothScan.isDenied ||
        await Permission.bluetoothConnect.isDenied ||
        await Permission.location.isDenied) {
      await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.location,
      ].request();
    }
  }

  // 스캔 시작/정지 함수
  Future<void> scan() async {
    await requestPermissions(); // 권한 요청

    if (await Permission.bluetoothScan.isGranted &&
        await Permission.bluetoothConnect.isGranted &&
        await Permission.location.isGranted) {
      // BLE 스캔 로직 실행
      scanResultList.clear();
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 60));
      listenToScanResults();
    } else {
      // 권한이 허용되지 않음
      print("Bluetooth or Location permissions are not granted");
    }
  }

  // 스캔 결과 리스너
  void listenToScanResults() {
    FlutterBluePlus.scanResults.listen((results) {
      print("Scan results received: ${results.length} devices found.");
      scanResultList = results.toList(); // 필터링 제거: 모든 장치를 표시
      setState(() {});
    });
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }

  // 장치의 이름을 얻는 함수
  String getDeviceName(ScanResult r) {
    if (r.device.name.isNotEmpty) {
      return r.device.name;
    } else if (r.advertisementData.localName.isNotEmpty) {
      return r.advertisementData.localName;
    } else {
      return 'N/A';
    }
  }

  // 장치의 신호 세기 표시
  Widget deviceSignal(ScanResult r) {
    return Text(r.rssi.toString());
  }

  // 장치의 MAC 주소 표시
  Widget deviceMacAddress(ScanResult r) {
    return Text(r.device.id.toString());
  }

  // 장치 이름 표시
  Widget deviceName(ScanResult r) {
    return Text(getDeviceName(r));
  }

  // BLE 아이콘 표시
  Widget leading(ScanResult r) {
    return const CircleAvatar(
      backgroundColor: Colors.cyan,
      child: Icon(
        Icons.bluetooth,
        color: Colors.white,
      ),
    );
  }

  // 장치 선택 시 처리 (장치와 연결 후 UUID 화면으로 이동)
  void onTap(ScanResult r) async {
    try {
      // 선택한 장치와 연결 시도
      await r.device.connect();
      print('Connected to ${r.device.name}');

      // 연결 성공 시 DeviceServicesScreen으로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeviceServicesScreen(device: r.device),
        ),
      );
    } catch (e) {
      print('Error connecting to device: $e');
    }
  }

  // 리스트 항목
  Widget listItem(ScanResult r) {
    return ListTile(
      onTap: () => onTap(r),
      leading: leading(r),
      title: deviceName(r),
      subtitle: deviceMacAddress(r),
      trailing: deviceSignal(r),
    );
  }

  // UI 구성
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isScanning,
      builder: (context, scanning, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: ListView.separated(
              itemCount: scanResultList.length,
              itemBuilder: (context, index) {
                return listItem(scanResultList[index]);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: scanning ? stopScan : scan,
            child: Icon(scanning ? Icons.stop : Icons.search),
          ),
        );
      },
    );
  }
}
