
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    final name = user?.userMetadata?['name'] ?? 'Learner';
    final email = user?.email ?? 'No email available';

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                child: Icon(
                  Icons.person,
                  size: 55,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                email,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 25),
              const Card(
                child: ListTile(
                  leading: Icon(Icons.school),
                  title: Text('SkillTrack Learner'),
                  subtitle: Text('Keep learning and growing!'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
