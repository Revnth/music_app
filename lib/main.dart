import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;

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

// class Music {
//   final int id;
//   final String name;
//   final String file;

//   Music({
//     required this.id,
//     required this.name,
//     required this.file,
//   });
// }

class _MyHomePageState extends State<MyHomePage> {
  late AudioPlayer player;
  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
  }

  // final TextEditingController _controller = TextEditingController();
  // final _channel = WebSocketChannel.connect(
  //   Uri.parse('ws://10.0.2.2:8000/ws/music/'),
  // );

  // Future<List<Music>> getRequest() async {
  //   //replace your restFull API here.
  //   // String link = "http://127.0.0.1:8000/api/send/";
  //   final response =
  //       await http.get(Uri.parse('http://10.0.2.2:8000/api/send/'));

  //   var responseData = json.decode(response.body);
  //   print(responseData);
  //   //Creating a list to store input data;
  //   List<Music> users = [];

  //   for (var singleUser in responseData) {
  //     Music user = Music(
  //         id: singleUser["id"],
  //         name: singleUser["title"],
  //         file: singleUser["body"]);

  //     //Adding user to the list.
  //     users.add(user);
  //     print(user);
  //   }
  //   return users;
  // }

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
            // StreamBuilder(
            //   stream: _channel.stream,
            //   builder: (context, snapshot) {
            //     log('channel data: ${snapshot.data}');
            //     return Text(snapshot.hasData ? '${snapshot.data}' : 'error');
            //   },
            // ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () async {
                await player.setUrl('http://10.0.2.2:8000/api/send/');
                player.play();
              },
              child: Text('Play'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () async {
                final response = await http
                    .get(Uri.parse('http://192.168.1.59:8000/api/send/'));

                var responseData = json.decode(response.body);
                print(responseData);
              },
              // onPressed: () {
              //   //await player.setAsset('assets/oom.mp3');
              //   player.pause();
              // },
              child: const Text('Pause'),
            ),
            // FutureBuilder(
            //   future: getRequest(),
            //   builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            //     if (snapshot.data == null) {
            //       return Container(
            //         child: Center(
            //           child: CircularProgressIndicator(),
            //         ),
            //       );
            //     } else {
            //       return ListView.builder(
            //         itemCount: snapshot.data.length,
            //         itemBuilder: (ctx, index) => ListTile(
            //           title: Text(snapshot.data[index].name),
            //           subtitle: Text(snapshot.data[index].file),
            //           contentPadding: EdgeInsets.only(bottom: 20.0),
            //         ),
            //       );
            //     }
            //   },
            // ),
          ],
        ),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void dispose() {
    // _channel.sink.close();

    player.dispose();
    super.dispose();
  }
}
