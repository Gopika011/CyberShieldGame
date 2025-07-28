import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:claude/components/custom_app_bar.dart';
import 'package:claude/pages/land.dart';

class VideoIntroPage extends StatefulWidget {
  @override
  _VideoIntroPageState createState() => _VideoIntroPageState();
}

class _VideoIntroPageState extends State<VideoIntroPage> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;
  bool _showSkipButton = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    
    // Show skip button after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showSkipButton = true;
        });
      }
    });
  }

  void _initializeVideo() async {
    // Replace 'assets/videos/intro.mp4' with your video asset path
    // For network video, use: VideoPlayerController.network('your_video_url')
    _controller = VideoPlayerController.asset('assets/videos/intro.mp4');
    
    try {
      await _controller.initialize();
      setState(() {
        _isVideoInitialized = true;
      });
      
      // Add listener to navigate when video completes
      _controller.addListener(() {
        if (_controller.value.position >= _controller.value.duration) {
          _navigateToChapters();
        }
      });
      
      // Start playing the video
      _controller.play();
    } catch (e) {
      print('Error initializing video: $e');
      // If video fails to load, skip to chapters
      _navigateToChapters();
    }
  }

  void _navigateToChapters() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/chapters');
    }
  }

  void _skipVideo() {
    _controller.pause();
    _navigateToChapters();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1520),
      appBar: CustomAppBar(
        title: 'CyberShield',
        showBackButton: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(202, 10, 21, 32),
                  Color.fromARGB(206, 15, 27, 46),
                  Color.fromARGB(158, 26, 35, 50),
                ],
              ),
            ),
          ),
          
          // Cyber grid background
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(
                gridColor: const Color(0x1A00D4FF),
                cellSize: 25,
              ),
            ),
          ),
          
          // Video content
          Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: _isVideoInitialized
                  ? Container(

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF00D4FF).withOpacity(0.5),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00D4FF).withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Loading animation
                          Container(
                            width: 60,
                            height: 60,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF00D4FF),
                              ),
                              strokeWidth: 3,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Loading Introduction...',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFFB8C6DB),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          
          // Skip button (appears after 3 seconds)
          if (_showSkipButton)
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF00D4FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF00D4FF)),
                ),
                child: TextButton(
                  onPressed: _skipVideo,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Skip',
                        style: TextStyle(
                          color: const Color(0xFF00D4FF),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.skip_next,
                        color: const Color(0xFF00D4FF),
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          
          // Video controls overlay (optional)
          if (_isVideoInitialized)
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    // Play/Pause button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_controller.value.isPlaying) {
                            _controller.pause();
                          } else {
                            _controller.play();
                          }
                        });
                      },
                      child: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: const Color(0xFF00D4FF),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 8),
                    
                    // Progress bar
                    Expanded(
                      child: VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                        colors: VideoProgressColors(
                          playedColor: const Color(0xFF00D4FF),
                          bufferedColor: const Color(0xFF00D4FF).withOpacity(0.3),
                          backgroundColor: Colors.grey.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}