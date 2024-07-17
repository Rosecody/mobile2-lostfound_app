import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/edit_item_lost.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'user_info.dart';
import 'sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_found_item.dart';
import 'add_lost_item.dart';
import 'youtube_video.dart';
import 'edit_item_found.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int _selectedIndex = 0;
  User? _user = FirebaseAuth.instance.currentUser;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static List<Widget> _widgetOptions = <Widget>[
    FoundItemPage(),
    LostItemPage(),
    // Use Container() as placeholder for ProfilePage
    Container(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 2) {
      if (_user == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignInScreen(),
          ),
        ).then((_) {
          setState(() {
            _selectedIndex = 0; // Kembali ke halaman "Found Item" setelah kembali dari "Profile"
          });
        });
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserInfoScreen(user: _user),
          ),
        ).then((_) {
          setState(() {
            _selectedIndex = 0; // Kembali ke halaman "Found Item" setelah kembali dari "Profile"
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('KAN - Lost Found'),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      body: _selectedIndex == 2 ? Container() : _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Found',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_off),
            label: 'Lost',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(254, 247, 221, 2),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/k-on.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 16.0,
                    left: 16.0,
                    child: Text(
                      '-',
                      style: TextStyle(
                        // color: const Color.fromRGBO(254, 247, 221, 1),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        // backgroundColor: const Color.fromRGBO(254, 247, 221, 1).withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(0);
              },
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Found Item'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(0);
              },
            ),
            ListTile(
              leading: Icon(Icons.search_off),
              title: Text('Lost Item'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(1);
              },
            ),
            ListTile(
              leading: Icon(Icons.play_arrow),
              title: Text('Video Youtube'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => YoutubeVideo()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout_rounded),
              title: Text('Logout'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Icon(Icons.menu_open),
          heroTag: null,
        ),
        SizedBox(height: 10),
        if (_selectedIndex == 0) 
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddFound(),
                ),
              );
            },
            child: Icon(Icons.add),
            heroTag: null,
          ),
        if (_selectedIndex == 1) 
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddLost(),
                ),
              );
            },
            child: Icon(Icons.add),
            heroTag: null,
          ),
      ],
    );
  }
}

class FoundItemPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('item_found').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
            child: Card(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                  return Column(
                    children: [
                      GestureDetector(
                        child: ListTile(
                          leading: Icon(Icons.person),
                          title: Text(documentSnapshot["id"]),
                          subtitle: Text(documentSnapshot["nama"]),
                          trailing: Icon(Icons.navigate_next_rounded),
                        ),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditDataFound(
                                id: documentSnapshot["id"],
                                nama: documentSnapshot["nama"],
                                deskripsi: documentSnapshot["deskripsi"],
                              ),
                            ),
                          ), 
                      ),
                      Divider(
                        color: Colors.black,
                        indent: 10,
                        endIndent: 10,
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.black,
            ),
          );
        }
      },
    );
  }
}

class LostItemPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('item_lost').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
            child: Card(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                  return Column(
                    children: [
                      GestureDetector(
                        child: ListTile(
                          leading: Icon(Icons.person),
                          title: Text(documentSnapshot["id"]),
                          subtitle: Text(documentSnapshot["nama"]),
                          trailing: Icon(Icons.navigate_next_rounded),
                        ),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditDataLost(
                                id: documentSnapshot["id"],
                                nama: documentSnapshot["nama"],
                                deskripsi: documentSnapshot["deskripsi"],
                              ),
                            ),
                          ),  
                      ),
                      Divider(
                        color: Colors.black,
                        indent: 10,
                        endIndent: 10,
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.black,
            ),
          );
        }
      },
    );
  }
}
