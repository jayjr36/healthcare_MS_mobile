import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const APP_ID = '1ff91545cedb4f4c91ab2eb157fdd07e';
const SERVER_URL = 'http://192.168.0.103:8000/api/';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Video Call',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VideoStarter(),
    );
  }
}

class VideoStarter extends StatefulWidget {
  @override
  State<VideoStarter> createState() => _VideoStarterState();
}

class _VideoStarterState extends State<VideoStarter> {
  final TextEditingController _channelController = TextEditingController();
  String? token;
  @override
  void initState() {
    super.initState();

    loadpreferences();
  }

  loadpreferences() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
  }

  void _joinChannel(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id') ?? '';
    String channelName = _channelController.text.trim();

    // Call API to start a call session
    var response = await http.post(
      Uri.parse('$SERVER_URL/start-call'),
      body: {'user_id': '1', 'channel_name': channelName},
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token!,
      },
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoCallScreen(channelName: channelName),
        ),
      );
    } else {
      print(response.body);
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to start video call. Please try again later.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Video Call'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _channelController,
                decoration: InputDecoration(
                  labelText: 'Enter Channel Name',
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => _joinChannel(context),
                child: Text('Join Video Call'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoCallScreen extends StatefulWidget {
  final String channelName;

  VideoCallScreen({Key? key, required this.channelName}) : super(key: key);

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late RtcEngine _engine;
  late bool _joined = false;
  // late int _remoteUid = 0;
  int? _remoteUid;
  bool _localUserJoined = false;
  static const token = "<-- Insert Token -->";
  static const channel = "";

  @override
  void initState() {
    super.initState();
    initializeAgora();
  }

  Future<void> initializeAgora() async {
    _engine = createAgoraRtcEngine();
    // _engine = await RtcEngine.createWithConfig(RtcEngineConfig(APP_ID));
    _engine.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        debugPrint("local user ${connection.localUid} joined");
        setState(() {
          _localUserJoined = true;
        });
      },
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        debugPrint("remote user $remoteUid joined");
        setState(() {
          _remoteUid = remoteUid;
        });
      },
      onUserOffline: (RtcConnection connection, int remoteUid,
          UserOfflineReasonType reason) {
        debugPrint("remote user $remoteUid left channel");
        setState(() {
          _remoteUid = null;
        });
      },
      // onLeaveChannel: (stats) {
      //   setState(() {
      //     _joined = false;
      //     _remoteUid = 0;
      //   });
      // },
      onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
        debugPrint(
            '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
      },
    ));
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    // await _engine.joinChannel(null, widget.channelName, null, 0);
    await _engine.joinChannel(
      token: token,
      channelId: widget.channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  void _onCallEnd() async {
    await _engine.leaveChannel();
    // await _engine.destroy();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id') ?? '';
    var response = await http
        .post(Uri.parse('$SERVER_URL/end-call'), body: {'user_id': userId});
    if (response.statusCode == 200) {
      // Handle success
    } else {
      // Handle error
    }
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();

    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Call'),
      ),
      body: Center(
        child: Stack(
          children: [
            Center(
              child: _remoteVideo(),
            ),
            Align(
              child: SizedBox(
                child: Center(
                  child: _localUserJoined
                      ? AgoraVideoView(
                          controller: VideoViewController(
                            rtcEngine: _engine,
                            canvas: const VideoCanvas(uid: 0),
                          ),
                        )
                      : const CircularProgressIndicator(),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onCallEnd,
        child: Icon(Icons.call_end),
      ),
    );
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: channel),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}
