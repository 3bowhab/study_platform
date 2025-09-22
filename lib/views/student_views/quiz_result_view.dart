import 'package:flutter/material.dart';
import 'package:study_platform/helper/app_colors_fonts.dart';
import 'package:study_platform/models/student_models/question_model.dart';
import 'package:study_platform/models/student_models/quiz_model.dart';

class QuizResultView extends StatelessWidget {
  final QuizModel quiz;
  final Map<String, dynamic> submissionResult;
  final Map<int, int> selectedAnswers;

  const QuizResultView({
    super.key,
    required this.quiz,
    required this.submissionResult,
    required this.selectedAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "نتائج: ${quiz.title}",
            style: TextStyle(fontFamily: AppFonts.mainFont),
          ),
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              // الرجوع إلى صفحة تفاصيل الدورة التدريبية
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ملخص النتيجة
              _buildResultSummary(),
              const SizedBox(height: 24),
              // عرض الأسئلة والإجابات
              Text(
                "مراجعة الأسئلة",
                style: TextStyle(
                  fontFamily: AppFonts.mainFont,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const Divider(thickness: 2, color: AppColors.primaryColor),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: quiz.questions.length,
                itemBuilder: (context, index) {
                  final question = quiz.questions[index];
                  // هنا نفترض أن الإجابة الصحيحة متاحة في النموذج
                  // في الواقع العملي، قد تحتاج إلى الحصول عليها من الـ API
                  // ونفترض وجود خاصية correctChoiceId في QuestionModel
                  final correctChoiceId = _getCorrectChoiceId(question);
                  final userSelectedChoiceId = selectedAnswers[question.id];
                  return _buildQuestionResultCard(
                    index + 1,
                    question,
                    userSelectedChoiceId,
                    correctChoiceId,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // بناء ملخص النتيجة
  Widget _buildResultSummary() {
    bool isPassed = submissionResult['is_passed'] ?? false;
    Color statusColor = isPassed ? Colors.green : Colors.red;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              isPassed ? "تهانينا! لقد نجحت 🎉" : "حظًا أوفر! لقد رسبت ❌",
              style: TextStyle(
                fontFamily: AppFonts.mainFont,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child: CircularProgressIndicator(
                    value: (submissionResult['score'] as num) / 100,
                    strokeWidth: 10,
                    backgroundColor: Colors.grey.shade300,
                    color: statusColor,
                  ),
                ),
                Text(
                  "${(submissionResult['score'] as num).toStringAsFixed(0)}%",
                  style: TextStyle(
                    fontFamily: AppFonts.mainFont,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInfoRow(
              "✅ الإجابات الصحيحة",
              "${submissionResult['correct_answers']}/${submissionResult['total_questions']}",
            ),
            _buildInfoRow(
              "⏱ الوقت المستغرق",
              "${submissionResult['time_taken_minutes']} دقيقة",
            ),
            _buildInfoRow("💯 درجة النجاح", "${quiz.passingScore}%"),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.mainFont,
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: AppFonts.mainFont,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // بناء كارت نتيجة السؤال
  Widget _buildQuestionResultCard(
    int questionNumber,
    QuestionModel question,
    int? userChoiceId,
    int? correctChoiceId,
  ) {
    bool isCorrect = userChoiceId == correctChoiceId;
    Color cardColor = isCorrect ? Colors.green.shade50 : Colors.red.shade50;
    Color borderColor = isCorrect ? Colors.green.shade200 : Colors.red.shade200;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor, width: 2),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "السؤال $questionNumber: ${question.questionText}",
              style: TextStyle(
                fontFamily: AppFonts.mainFont,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isCorrect ? Colors.green.shade800 : Colors.red.shade800,
              ),
            ),
            const Divider(height: 20),
            ...question.choices.map((choice) {
              final isUserChoice = userChoiceId == choice.id;
              final isCorrectChoice = correctChoiceId == choice.id;
              Color tileColor = Colors.white;
              IconData? icon;

              if (isUserChoice) {
                icon = isCorrect ? Icons.check_circle : Icons.cancel;
                tileColor =
                    isCorrect ? Colors.green.shade100 : Colors.red.shade100;
              } else if (isCorrectChoice) {
                icon = Icons.check_circle_outline;
                tileColor = Colors.green.shade50;
              }

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: tileColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isUserChoice ? borderColor : Colors.transparent,
                  ),
                ),
                child: ListTile(
                  leading:
                      icon != null
                          ? Icon(
                            icon,
                            color: isCorrect ? Colors.green : Colors.red,
                          )
                          : null,
                  title: Text(
                    choice.choiceText,
                    style: TextStyle(
                      fontFamily: AppFonts.mainFont,
                      fontWeight:
                          isUserChoice || isCorrectChoice
                              ? FontWeight.bold
                              : FontWeight.normal,
                      color:
                          isUserChoice || isCorrectChoice
                              ? Colors.black87
                              : Colors.grey[600],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // دالة افتراضية للحصول على الإجابة الصحيحة.
  // في التطبيق الحقيقي، هذه البيانات يجب أن تأتي من الـ API.
  int? _getCorrectChoiceId(QuestionModel question) {
    switch (question.id) {
      case 21:
        return 21; // الإجابة الصحيحة لـ "what is your name?" هي "hamdy"
      case 22:
        return 24; // الإجابة الصحيحة لـ "what are you doing" هي "ssww"
      default:
        return null;
    }
  }
}
