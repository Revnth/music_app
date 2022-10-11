import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:just_audio/just_audio.dart';

// For debugging
import 'dart:developer';

void main() => runApp(const MyApp());
  // WebSocketChannel? channel;                    //initialize a websocket channel
  // bool isWebsocketRunning = false;
  // final channel = IOWebSocketChannel.connect('ws://127.0.0.1:8000/ws/music/');
  // channel.stream.listen((message) {
  //   channel.sink.add('received!');
  //   channel.sink.close(status.goingAway);
  // });
//   if (isWebsocketRunning) return;            //check if socket running
//   var url = 'ws://10.0.2.2:8000/ws/music/';
//   channel = WebSocketChannel.connect(
//     Uri.parse(url),                           //connect to a websocket
//   );
//   channel.stream.listen(
//           (event) {
//         print(json.decode(event));
//       },
//       onDone: () {
//         isWebsocketRunning = false;
//       },
//       onError: (error) {
//         debugPrint('ws error $error');
//       }
//
//   );
// }


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'WebSocket Demo';
    return const MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late AudioPlayer player;
  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
  }

  // final TextEditingController _controller = TextEditingController();
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://10.0.2.2:8000/ws/music/'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                log('channel data: ${snapshot.data}');
                return Text(snapshot.hasData ? '${snapshot.data}' : 'error');
              },
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () async {
                await player.setAsset('assets/oom.wav');
                player.play();
              },
              child: Text('Play'),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                //await player.setAsset('assets/oom.mp3');
                player.pause();
              },
              child: Text('Pause'),
            ),
          ],
        ),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void dispose() {
    _channel.sink.close();

    player.dispose();
    super.dispose();
  }
}
