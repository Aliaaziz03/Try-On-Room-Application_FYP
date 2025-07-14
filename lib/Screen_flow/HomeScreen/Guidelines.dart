import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Guidelines extends StatelessWidget {
  final List<GuidelineFeature> features = [
    GuidelineFeature(
      title: "3D Avatar View",
      description:
          "Create your personalized 3D avatar based on your body measurements. Update your profile with your body measurements to unlock your virtual self!",
      imagePath: "assets/HomeAvatar.png",
    ),
    GuidelineFeature(
      title: "Wardrobe",
      description:
          "Browse a collection of stylish 3D outfits. Rotate, zoom, and view every detail to find your perfect match!",
      imagePath: "assets/HomeWardrobe.png",
    ),
    GuidelineFeature(
      title: "Find Your Outfit",
      description:
          "Dress your 3D avatar in selected 3D outfits and size, preview in Augmented Reality (AR), and share your style with friends and family!",
      imagePath: "assets/HomeMatch.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Guidelines", 
        style:
        GoogleFonts.patrickHand(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          )),
        backgroundColor: Colors.pink.withOpacity(0.1),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              for (var feature in features) ...[
                FeatureCard(feature: feature),
                SizedBox(height: 30),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final GuidelineFeature feature;

  const FeatureCard({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(feature.imagePath, height: 200),
        SizedBox(height: 20),
        Text(
          feature.title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.pink,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          feature.description,
          style: TextStyle(fontSize: 15, color: Colors.grey[700]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class GuidelineFeature {
  final String title;
  final String description;
  final String imagePath;

  GuidelineFeature({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}
