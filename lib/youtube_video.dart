import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideo extends StatefulWidget {
  YoutubeVideo({Key? key}) : super(key: key);

  @override
  _YoutubeVideoState createState() => _YoutubeVideoState();
}

class _YoutubeVideoState extends State<YoutubeVideo> {
  static String videoID = 'O8acFdnSnSo';
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: videoID,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube Video'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Text(
              '【K-ON!】My Love is a Stapler',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.amber,
            onReady: () {
              _controller.addListener(() {
                // Add any additional listener logic here
              });
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Text(
                  '''
Lyrics :

Nande nan daro
Ki ni naru yoru kimi e no
Kono omoi bin sen ni ne
Kaite miru yo

Moshikashite
Kimagure ka mo shirenai
Sore na no ni maisuu dake
Fuete yuku yo

Suki no kakuritsu waridasu keisan shiki
Areba ii noni

Kirakira hikaru negai goto mo
Guchagucha hetaru nayami goto mo
Souda hocchikisu de tojichaou
Hajimari dake wa karui nori de
Shiranai uchi ni atsuku natte
Mou hari ga nandaka tooranai
Rara * mata ashita

Doushiyou ka na
Yomikaesu no hazukashii
Are kore to bin sen ni ne
Kaita kuseni

Kimochi goto
Gomi bako yuki ja nandaka
Kono mune ga setsunai kara
Motte you ka na

Ima no kimochi wo arawasu
Jisho ni mo nai kotoba sagasu yo

Wakuwaku shichau keikaku to ka
Gudaguda sugiru tenkai to ka
Zenbu hocchikisu de tojichaou
Kyou no dekigoto omoidashite
Itsumo kokoro ga kyun to natte
Mou hari ga nai kara kawanakucha
Rara * mata ashita

Kirakira hikaru negaigoto mo
Guchagucha hetaru nayamigoto mo
Souda hocchikisu de tojichaou
Hajimari dake wa karui nori de
Shiranai uchi ni atsuku natte
Mou hari ga nandaka tooranai
Rara * mata ashita
                  ''',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
