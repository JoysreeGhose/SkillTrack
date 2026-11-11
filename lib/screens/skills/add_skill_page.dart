
import 'package:flutter/material.dart';
import '../../models/skill_model.dart';
import '../../services/skill_service.dart';

class AddSkillPage extends StatefulWidget {
  const AddSkillPage({super.key});

  @override
  State<AddSkillPage> createState() => _AddSkillPageState();
}

class _AddSkillPageState extends State<AddSkillPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final skillService = SkillService();
  final formKey = GlobalKey<FormState>();

  String selectedLevel = 'Beginner';
  double progress = 0;
  bool isLoading = false;

  Future<void> saveSkill() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final skill = SkillModel(
        id: '',
        userId: '',
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        level: selectedLevel,
        progress: progress.toInt(),
      );

      await skillService.addSkill(skill);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Skill added successfully!'),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Skill'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Skill Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Enter skill name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter skill name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              const Text(
                'Description',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Write a short description',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Skill Level',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                initialValue: selectedLevel,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Beginner',
                    child: Text('Beginner'),
                  ),
                  DropdownMenuItem(
                    value: 'Intermediate',
                    child: Text('Intermediate'),
                  ),
                  DropdownMenuItem(
                    value: 'Advanced',
                    child: Text('Advanced'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedLevel = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 20),

              Text(
                'Learning Progress: ${progress.toInt()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              Slider(
                value: progress,
                min: 0,
                max: 100,
                divisions: 10,
                label: '${progress.toInt()}%',
                onChanged: (value) {
                  setState(() {
                    progress = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : saveSkill,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Save Skill'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

