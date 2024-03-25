import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:the_tribe_ug/Feed/feed_loading.dart';
import 'package:the_tribe_ug/Feed/loading.dart';
import 'package:http/http.dart' as http;
import '../article.dart';
import 'ad_image_slider.dart';
import 'articles_model.dart';

class feed extends StatefulWidget {
  const feed({Key? key}) : super(key: key);

  @override
  State<feed> createState() => _feedState();
}

class _feedState extends State<feed> {
  List<Post> posts = [];
  bool isLoading = true;
  bool _showFloatingButton = false;
  final ScrollController _scrollController = ScrollController();

  @override
  initState() {
    super.initState();
    fetchData();

    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    // When the user scrolls up, show the floating button
    if (_scrollController.offset > 2000.0) {
      setState(() {
        _showFloatingButton = true;
      });
    } else {
      setState(() {
        _showFloatingButton = false;
      });
    }
  }

  Future<void> fetchData() async {
    // Open the Hive box
    final box = await Hive.openBox<Article>('articles');

    if (box.isEmpty) {
      print("Box Empty");
      // If Hive is empty, make a network call
      final response = await http.get(Uri.parse(
          'https://www.thetribe.africa/wp-json/wp/v2/posts?per_page=100'));

      if (response.statusCode == 200) {
        // print(response.body.length);
        final List<dynamic> jsonData = json.decode(response.body);
        final List<Post> fetchedPosts = jsonData.map((data) {
          final List<dynamic> ogImageList = data['yoast_head_json']['og_image'];
          final String imageUrl =
          ogImageList.isNotEmpty ? ogImageList[0]['url'] : '';

          return Post(
            id: data['id'],
            date: data['date'],
            title: data['yoast_head_json']['title'],
            desc: data['excerpt']['rendered'],
            content: data['content']['rendered'],
            link: data['link'],
            imageUrl: imageUrl, // Use og_url as the image URL
          );
        }).toList();

        setState(() {
          posts = fetchedPosts;
          isLoading = false; // Data has been fetched
        });

        // Save fetched articles to Hive
        final box = await Hive.openBox<Article>('articles');
        box.clear(); // Clear existing articles

        // Map the fetched Posts to Articles and add them to the box
        final Iterable<Article> articles = fetchedPosts.map((post) {
          return Article(
            id: post.id,
            date: post.date,
            title: post.title,
            desc: post.desc,
            content: post.content,
            link: post.link,
            imageUrl: post.imageUrl,
            // Map other fields accordingly
          );
        });

        box.addAll(articles);
      } else {
        // Handle errors
        print("Error fetching data");
      }
    } else {
      print("Box Not Empty");
      // Hive is not empty, load articles from Hive
      final Iterable<Article> articles = box.values.cast<Article>();
      final List<Post> fetchedPosts = articles.map((article) {
        return Post(
          id: article.id, // Set your own ID
          date: article.date,
          title: article.title,
          desc: article.desc,
          content: article.content,
          link: article.link,
          imageUrl: article.imageUrl, // Set image URL
        );
      }).toList();

      setState(() {
        posts = fetchedPosts;
        isLoading = false;
      });

      // Make a network call to check for new articles
      final response = await http.get(Uri.parse(
          'https://www.thetribe.africa/wp-json/wp/v2/posts?per_page=1')); // Fetch only the latest article

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final int latestArticleId = jsonData[0]['id'];

        print(latestArticleId);
        if (latestArticleId > articles.first.id) {
          // New articles found, update Hive
          await updateHiveWithNewArticles();
        }
      }
    }
  }

  Future<void> updateHiveWithNewArticles() async {
    // Example:
    final box = await Hive.openBox<Article>('articles');
    box.clear(); // Clear existing articles

    final response = await http.get(Uri.parse(
        'https://www.thetribe.africa/wp-json/wp/v2/posts?per_page=100'));

    if (response.statusCode == 200) {
      // print(response.body.length);
      final List<dynamic> jsonData = json.decode(response.body);
      final List<Post> fetchedPosts = jsonData.map((data) {
        final List<dynamic> ogImageList = data['yoast_head_json']['og_image'];
        final String imageUrl =
        ogImageList.isNotEmpty ? ogImageList[0]['url'] : '';

        return Post(
          id: data['id'],
          date: data['date'],
          title: data['yoast_head_json']['title'],
          desc: data['excerpt']['rendered'],
          content: data['content']['rendered'],
          link: data['link'],
          imageUrl: imageUrl, // Use og_url as the image URL
        );
      }).toList();

      setState(() {
        posts = fetchedPosts;
        isLoading = false; // Data has been fetched
      });

      // Save fetched articles to Hive
      final box = await Hive.openBox<Article>('articles');
      box.clear(); // Clear existing articles

      // Map the fetched Posts to Articles and add them to the box
      final Iterable<Article> articles = fetchedPosts.map((post) {
        return Article(
          id: post.id,
          date: post.date,
          title: post.title,
          desc: post.desc,
          content: post.content,
          link: post.link,
          imageUrl: post.imageUrl,
          // Map other fields accordingly
        );
      });

      box.addAll(articles);
    } else {
      // Handle errors
      print("Error fetching data");
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTime = DateTime.now();
    final currentTimeOfDay = currentTime.hour;

    String greeting = '';

    if (currentTimeOfDay < 12) {
      greeting = 'Good Morning!';
    } else if (currentTimeOfDay < 18) {
      greeting = 'Good Afternoon!';
    } else {
      greeting = 'Good Evening!';
    }

<<<<<<< HEAD
    void _scrollToTop() {
      _scrollController.animateTo(
        0.0,
        duration: Duration(seconds: 1),
        curve: Curves.easeOut,
      );
    }

    return Scaffold(
      floatingActionButton: _showFloatingButton
          ? FloatingActionButton(
        onPressed: () {
          _scrollToTop();
        },
        child: Icon(Icons.arrow_upward),
        backgroundColor: Colors.red, // Customize the button's appearance
      )
          : null,
      body: isLoading
          ? Loading(child: const HomeLoading()) // Display a loading indicator
          : SingleChildScrollView(
        controller: _scrollController,
        // Wrap the entire content in SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            // Greeting
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                greeting,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: "BebasNeue"),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            // Horizontal ScrollView for Posts
            const SizedBox(
              height: 200,
              child: SlideshowPage(),
            ),
            const SizedBox(
              height: 5,
            ),
            // "Articles" Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'ARTICLES',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: "BebasNeue",
=======
    return isLoading
        ? const Loading(child: HomeLoading()) // Display a loading indicator
        : SingleChildScrollView(
            // Wrap the entire content in SingleChildScrollView
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                // Greeting
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    greeting,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: "BebasNeue"),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                // Horizontal ScrollView for Posts
                const SizedBox(
                  height: 200,
                  child: SlideshowPage(),
                ),
                const SizedBox(
                  height: 5,
                ),
                // "Articles" Title
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'ARTICLES',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: "BebasNeue",
                    ),
                  ),
>>>>>>> 9b9f85786ffedee49907500f8b66879da595b2ac
                ),
              ),
            ),

            // ListView.builder for Articles
            ListView.builder(
              physics:
              const NeverScrollableScrollPhysics(), // Disable scrolling
              shrinkWrap:
              true, // Important: Use shrinkWrap to enable scrolling within a ListView
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                // Build and return the widgets for each article
                return GestureDetector(
                  onTap: () {
                    // Navigate to a new widget to display full post details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailsScreen(post: post),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      elevation: 4,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 300,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(post.imageUrl),
                                    fit: BoxFit.cover,
                                  ),
<<<<<<< HEAD
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(10.0),
=======
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 200),
                                            height: 5,
                                            color: Colors.red,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            removeHtmlFormatting(post.title),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: "BebasNeue",
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
>>>>>>> 9b9f85786ffedee49907500f8b66879da595b2ac
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            right: 200),
                                        height: 5,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        removeHtmlFormatting(post.title),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: "BebasNeue",
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            child: Text(
                              removeHtmlFormatting(post.desc),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                fontFamily: "Quicksand",
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

String removeHtmlFormatting(String htmlContent) {
  String amp = htmlContent.replaceAll(RegExp(r'&amp;'), '&');
  String fo1 = amp.replaceAll(RegExp(r'&#8220;'), '"');
  String fo2 = fo1.replaceAll(RegExp(r'&#8221;'), '"');
  String fo3 = fo2.replaceAll(RegExp(r'&#8211;'), '–');
  String fo4 = fo3.replaceAll(RegExp(r'&#8217;'), '’');
  String fo5 = fo4.replaceAll(RegExp(r'&#8216;'), '`');
  String fo6 = fo5.replaceAll(RegExp(r'&#038;'), '&');
  String format = fo6.replaceAll(RegExp(r'&#8217;'), "'");
  String result = format.replaceAll(RegExp(r' \[&hellip;\]'), '...');
  return result.replaceAll(RegExp(r'<[^>]*>'), '');
}

String formatWordPressDate(String wordpressDate) {
  final inputFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');
  final outputFormat = DateFormat('EEEE, d MMMM y');

  final dateTime = inputFormat.parse(wordpressDate);
  final formattedDate = outputFormat.format(dateTime);

  return formattedDate;
}

class PostDetailsScreen extends StatefulWidget {
  final Post post;

  const PostDetailsScreen({super.key, required this.post});

  @override
  _PostDetailsScreenState createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  bool isSpeaking = false; // Add the isSpeaking state here

  final FlutterTts flutterTts = FlutterTts();

  Future<void> readArticleContent(String content) async {
    await flutterTts.setLanguage('en-UK');
    await flutterTts.setPitch(5.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.red,
        actions: [
          GestureDetector(
            onTap: () {
              if (isSpeaking) {
                flutterTts.stop();
              } else {
                readArticleContent(removeHtmlFormatting(widget.post.content));
              }
              setState(() {
                isSpeaking = !isSpeaking;
              });
            },
            child: Icon(
              isSpeaking ? Icons.headset_off : Icons.headphones_sharp,
              size: 26,
              color: Colors.red,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          GestureDetector(
            onTap: () {
              String shareLink = widget.post.link;
              Share.share('Check out this amazing article: $shareLink');
            },
            child:
            const Icon(Icons.share_outlined, size: 26, color: Colors.red),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              width: 400,
              child: Image.network(
                widget.post.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20.0),
              color: Colors.black,
              child: Text(
                removeHtmlFormatting(widget.post.title),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontFamily: "BebasNeue",
                ),
              ),
            ),
            const SizedBox(height: 25.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                formatWordPressDate(widget.post.date),
                style: const TextStyle(
                  fontFamily: "Quicksand",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                removeHtmlFormatting(widget.post.content),
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: "Quicksand",
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
