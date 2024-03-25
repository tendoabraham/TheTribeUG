import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../youtube_player.dart';

class SlideshowPage extends StatefulWidget {
  const SlideshowPage({Key? key}) : super(key: key);

  @override
  _SlideshowPageState createState() => _SlideshowPageState();
}

class _SlideshowPageState extends State<SlideshowPage> {
  int _currentIndex = 0;

  List<String> imagePaths = [
    'assets/images/pod3.png',
    'assets/images/myhustle.png',
    'assets/images/wake.png',
    'assets/images/pod2.png',
    'assets/images/pod1.png',
    // Add more image paths
  ];

  List<String> titles = [
    'The Tribe UG Podcast Ep 14, Sn.3 | Comedy and music from Wongsville to Natsville ft. Omara Daniel',
    'My Hustle 01, Sn 01 | Creative Business Ideation ft. Abaasa Rwemereza',
    'The Tribe UG: Press Play | Wake, Tucker HD, Mal X, Flex DPaper - Flex',
    'The Tribe UG Podcast Ep 09, Sn 03 | 20 Years Of Navio & "Betrayal"',
    'The Tribe UG Podcast Ep 12, Sn.3 | Spoken-word, Kampala Boy & the Munakyalo ft. Maritza',
  ];

  List<String> videoUrls = [
    'https://www.youtube.com/watch?v=VBrf3CUIBAI&t=3700s',
    'https://www.youtube.com/watch?v=AXuW_3kXsCE',
    'https://www.youtube.com/watch?v=H9DXxlUvGII',
    'https://www.youtube.com/watch?v=xjWcTyFAYDU&t=570s',
    'https://www.youtube.com/watch?v=kba6At0s9nY&t=318s',
  ];

  List<String> descriptions = [
    'On this electrifying episode of the Tribe Ug Podcast, we are joined by none other than the multi-talented Daniel Omara, a true titan in the world of entertainment. With a career spanning over a decade, Daniel has conquered the realms of stand-up comedy, writing, acting, events hosting, TV/radio presenting, and even serves as a creative director for TV shows.',
    'As entrepreneurs who have been in the creative space, we have come to realize that there has not been adequate information on how one can build a creative business sustainably. We have attended business incubator sessions, business master classes etc...',
    'About The Tribe UG: Press Play;\n Over the years, we have been a part of the industry, and we have noticed that only a few music videos are being released by the rap industry despite large number of songs',
    'Join us for an electrifying ride on Episode 9 of Season 3 of The Tribe UG Podcast! Hosts Damzy and TheCountMarkula are joined by none other than the legendary Navio, as he gears up for his monumental "20 Years of Navio" concert.',
    'Dive into the multifaceted world of Maritza, also known as Mama KLA, as she takes us on an extraordinary journey on Season 03, Episode 12 of Tribe UG podcast. From her humble beginnings as a Spoken Word Artist in Uganda to becoming a renowned Media Personality at the countrys top media houses, her story is one of evolution, transformation, and bold choices.',
  ];

  void _openVideoPlayer(String videoUrl, String description) {
    // You can navigate to a new page with the YouTube player widget here
    // For simplicity, let's just print the URL for now
    print("Opening video player for URL: $videoUrl");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: CarouselSlider(
          options: CarouselOptions(
            enlargeCenterPage: true,
            autoPlay: true, // Auto-sliding enabled
            autoPlayInterval: const Duration(seconds: 4), // Auto-slide interval
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: imagePaths.asMap().entries.map((entry) {
            final index = entry.key;
            final imagePath = entry.value;
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    // _openVideoPlayer(videoUrls[index], descriptions[index]);
                    // Navigate to a new widget to display full post details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            YouTubeVideoWidget(
                              videoUrl: videoUrls[index], // Replace with your YouTube URL
                              videoTitle: titles[index],
                              videoDescription: descriptions[index],
                            )
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8), // Add curved borders
                      border: Border.all(color: Colors.red, width: 2),
                      image: DecorationImage(
                        image: AssetImage(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
