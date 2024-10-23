import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceServicesScreen extends StatefulWidget {
  final BluetoothDevice device;

  const DeviceServicesScreen({super.key, required this.device});

  @override
  _DeviceServicesScreenState createState() => _DeviceServicesScreenState();
}

class _DeviceServicesScreenState extends State<DeviceServicesScreen> {
  List<BluetoothService> services = [];

  @override
  void initState() {
    super.initState();
    discoverServices();
  }

  // GATT 서비스를 발견하는 함수
  Future<void> discoverServices() async {
    try {
      print('Discovering services for ${widget.device.name}');
      services = await widget.device.discoverServices();
      setState(() {});
      print('Services discovered: ${services.length}');
    } catch (e) {
      print('Error discovering services: $e');
    }
  }

  // 생체 데이터를 가져오는 함수
  Future<void> fetchBiometricData(BluetoothCharacteristic characteristic) async {
    try {
      // 특성 값을 읽기
      var value = await characteristic.read();
      print('Data from ${characteristic.uuid}: $value');

      // 값이 필요한 경우 실시간 알림 활성화
      await characteristic.setNotifyValue(true);
      characteristic.value.listen((value) {
        print('Real-time data from ${characteristic.uuid}: $value');
      });
    } catch (e) {
      print('Error reading characteristic: $e');
    }
  }

  // 서비스 UUID와 특성 UUID를 필터링하여 데이터를 가져옴
  Widget serviceItem(BluetoothService service) {
    return ExpansionTile(
      title: Text('Service UUID: ${service.uuid.toString()}'),
      children: service.characteristics.map((c) {
        return ListTile(
          title: Text('Characteristic UUID: ${c.uuid.toString()}'), // 전체 UUID 표시
          trailing: ElevatedButton(
            onPressed: () {
              // 전체 UUID를 비교하여 데이터를 가져오기
              if (c.uuid.toString() == '00002a37-0000-1000-8000-00805f9b34fb') {
                // 심박수 특성 UUID (Heart Rate Measurement)
                print('Fetching Heart Rate data...');
                fetchBiometricData(c);
              } else if (c.uuid.toString() == '00002a5f-0000-1000-8000-00805f9b34fb') {
                // 혈중 산소 특성 UUID (Pulse Oximeter Measurement)
                print('Fetching Oxygen Saturation data...');
                fetchBiometricData(c);
              } else {
                print('Other characteristic');
              }
            },
            child: const Text('Fetch Data'),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name.isEmpty ? 'Unknown Device' : widget.device.name),
      ),
      body: services.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          return serviceItem(services[index]);
        },
      ),
    );
  }
}
