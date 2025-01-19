import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProfilePage(),
  ));
}

class UserProfile {
  String name;
  String email;
  String phone;
  String location;

  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
  });
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfile user = UserProfile(
    name: 'Swapnil belkar',
    email: 'sb123@gmail.com',
    phone: '+91 7219595828',
    location: 'Mumbai,USA',
  );

  void editProfile() async {
    final updatedUser = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(user: user),
      ),
    );

    if (updatedUser != null) {
      setState(() {
        user = updatedUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('c:\mp\hello\lib\profile(1).png'),
              ),
            ),
            SizedBox(height: 20),
            Text(
              user.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(height: 20),
            ProfileInfoRow(
                icon: Icons.email, title: 'Email', value: user.email),
            ProfileInfoRow(
                icon: Icons.phone, title: 'Phone', value: user.phone),
            ProfileInfoRow(
                icon: Icons.location_on,
                title: 'Location',
                value: user.location),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: editProfile,
              child: Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  ProfileInfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 30, color: Colors.blueAccent),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final UserProfile user;

  EditProfilePage({required this.user});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController locationController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    emailController = TextEditingController(text: widget.user.email);
    phoneController = TextEditingController(text: widget.user.phone);
    locationController = TextEditingController(text: widget.user.location);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    super.dispose();
  }

  void saveProfile() {
    UserProfile updatedUser = UserProfile(
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      location: locationController.text,
    );

    Navigator.pop(context, updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveProfile,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
