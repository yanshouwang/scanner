import 'package:flutter/material.dart';

class ShowView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final text = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('扫描结果'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(text),
      ),
    );
  }
}
