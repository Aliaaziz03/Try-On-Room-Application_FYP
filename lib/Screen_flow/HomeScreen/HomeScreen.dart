import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_apps/Screen_flow/AR_background/AvatarViewer.dart';
import 'package:fyp_apps/Screen_flow/AR_background/Match.dart';
import 'package:fyp_apps/Screen_flow/authentication/SignIn.dart';
import 'package:fyp_apps/Screen_flow/3Davatar/MatchAvatar.dart';
import 'package:fyp_apps/Screen_flow/3Davatar/input.dart';
import 'package:fyp_apps/Screen_flow/HomeScreen/Profile.dart';
import 'package:fyp_apps/Screen_flow/3Dcloth/wardrobe.dart';
import 'package:fyp_apps/Screen_flow/HomeScreen/Guidelines.dart';
import 'package:fyp_apps/Screen_flow/HomeScreen/SubscriptionPlan.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _username = '';
  int _selectedIndex = 1;
  int _focusedIndex = 0;
  String _selectedAvatar = 'assets/avatars/avatar1.png'; // default

  void _updateAvatar(String newAvatar) {
    setState(() {
      _selectedAvatar = newAvatar;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUsername();
    _fetchAvatar();
  }

  void _fetchUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data()?['name'] != null) {
        setState(() {
          _username = doc['name'];
        });
      }
    }
  }

  void _fetchAvatar() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data()?['avatar'] != null) {
        setState(() {
          _selectedAvatar = doc['avatar'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 1
          ? AppBar(
              backgroundColor: Colors.pink.withOpacity(0.1),
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Image.asset(
                    'assets/logo.png',
                    height: 40,
                    width: 40,
                  ),
                ),
              ],
            )
          : null,
drawer: Drawer(
  child: Column(
    children: [
      SizedBox(height: 50),
      GestureDetector(
        onTap: () {
          Navigator.pop(context); // Close the drawer
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage(currentAvatar: _selectedAvatar)),
          );
        },
        child: Center(
          child: CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(_selectedAvatar),
          ),
        ),
      ),
      SizedBox(height: 30),
      ListTile(
        leading: Icon(Icons.star_border),
        title: Text(
          'Subscription Plan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => Subscriptionplan()));
        },
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.book_outlined),
        title: Text(
          'Guideline',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => Guidelines()));
        },
      ),

      Divider(),
ListTile(
  leading: Icon(Icons.logout),
  title: Text(
    'Logout',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  ),
  onTap: () {
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Signin()),
    );
  },
),

    ],
  ),
),

      body: _buildPageContent(_selectedIndex),
    );
  }

  Widget _buildPageContent(int index) {
    final List<Map<String, String>> categories = [
      {'image': 'assets/HomeAvatar.png', 'label': '3D avatar'},
      {'image': 'assets/HomeWardrobe.png', 'label': 'Wardrobe'},
      {'image': 'assets/HomeMatch.png', 'label': 'Find your outfit'},
    ];

    return Stack(
      children: [
        Container(
          color: Colors.pink.withOpacity(0.1),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Hello,',
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data!.exists) {
                          final data = snapshot.data!.data() as Map<String, dynamic>;
                          final username = data['name'] ?? 'User';
                          return Text(
                            username,
                            style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                          );
                        }
                        return Text('User not found');
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  itemCount: categories.length,
                  controller: PageController(viewportFraction: 0.5),
                  onPageChanged: (int newIndex) {
                    setState(() {
                      _focusedIndex = newIndex;
                    });
                  },
                  itemBuilder: (context, i) {
                    final String label = categories[i]['label']!;
                    final String imagePath = categories[i]['image']!;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Opacity(
                        opacity: i == _focusedIndex ? 1.0 : 0.6,
                        child: Transform.scale(
                          scale: i == _focusedIndex ? 1.2 : 1.0,
                          child: GestureDetector(
                            onTap: () => _handleNavigation(context, label),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  imagePath,
                                  width: i == _focusedIndex ? 300 : 200,
                                  height: i == _focusedIndex ? 250 : 200,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  label,
                                  style: TextStyle(
                                    fontSize: i == _focusedIndex ? 20 : 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleNavigation(BuildContext context, String label) async {
    Widget destination;

    switch (label) {
      case '3D avatar':
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
          final data = doc.data();

          if (doc.exists &&
              data != null &&
              data['height'] != null &&
              data['hip'] != null &&
              data['chest'] != null &&
              data['waist'] != null &&
              data['height'].toString().isNotEmpty &&
              data['hip'].toString().isNotEmpty &&
              data['chest'].toString().isNotEmpty &&
              data['waist'].toString().isNotEmpty) {
            destination = AvatarMatcherPage();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          } else {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pinkAccent.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Measurements Required!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "You need to fill in your body measurements before accessing the 3D Avatar.",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: Text("Cancel", style: TextStyle(color: Colors.white)),
                            onPressed: () => Navigator.pop(context),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.pinkAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text("Fill Now"),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MeasurementInputPage()),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }
        return;
      case 'Wardrobe':
        destination = WardrobePage();
        break;
      case 'Find your outfit':
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
          final data = doc.data();

          if (doc.exists &&
              data != null &&
              data['height'] != null &&
              data['hip'] != null &&
              data['chest'] != null &&
              data['waist'] != null &&
              data['height'].toString().isNotEmpty &&
              data['hip'].toString().isNotEmpty &&
              data['chest'].toString().isNotEmpty &&
              data['waist'].toString().isNotEmpty) {
            destination = AvatarMatcherPage();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MatcherPage()),
            );
          } else {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pinkAccent.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Measurements Required!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "You need to fill in your body measurements before accessing the 3D Avatar.",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: Text("Cancel", style: TextStyle(color: Colors.white)),
                            onPressed: () => Navigator.pop(context),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.pinkAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text("Fill Now"),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MeasurementInputPage()),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }
        return;        
      default:
        destination = Scaffold(body: Center(child: Text('Page not found')));
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }
}
