import 'package:agora_uikit/agora_uikit.dart';
import 'package:agora_zikrabyte/pages/home.dart';
import 'package:agora_zikrabyte/utils/settings.dart';
import 'package:flutter/material.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'dart:async';
// import 'package:agora_zikrabyte/utils/settings.dart';

class CallsPage extends StatefulWidget {
  const CallsPage({super.key, required this.channelName});

  final String channelName;
  // final ClientRoleType role;

  @override
  State<CallsPage> createState() => _CallsPageState();
}

class _CallsPageState extends State<CallsPage> {
  // final _users = <int>[];
  // final _infoStrings = <String>[];
  // bool muted = false;
  // bool viewPanel = false;
  // bool _localUserJoined = false;
  // late RtcEngine _engine;
  // int? _remoteUid;

  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: appId,
      channelName: "zikrabyte_test",
      username: "user",
      tempToken: token
    ),
  );

  @override
  void initState() {
    initilize();
    super.initState();
  }
  Future<void>initilize()async{
    await client.initialize();
  }

  // @override
  // void dispose() {
  //   _users.clear();
  //   _engine.leaveChannel();
  //   _engine.release();
  //   super.dispose();
  // }

  // Future<void> initilize() async {
  //   print('initiaslize => -----------------------------------');
  //   if (appId.isEmpty) {
  //     setState(() {
  //       _infoStrings.add('APP_ID is missing please provide app id');
  //       _infoStrings.add('Agora engine not started');
  //     });
  //     return;
  //   }
  //   _engine = createAgoraRtcEngine();
  //   await _engine.initialize(const RtcEngineContext(
  //     appId: appId,
  //     channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
  //   ));

  //   _engine.registerEventHandler(
  //     RtcEngineEventHandler(
  //       onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
  //         debugPrint("local user ${connection.localUid} joined");
  //         setState(() {
  //           _localUserJoined = true;
  //           final info = 'local user ${connection.localUid} joined';
  //           _infoStrings.add(info);
  //         });
  //       },
  //       onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
  //         debugPrint("remote user $remoteUid joined");
  //         setState(() {
  //           _remoteUid = remoteUid;
  //           _infoStrings.add('remote user $remoteUid joined');
  //           _users.add(remoteUid);
  //         });
  //       },
  //       onUserOffline: (RtcConnection connection, int remoteUid,
  //           UserOfflineReasonType reason) {
  //         debugPrint("remote user $remoteUid left channel");
  //         setState(() {
  //           _remoteUid = null;
  //           _infoStrings.add('remote user $remoteUid left channel');
  //           _users.remove(remoteUid);
  //         });
  //       },
  //       onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
  //         debugPrint(
  //             '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
  //       },
  //     ),
  //   );

  //   await _engine.setClientRole(role: widget.role);
  //   // await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
  //   await _engine.enableVideo();
  //   await _engine.startPreview();

  //   await _engine.joinChannel(
  //     token: token,
  //     channelId: widget.channelName,
  //     uid: 0,
  //     options: const ChannelMediaOptions(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: null,
        title: const Text('Agora Call'),
        centerTitle: true,
      ),
      // body: Stack(
      //   children: [
      //     _remoteVideo(),
      //     Align(
      //       alignment: Alignment.topLeft,
      //       child: _localUserJoined
      //           ? AgoraVideoView(
      //               controller: VideoViewController(
      //                 rtcEngine: _engine,
      //                 canvas: const VideoCanvas(uid: 0),
      //               ),
      //             )
      //           : const Center(
      //               child: CircularProgressIndicator(),
      //             ),
      //     )
      //   ],
      // ),
      body: SafeArea(child: Stack(
            children: [
              AgoraVideoViewer(
                client: client,
                layoutType: Layout.floating,
                enableHostControls: true, // Add this to enable host controls
              ),
              AgoraVideoButtons(
                onDisconnect: (){
                  endCall();
                  Navigator.pop(context);
                },
                client: client,
                addScreenSharing: false, // Add this to enable screen sharing
              ),
            ],
          )),
    );
  }

  // Widget _remoteVideo() {
  //   if (_remoteUid != null) {
  //     return AgoraVideoView(
  //       controller: VideoViewController.remote(
  //         rtcEngine: _engine,
  //         canvas: VideoCanvas(uid: _remoteUid),
  //         connection: RtcConnection(channelId: widget.channelName),
  //       ),
  //     );
  //   } else {
  //     return const Text(
  //       'Please wait for remote user to join',
  //       textAlign: TextAlign.center,
  //     );
  //   }
  // }
}
