import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeVideoWidget extends StatelessWidget {
  final String videoUrl;
  final String videoTitle;
  final String videoDescription;

  const YouTubeVideoWidget({super.key, 
    required this.videoUrl,
    required this.videoTitle,
    required this.videoDescription,
  });

  String extractVideoId(String url) {
    final uri = Uri.parse(url);
    return uri.queryParameters['v'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final videoId = extractVideoId(videoUrl);

    final YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        forceHD: true,
        autoPlay: false,
        mute: false,
      ),
    );


    return WillPopScope(
        onWillPop: () async {
          // Reset the preferred orientations when navigating back
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
          return true;
        },
        child: Scaffold(
          appBar: MediaQuery.of(context).orientation == Orientation.portrait
              ? AppBar(
                  foregroundColor: Colors.red,
                  actions: [
                    GestureDetector(
                      onTap: () {
                        String shareLink = videoUrl;
                        Share.share('Check out this amazing video: $shareLink');
                      },
                      child: const Icon(Icons.share_outlined,
                          size: 26, color: Colors.red),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                  ],
                )
              : null, //
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                YoutubePlayer(
                  controller: controller,
                  showVideoProgressIndicator: true,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(20.0),
                  color: Colors.black,
                  child: Text(
                    videoTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: "BebasNeue",
                    ),
                  ),
                ),
                const SizedBox(height: 25.0),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    videoDescription,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: "Quicksand",
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
