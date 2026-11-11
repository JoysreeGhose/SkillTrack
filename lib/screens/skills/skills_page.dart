
import 'package:flutter/material.dart';
import '../../models/skill_model.dart';
import '../../services/skill_service.dart';
import 'add_skill_page.dart';

class SkillsPage extends StatefulWidget {
  const SkillsPage({super.key});

  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
  final skillService = SkillService();
  final searchController = TextEditingController();

  late Future<List<SkillModel>> skillsFuture;

  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    skillsFuture = skillService.getSkills();
  }

  void refreshSkills() {
    setState(() {
      skillsFuture = skillService.getSkills();
    });
  }

  Future<void> editSkill(SkillModel skill) async {
    final titleController = TextEditingController(text: skill.title);
    final descriptionController =
        TextEditingController(text: skill.description);

    String level = skill.level;
    int progress = skill.progress;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Skill'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Skill Name',
                      ),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      value: level,
                      isExpanded: true,
                      items: ['Beginner', 'Intermediate', 'Advanced']
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            level = value;
                          });
                        }
                      },
                    ),
                    Text('Progress: $progress%'),
                    Slider(
                      value: progress.toDouble(),
                      min: 0,
                      max: 100,
                      divisions: 20,
                      onChanged: (value) {
                        setDialogState(() {
                          progress = value.toInt();
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.trim().isEmpty) return;

                    try {
                      final updatedSkill = SkillModel(
                        id: skill.id,
                        userId: skill.userId,
                        title: titleController.text.trim(),
                        description: descriptionController.text.trim(),
                        level: level,
                        progress: progress,
                      );

                      await skillService.updateSkill(
                        skill.id,
                        updatedSkill,
                      );

                      if (!mounted || !dialogContext.mounted) return;

                      Navigator.pop(dialogContext);
                      refreshSkills();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Skill updated successfully'),
                        ),
                      );
                    } catch (e) {
                      if (!mounted || !dialogContext.mounted) return;

                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );

    titleController.dispose();
    descriptionController.dispose();
  }

  Future<void> deleteSkill(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Skill?'),
          content: const Text(
            'Are you sure you want to delete this skill?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      await skillService.deleteSkill(id);

      if (!mounted) return;

      refreshSkills();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Skill deleted successfully'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Skills'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search skills...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    setState(() {
                      searchQuery = '';
                    });
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.trim().toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<SkillModel>>(
              future: skillsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                final allSkills = snapshot.data ?? [];

                final skills = allSkills.where((skill) {
                  return skill.title.toLowerCase().contains(searchQuery) ||
                      skill.description.toLowerCase().contains(searchQuery);
                }).toList();

                if (skills.isEmpty) {
                  return Center(
                    child: Text(
                      searchQuery.isEmpty
                          ? 'No skills added yet.'
                          : 'No matching skills found.',
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: skills.length,
                  itemBuilder: (context, index) {
                    final skill = skills[index];

                    return Card(
                      child: ListTile(
                        title: Text(skill.title),
                        subtitle: Text(
                          '${skill.level} • ${skill.progress}% complete',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => editSkill(skill),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () => deleteSkill(skill.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddSkillPage(),
            ),
          );

          if (!mounted) return;
          refreshSkills();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}




