import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:app_jobder/domain/entities/user_data.dart';
import 'package:app_jobder/presentation/screens/shared/widgets/navigation_bar.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  static const String name = 'user_screen';

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final CardSwiperController controller = CardSwiperController();

  // Datos de usuarios de muestra
  final List<UserData> _users = [
    UserData(
      name: 'John Doe',
      imageUrl: 'https://picsum.photos/200/300',
      age: 30,
      bio: 'Adventurer, dog lover, foodie',
      sharedInterests: ['Travel', 'Hiking', 'Cooking'],
    ),
    UserData(
      name: 'Alice Smith',
      imageUrl: 'https://picsum.photos/200/300',
      age: 25,
      bio: 'Nature enthusiast, bookworm',
      sharedInterests: ['Reading', 'Photography', 'Running'],
    ),
    UserData(
      name: 'Bob Johnson',
      imageUrl: 'https://picsum.photos/200/300',
      age: 35,
      bio: 'Tech geek, gamer',
      sharedInterests: ['Technology', 'Gaming', 'Movies'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isControllerAvailable = mounted;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make app bar transparent
        elevation: 0, // Remove app bar elevation
        title: const Row(
          children: [
            Icon(Icons.work), // Icono de trabajo
            SizedBox(width: 8), // Espacio entre el icono y el título
            Text('Jobder'), // Título
          ],
        ),
      ),
      extendBodyBehindAppBar: true, // Extend body behind app bar
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEE805F), Color(0xFF096BFF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: _users.isNotEmpty
                    ? CardSwiper(
                        controller: controller,
                        cardsCount: _users.length,
                        cardBuilder: (context, index, percentX, percentY) {
                          final user = _users[index];
                          return UserCard(
                            user: user,
                            controller: controller,
                            onSwipeLeft: () {
                              if (isControllerAvailable) {
                                controller.swipe(CardSwiperDirection.left);
                              }
                            },
                            onSwipeRight: () {
                              if (isControllerAvailable) {
                                controller.swipe(CardSwiperDirection.right);
                              }
                            },
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          'No more users to match!',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
    );
  }
}

class UserCard extends StatelessWidget {
  final UserData user;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final CardSwiperController? controller;

  const UserCard({
    Key? key,
    required this.user,
    this.controller,
    this.onSwipeLeft,
    this.onSwipeRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.network(
                    user.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${user.age} years old',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        user.bio ?? '',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20.0,
            left: 80.0,
            child: FloatingActionButton(
              onPressed: onSwipeLeft,
              child: const Icon(Icons.close),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
          Positioned(
            bottom: 20.0,
            right: 80.0,
            child: FloatingActionButton(
              onPressed: onSwipeRight,
              child: const Icon(Icons.check),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
