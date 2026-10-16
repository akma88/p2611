import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Local file read/write Demo",
      home: ReadWriteFileExample(),
    );
  }
}

class ReadWriteFileExample extends StatefulWidget {
  const ReadWriteFileExample({super.key});

  @override
  State<ReadWriteFileExample> createState() => _ReadWriteFileExampleState();
}

class _ReadWriteFileExampleState extends State<ReadWriteFileExample> {
  final TextEditingController _textController = TextEditingController();

  static const String kLocalFileName = "demo_localfile.txt";
  String _localFileContent = "";
  String _localFilePath = kLocalFileName;

  @override
  void initState() {
    super.initState();
    this._readTextFromLocalFile();
    this._getLocalFile.then(
      (file) => setState(() => this._localFilePath = file.path),
    );
  }

  @override
  Widget build(BuildContext context) {
    FocusNode textFieldFocusNode = FocusNode();
    return Scaffold(
      appBar: AppBar(
        title: Text("Local file read/write demo"),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Text("Write local file", style: TextStyle(fontSize: 20)),

          TextField(
            focusNode: textFieldFocusNode,
            controller: _textController,
            maxLines: null,
            style: TextStyle(fontSize: 20),
          ),

          OverflowBar(
            children: [
              MaterialButton(
                child: Text("Load", style: TextStyle(fontSize: 20)),
                onPressed: () async {
                  this._readTextFromLocalFile();
                  this._textController.text = this._localFileContent;
                  FocusScope.of(context).requestFocus(textFieldFocusNode);
                  log("String successfuly loaded from local file");
                },
              ),

              MaterialButton(
                child: Text("Save", style: TextStyle(fontSize: 20)),
                onPressed: () async {
                  await _writeTextToLocalFile(this._textController.text);
                  this._textController.clear();
                  await this._readTextFromLocalFile();
                  log("String successfuly loaded from local file");
                },
              ),
            ],
          ),

          Divider(height: 20),
          Text(
            "Local file path:",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            this._localFilePath,
            style: Theme.of(context).textTheme.titleMedium,
          ),

          Divider(height: 20),
          Text(
            "Local file content:",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            this._localFileContent,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Future<String> get _getLocalPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _getLocalFile async {
    final path = await _getLocalPath;
    return File("$path/$kLocalFileName");
  }

  Future<File> _writeTextToLocalFile(String text) async {
    final file = await _getLocalFile;
    return file.writeAsString(text);
  }

  Future _readTextFromLocalFile() async {
    String content;
    try {
      final file = await _getLocalFile;
      content = await file.readAsString();
    } catch (e) {
      content = 'Error loading local file: $e';
    }
    setState(() {
      this._localFileContent = content;
    });
  }
}
