import 'package:flutter/material.dart';
import 'package:study_platform/services/parent/parent_child_progress_service.dart';
import 'package:study_platform/views/parent_views/parent_child_quiz_results_view.dart';
import 'package:study_platform/widgets/custom_drawer.dart'; // ✅ استورد الصفحة

class ParentDashboardView extends StatefulWidget {
  const ParentDashboardView({super.key});

  @override
  State<ParentDashboardView> createState() => _ParentDashboardViewState();
}

class _ParentDashboardViewState extends State<ParentDashboardView> {
  int _selectedIndex = 0;

  final ParentChildProgressService _progressService =
      ParentChildProgressService();

  Map<String, dynamic>? _childProgress;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchProgress();
  }

  Future<void> _fetchProgress() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final progress = await _progressService.getFirstChildProgress();
      setState(() {
        _childProgress = progress;
      });
    } catch (e) {
      setState(() {
        _error = "❌ Failed to load progress: $e";
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // ✅ صفحات البوتوم ناف بار
  List<Widget> get _pages => [
    _buildProgressPage(),
    const ParentChildQuizResultsView(), // 👈 هنا حطينا صفحة الكويز بدل الأبناء
    const Center(child: Text("⚙️ الإعدادات")),
  ];

  Widget _buildProgressPage() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!));
    }
    if (_childProgress == null) {
      return const Center(child: Text("لا يوجد بيانات حالياً"));
    }

    final summary = _childProgress!["overall_summary"];
    final child = _childProgress!["child"];

    return RefreshIndicator(
      onRefresh: _fetchProgress,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "👦 ${child["name"]} (${child["username"]})",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _infoCard("📚 عدد الكورسات", "${summary["total_courses"]}"),
          _infoCard(
            "✅ عدد الأقسام المكتملة",
            "${summary["total_sections_completed"]}",
          ),
          _infoCard("📖 إجمالي الأقسام", "${summary["total_sections"]}"),
          _infoCard(
            "📊 نسبة الإكمال",
            "${summary["overall_completion_percentage"]}%",
          ),
        ],
      ),
    );
  }

  Widget _infoCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.check_circle, color: Colors.blueAccent),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("لوحة ولي الأمر")),
      drawer: CustomDrawer(), // ✅ استخدم الدراور المخصص`
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.insights), label: "التقدم"),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: "نتائج الكويزات",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "الإعدادات",
          ),
        ],
      ),
    );
  }
}
