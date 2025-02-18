import 'package:audibrain/models/nmt_tts_pipeline_model.dart';
import 'package:audibrain/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter binding is initialized
  await dotenv.load(fileName: ".env"); // Load environment variables
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bhashini API Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NmtTtsModel? nmtTtsModel;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final data = await MyApiService.fetchNmtTtsData(
        sourceLanguage: 'en',
        targetLanguage: 'hi',
        inputText: 'Hello, how are you?',
      );
      setState(() {
        nmtTtsModel = data;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bhashini API Demo'),
      ),
      body: Center(
        child: nmtTtsModel == null
            ? CircularProgressIndicator()
            : Text(nmtTtsModel.toString()),
      ),
    );
  }
}
