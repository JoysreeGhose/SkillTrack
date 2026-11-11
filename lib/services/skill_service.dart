
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/skill_model.dart';

class SkillService {
  final supabase = Supabase.instance.client;

  // Add Skill
  Future<void> addSkill(SkillModel skill) async {
    await supabase.from('skills').insert({
      'user_id': supabase.auth.currentUser!.id,
      'title': skill.title,
      'description': skill.description,
      'level': skill.level,
      'progress': skill.progress,
    });
  }

  // View Skills
  Future<List<SkillModel>> getSkills() async {
    final data = await supabase
        .from('skills')
        .select()
        .eq('user_id', supabase.auth.currentUser!.id);

    return data.map((json) => SkillModel.fromJson(json)).toList();
  }

  // Update Skill
  Future<void> updateSkill(
    String id,
    SkillModel skill,
  ) async {
    await supabase.from('skills').update({
      'title': skill.title,
      'description': skill.description,
      'level': skill.level,
      'progress': skill.progress,
    }).eq('id', id);
  }

  // Delete Skill
  Future<void> deleteSkill(String id) async {
    await supabase.from('skills').delete().eq('id', id);
  }
}
