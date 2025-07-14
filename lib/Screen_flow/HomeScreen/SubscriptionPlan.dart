import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Subscriptionplan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pink.withOpacity(0.1),
        title: Text('Subscription Plan',
        style: 
        GoogleFonts.patrickHand(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          )),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User info
            SizedBox(height: 30),
            Text(
              'CHOOSE YOUR PLAN',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),

            // Basic Plan
            PlanCard(
              title: 'Basic',
              price: '\$0',
              features: ['Generate 3D avatar', 'Access to 3D clothes viewer'],
              color1: Colors.cyan,
              color2: Colors.teal,
              icon: Icons.checkroom,
            ),

            // Premium Plan
            PlanCard(
              title: 'Premium',
              price: '\$49',
              features: ['Try on 3D clothes on 3D avatar', ' Augmented Reality feature', 'Share the experiences with family and friends'],
              color1: Colors.amber,
              color2: Colors.orangeAccent,
              icon: Icons.star_rate_rounded,
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final List<String> features;
  final Color color1;
  final Color color2;
  final IconData icon;

  PlanCard({
    required this.title,
    required this.price,
    required this.features,
    required this.color1,
    required this.color2,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color1, color2]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 36, color: Colors.white),
          SizedBox(height: 8),
          Text(
            '$price /Year',
            style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          ...features.map((f) => Row(
                children: [
                  Icon(Icons.check_circle, size: 16, color: Colors.white),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      f,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {
                // Handle plan selection
              },
              child: Text('Choose Plan', style: TextStyle(color: Colors.white)),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
