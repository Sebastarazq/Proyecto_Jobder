import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  static const String name = 'user_screen';

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  // Sample user data (replace with actual data fetching)
  final List<UserData> _users = [
    UserData(
      name: 'John Doe',
      imageUrl: 'https://picsum.photos/200/300',
      age: 30,
      bio: 'Adventurer, dog lover, foodie',
      sharedInterests: ['Travel', 'Hiking', 'Cooking'],
    ),
    // Add more sample users here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Potential Matches'),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return _buildUserCard(user);
        },
      ),
    );
  }

  Widget _buildUserCard(UserData user) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        onTap: () {
          // Navigate to the user's profile screen
          GoRouter.of(context).go('/profile/${user.name}');
        },
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(user.imageUrl),
        ),
        title: Text(user.name),
        subtitle: Text('${user.age} years old'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                // Handle "Like" action
                print('Liked ${user.name}');
              },
              icon: const Icon(Icons.favorite),
              color: Colors.red,
            ),
            IconButton(
              onPressed: () {
                // Handle "Pass" action
                print('Passed ${user.name}');
              },
              icon: const Icon(Icons.close),
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

// Sample user data model (replace with your actual data model)
class UserData {
  final String name;
  final String imageUrl;
  final int age;
  final String? bio;
  final List<String>? sharedInterests;

  UserData({
    required this.name,
    required this.imageUrl,
    required this.age,
    this.bio,
    this.sharedInterests,
  });
}
