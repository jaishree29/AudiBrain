import 'dart:async';

import 'package:audibrain/utils/colors.dart';
import 'package:audibrain/utils/image_strings.dart';
import 'package:audibrain/views/home/app_drawer.dart';
import 'package:audibrain/views/notifications/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

class PwdHomepage extends StatefulWidget {
  const PwdHomepage({super.key});

  @override
  State<PwdHomepage> createState() => _PwdHomepageState();
}

class _PwdHomepageState extends State<PwdHomepage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  bool _isDrawerOpen = false;
  final _flutterBlueClassicPlugin = FlutterBlueClassic();

  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  StreamSubscription? _adapterStateSubscription;

  final Set<BluetoothDevice> _scanResults = {};
  StreamSubscription? _scanSubscription;

  bool _isScanning = false;
  int? _connectingToIndex;
  StreamSubscription? _scanningStateSubscription;

  // // List of supported languages
  // final List<String> _languages = ['English', 'Spanish', 'French', 'German'];
  // String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _initBluetooth();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<Offset>(
      begin: const Offset(0.0, -0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();
  }

  Future<void> _initBluetooth() async {
    await _requestPermissions();
    await _checkBluetoothState();

    try {
      _adapterState = await _flutterBlueClassicPlugin.adapterStateNow;
      _adapterStateSubscription =
          _flutterBlueClassicPlugin.adapterState.listen((current) {
        if (mounted) setState(() => _adapterState = current);
      });
      _scanSubscription =
          _flutterBlueClassicPlugin.scanResults.listen((device) {
        if (mounted) setState(() => _scanResults.add(device));
      });
      _scanningStateSubscription =
          _flutterBlueClassicPlugin.isScanning.listen((isScanning) {
        if (mounted) setState(() => _isScanning = isScanning);
      });
    } catch (e) {
      print("Bluetooth initialization error: $e");
    }
  }

  Future<void> _checkBluetoothState() async {
    BluetoothAdapterState adapterState =
        await _flutterBlueClassicPlugin.adapterStateNow;

    if (adapterState != BluetoothAdapterState.on) {
      _flutterBlueClassicPlugin.turnOn();
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  @override
  void dispose() {
    _adapterStateSubscription?.cancel();
    _scanSubscription?.cancel();
    _scanningStateSubscription?.cancel();
    _controller.dispose();
    _adapterState;
    super.dispose();
  }

  void _toggleDrawer() {
    if (_isDrawerOpen) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  // // Function to handle language change
  // void _onLanguageChanged(String? newValue) {
  //   if (newValue != null) {
  //     setState(() {
  //       _selectedLanguage = newValue;
  //     });
  //     // Here you would typically call a function to update the app's language
  //     // For example: updateAppLanguage(newValue);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    List<BluetoothDevice> scanResults = _scanResults.toList();
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        leading: InkWell(
          splashColor: Colors.transparent,
          onTap: _toggleDrawer,
          child: const Padding(
            padding: EdgeInsets.only(left: 12.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://img.freepik.com/free-vector/cute-cool-boy-dabbing-pose-cartoon-vector-icon-illustration-people-fashion-icon-concept-isolated_138676-5680.jpg?t=st=1733131305~exp=1733134905~hmac=a1b05ebdf1385da653bf6ec4e40b0bf395afbc7af28f13c8c9a70a47d7074292&w=740',
              ),
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.welcomeBack,
                  style: TextStyle(
                    fontFamily: 'Canva Sans',
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.howAreYouToday,
                  style: const TextStyle(
                    fontFamily: 'Canva Sans',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AColors.primary,
                  ),
                ),
              ],
            ),
            InkWell(
              splashColor: AColors.primary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(50),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsPage(),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.notifications_active_rounded,
                    size: 25,
                    color: AColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Image.asset(
                  AImages.wave,
                  width: 300,
                  height: 200,
                ),
                // Image.network(
                //   'https://cdn.intuji.com/2023/10/Alterego-image-breakdown-1024x338.jpg',
                // ),

                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.welcomeToAudiBrain,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Canva Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: AColors.primary,
                    ),
                  ),
                ),
                // const SizedBox(
                //   height: 20,
                // ),
                // Center(
                //   child: Text(
                //     AppLocalizations.of(context)!.selectLanguage,
                //     textAlign: TextAlign.center,
                //     style: TextStyle(
                //       fontFamily: 'Canva Sans',
                //       fontSize: 18,
                //     ),
                //   ),
                // ),
                // const SizedBox(
                //   height: 20,
                // ),

                // // Drop down menu to select language
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                //   child: DropdownButton<String>(
                //     value: _selectedLanguage,
                //     onChanged: _onLanguageChanged,
                //     items: _languages
                //         .map<DropdownMenuItem<String>>((String value) {
                //       return DropdownMenuItem<String>(
                //         value: value,
                //         child: Text(value),
                //       );
                //     }).toList(),
                //     isExpanded: true,
                //     hint: const Text(
                //       'Select Language',
                //       style: TextStyle(
                //         fontFamily: 'Canva Sans',
                //         fontSize: 18,
                //       ),
                //     ),
                //   ),
                // ),
                Text(
                  AppLocalizations.of(context)!.connectDevice,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Canva Sans',
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_isScanning) {
                      _flutterBlueClassicPlugin.stopScan();
                    } else {
                      _scanResults.clear();
                      _flutterBlueClassicPlugin.startScan();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    foregroundColor: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60.0, vertical: 10),
                    child: Text(
                      _isScanning
                          ? '${AppLocalizations.of(context)!.scanningDevice}...'
                          : AppLocalizations.of(context)!.scanDevice,
                      style: TextStyle(
                        fontFamily: 'Canva Sans',
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${AppLocalizations.of(context)!.availableDevices}:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Canva Sans',
                        color: AColors.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                _buildDeviceList(scanResults),
                const SizedBox(height: 30),
              ],
            ),
            Visibility(
              visible: _isDrawerOpen,
              child: SizedBox(
                height: screenHeight * 0.5,
                child: SlideTransition(
                  position: _animation,
                  child: const MyAppDrawer(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceList(List<BluetoothDevice> scanResults) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (scanResults.isEmpty)
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AColors.primary.withOpacity(0.1),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.27,
                    vertical: 20,
                  ),
                  child: Text(
                    "No devices found yet",
                    style: TextStyle(
                      fontFamily: 'Canva Sans',
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            )
          else
            for (var (index, result) in scanResults.indexed)
              Card(
                color: AColors.primary.withOpacity(0.1),
                elevation: 0,
                margin: const EdgeInsets.symmetric(vertical: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  title: Text(
                    "${result.name ?? "???"} (${result.address})",
                    style: TextStyle(
                      fontFamily: 'Canva Sans',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                      "Bondstate: ${result.bondState.name}, Device type: ${result.type.name}"),
                  trailing: index == _connectingToIndex
                      ? const CircularProgressIndicator()
                      : Text("${result.rssi} dBm"),
                  // onTap: () async {
                  //   setState(() => _connectingToIndex = index);
                  //   try {
                  //     final connection =
                  //         await _flutterBlueClassicPlugin.connect(
                  //       result.address,
                  //     );
                  //     if (connection!.isConnected) {
                  //       setState(() => _connectingToIndex = null);
                  //     }
                  //   } catch (e) {
                  //     setState(() => _connectingToIndex = null);
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       SnackBar(content: Text("Error connecting: $e")),
                  //     );
                  //   }
                  // },
                ),
              ),
        ],
      ),
    );
  }
}
