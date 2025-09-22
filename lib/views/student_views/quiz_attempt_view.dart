// quiz_attempt_view.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:study_platform/helper/app_colors_fonts.dart';
import 'package:study_platform/models/student_models/quiz_model.dart';
import 'package:study_platform/services/student/quiz_service.dart';
import 'quiz_result_view.dart'; // إضافة استدعاء لصفحة النتائج الجديدة

class QuizAttemptView extends StatefulWidget {
  final int courseId;
  final int sectionId;
  final QuizModel quiz;

  const QuizAttemptView({
    super.key,
    required this.courseId,
    required this.sectionId,
    required this.quiz,
  });

  @override
  State<QuizAttemptView> createState() => _QuizAttemptViewState();
}

class _QuizAttemptViewState extends State<QuizAttemptView> {
  final QuizService _quizService = QuizService();
  final Map<int, int> _selectedAnswers = {};
  bool _isSubmitting = false;

  late Timer _timer;
  int? _remainingTime;
  int? _totalPoints;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.quiz.timeLimitMinutes;
    _startTimer();
    _calculateTotalPoints();

    for (var q in widget.quiz.questions) {
      _selectedAnswers[q.id] = -1;
    }
  }

  void _calculateTotalPoints() {
    _totalPoints = 0;
    for (var question in widget.quiz.questions) {
      _totalPoints = (_totalPoints ?? 0) + question.points;
    }
  }

  void _startTimer() {
    if (_remainingTime == null) return;
    const oneMinute = Duration(minutes: 1);
    _timer = Timer.periodic(oneMinute, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if ((_remainingTime ?? 0) == 0) {
        timer.cancel();
        _submitQuiz();
      } else {
        setState(() {
          _remainingTime = (_remainingTime ?? 0) - 1;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _submitQuiz() async {
    if (_selectedAnswers.containsValue(-1)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "⚠️ من فضلك أجب على جميع الأسئلة",
            style: TextStyle(fontFamily: AppFonts.mainFont),
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (!mounted) return;
    setState(() => _isSubmitting = true);

    try {
      final result = await _quizService.submitQuiz(
        courseId: widget.courseId,
        sectionId: widget.sectionId,
        quizId: widget.quiz.id,
        attemptId: widget.quiz.attemptId!,
        answers:
            _selectedAnswers.entries
                .map((e) => {"question_id": e.key, "choice_id": e.value})
                .toList(),
      );

      if (!mounted) return;

      // ⚠️ التغيير هنا: الانتقال إلى صفحة النتائج الجديدة
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) => QuizResultView(
                quiz: widget.quiz,
                submissionResult: result,
                selectedAnswers: _selectedAnswers,
              ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "❌ فشل في إرسال الاختبار: $e",
            style: const TextStyle(fontFamily: AppFonts.mainFont),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // باقي الكود كما هو...
  Future<void> _refreshQuiz() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "✅ تم تحديث الصفحة",
          style: TextStyle(fontFamily: AppFonts.mainFont),
        ),
      ),
    );
  }

  Widget _buildResultItem(String label, String value) {
    return Text.rich(
      TextSpan(
        text: label,
        style: TextStyle(
          fontFamily: AppFonts.mainFont,
          fontSize: 14,
          color: Colors.grey[700],
        ),
        children: [
          TextSpan(
            text: value,
            style: TextStyle(
              fontFamily: AppFonts.mainFont,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _refreshQuiz,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 180.0,
                floating: false,
                pinned: true,
                iconTheme: const IconThemeData(color: Colors.white),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(
                    bottom: 24.0,
                    right: 24.0,
                    left: 24.0,
                  ),
                  centerTitle: true,
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.quiz.title,
                        style: const TextStyle(
                          fontFamily: AppFonts.mainFont,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '⏱️ الوقت المتبقي: ${_remainingTime ?? "..."} دقيقة',
                        style: const TextStyle(
                          fontFamily: AppFonts.mainFont,
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryColor,
                          AppColors.gradientColor,
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'مجموع النقاط: ${_totalPoints ?? "..."} نقطة',
                    style: TextStyle(
                      fontFamily: AppFonts.mainFont,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final question = widget.quiz.questions[index];
                    final qId = question.id;
                    final isSelected = _selectedAnswers[qId] != -1;

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side:
                            isSelected
                                ? const BorderSide(
                                  color: AppColors.primaryColor,
                                  width: 2,
                                )
                                : BorderSide.none,
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "السؤال ${index + 1}: ${question.questionText}",
                              style: TextStyle(
                                fontFamily: AppFonts.mainFont,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "(${question.points} نقطة)",
                              style: TextStyle(
                                fontFamily: AppFonts.mainFont,
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const Divider(height: 20, color: Colors.grey),
                            ...question.choices.map((choice) {
                              final isChoiceSelected =
                                  _selectedAnswers[qId] == choice.id;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                  color:
                                      isChoiceSelected
                                          ? AppColors.primaryColor.withOpacity(
                                            0.1,
                                          )
                                          : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: RadioListTile<int>(
                                  title: Text(
                                    choice.choiceText,
                                    style: TextStyle(
                                      fontFamily: AppFonts.mainFont,
                                      color:
                                          isChoiceSelected
                                              ? AppColors.primaryColor
                                              : Colors.black87,
                                      fontWeight:
                                          isChoiceSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                  value: choice.id,
                                  groupValue: _selectedAnswers[qId],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedAnswers[qId] = value!;
                                    });
                                  },
                                  activeColor: AppColors.primaryColor,
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    );
                  }, childCount: widget.quiz.questions.length),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: _isSubmitting ? null : _submitQuiz,
            child:
                _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                      "إرسال الاختبار",
                      style: TextStyle(
                        fontFamily: AppFonts.mainFont,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}
