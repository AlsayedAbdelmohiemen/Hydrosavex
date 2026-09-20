import 'package:flutter/material.dart';
import 'package:hydrosavex/l10n/app_localizations.dart';
import 'package:hydrosavex/utils/constants/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/helpers/helper_functions.dart';

class DetailScreen extends StatefulWidget {
  final String title;
  final String videoUrl;
  final String instruction;

  const DetailScreen(
      {super.key,
      required this.title,
      required this.videoUrl,
      required this.instruction});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late YoutubePlayerController _controller;
  bool isFavorite = false;
  bool isExpanded = false;
  bool feedbackGiven = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = prefs.getBool(widget.title) ?? false;
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = !isFavorite;
    });
    await prefs.setBool(widget.title, isFavorite);
  }

  void _shareContent() {
    final shareText =
        "${widget.title}\n\nInstructions: ${widget.instruction}\n\nWatch the video: ${widget.videoUrl}";
    // Add your sharing logic here (e.g., use the 'share' package)
    print(shareText); // You would replace this with actual sharing logic.
  }

  void _giveFeedback(bool helpful) {
    setState(() {
      feedbackGiven = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(helpful
            ? 'Thanks for your feedback!'
            : 'We will work on improving this.'),
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
    final dark = SHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Color(0xFF1980B8),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Transform.scale(
            scale: 0.6,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(0xFF1980B8),
                  width: 1.8,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF1980B8),
                  size: 18,
                ),
              ),
            ),
          ),
        ),
        actions: [
          // IconButton(
          //   icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
          //   onPressed: _toggleFavorite,
          //   tooltip: isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
          // ),
          // IconButton(
          //   icon: Icon(Icons.share),
          //   onPressed: _shareContent,
          //   tooltip: 'Share Instructions',
          // ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video Player Section
              Card(
                elevation: 5,
                color: dark ? SColors.black : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.amber,
                    onReady: () {
                      print('Player is ready.');
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Instruction Header
              Text(
                AppLocalizations.of(context)!.instructions,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1980B8),
                ),
              ),
              SizedBox(height: 10),

              // Instruction Content
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedCrossFade(
                        firstChild: Text(
                          widget.instruction,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            color: dark ? SColors.white : Colors.black,
                          ),
                        ),
                        secondChild: Text(
                          widget.instruction,
                          style: TextStyle(
                            fontSize: 16,
                            color: dark ? SColors.white : Colors.black,
                          ),
                        ),
                        crossFadeState: isExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: Duration(milliseconds: 300),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Text(
                          isExpanded
                              ? AppLocalizations.of(context)!.show_less
                              : AppLocalizations.of(context)!.read_more,
                          style: TextStyle(
                              color: Color(0xFF1980B8),
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Feedback Section
            ],
          ),
        ),
      ),
    );
  }
}
