import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({Key? key}) : super(key: key);

  @override
  State<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? scanResult;
  bool isProcessing = false;
  bool _cameraGranted = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() {
        _cameraGranted = true;
        _loading = false;
      });
    } else {
      setState(() {
        _cameraGranted = false;
        _loading = false;
      });
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (mounted && controller != null) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (isProcessing) return;
      setState(() => isProcessing = true);
      setState(() => scanResult = scanData.code);

      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('نتيجة المسح'),
          content: Text(scanData.code ?? 'لم يتم العثور على بيانات'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() => isProcessing = false);
              },
              child: const Text('حسناً'),
            ),
          ],
        ),
      );

      setState(() => isProcessing = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_cameraGranted) {
      return Scaffold(
        appBar: AppBar(title: const Text('مسح رمز QR'), centerTitle: true),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.camera_alt, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'الكاميرا غير مفعلة!',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _requestCameraPermission,
                icon: const Icon(Icons.refresh),
                label: const Text('إعادة طلب الصلاحية'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade100,
                  foregroundColor: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // الكاميرا مفعلة - اعرض QRView مباشرة
    return Scaffold(
      appBar: AppBar(title: const Text('مسح رمز QR'), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Theme.of(context).primaryColor,
                borderRadius: 16,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.7,
              ),
            ),
          ),
          if (scanResult != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'النتيجة: $scanResult',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              controller?.resumeCamera();
              setState(() {
                scanResult = null;
                isProcessing = false;
              });
            },
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المسح'),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
