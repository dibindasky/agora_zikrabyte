import 'dart:developer';

import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:agora_zikrabyte/pages/calls.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final _channelController = TextEditingController();
  bool _validateError = false;
  ClientRoleType? _role = ClientRoleType.clientRoleBroadcaster;

  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT0Jcsn38hqKgu7lDqVHOpQvN5quWh2LarJVw&usqp=CAU'),
              const SizedBox(
                height: 20,
              ),
              Material(
                shadowColor: Colors.greenAccent,
                elevation: 2,
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  child: ColoredBox(
                    color: const Color.fromARGB(255, 243, 243, 243),
                    child: TextField(controller: _channelController,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.abc_sharp),
                          hintText: 'Enter channel name',
                          border: InputBorder.none,
                          errorText:
                              _validateError ? 'Enter channel name' : null),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Choose role'),
              RadioListTile(
                  title: const Text('join a call'),
                  value: ClientRoleType.clientRoleAudience,
                  groupValue: _role,
                  onChanged: (ClientRoleType? newRole) {
                    setState(() {
                      _role = newRole;
                    });
                  }),
              RadioListTile(
                  title: const Text('start a call'),
                  value: ClientRoleType.clientRoleBroadcaster,
                  groupValue: _role,
                  onChanged: (ClientRoleType? newRole) {
                    setState(() {
                      _role = newRole;
                    });
                  }),
              ElevatedButton.icon(
                onPressed: onJoin,
                label: Text(_role == ClientRoleType.clientRoleBroadcaster
                    ? 'Start'
                    : 'Join'),
                icon: const Icon(
                  Icons.video_call_outlined,
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 40)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    setState(() {
      _validateError = _channelController.text.isEmpty ? true : false;
    });
    if (_channelController.text.isNotEmpty) {
      log('onJoin => called');
      await _handelCameraAndMic(Permission.camera);
      await _handelCameraAndMic(Permission.microphone);
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallsPage(
              channelName: _channelController.text,
              // role: _role!,
            ),
          ),
        );
      }
    }
  }

  Future<void> _handelCameraAndMic(Permission permission) async {
    final status = await permission.request();
    log('permission status => $status');
  }
}
