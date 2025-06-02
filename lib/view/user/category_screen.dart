import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quiz/model/category.dart';
import 'package:quiz/model/quiz.dart';
import 'package:quiz/theme/theme.dart';
import 'package:quiz/view/user/quiz_play_screen.dart';

class CategoryScreen extends StatefulWidget {
  final Category category;
  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Quiz> _quizzes = [];
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchQuizzes();
  }

  Future<void> _fetchQuizzes() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("quizzes")
          .where("categoryId", isEqualTo: widget.category.id)
          .get();

      setState(() {
        _quizzes = snapshot.docs
            .map((doc) => Quiz.fromMap(doc.id, doc.data()))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load quizzes")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundHome,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: AppTheme.primaryHome),
            )
          : _quizzes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.quiz_outlined,
                    size: 64,
                    color: AppTheme.backgroundColor,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No quizzes available in this category",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.backgroundColor,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppTheme.primaryHome, // Warna background tombol
                      foregroundColor: Colors.white, // Warna teks tombol
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Go back", style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            )
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  foregroundColor: Color(0xFFFFF8E1),
                  backgroundColor: AppTheme.primaryHome,
                  expandedHeight: 230,
                  floating: false,
                  pinned: true,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.category.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.surfaceHome,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    background: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.category_rounded,
                            size: 64,
                            color: AppTheme.surfaceHome,
                          ),
                          SizedBox(height: 4),
                          Text(
                            widget.category.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.surfaceHome,
                            ),
                          ),
                          SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _quizzes.length,
                      itemBuilder: (context, index) {
                        final quiz = _quizzes[index];
                        return _buildQuizCard(quiz, index);
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildQuizCard(Quiz quiz, int index) {
    return Card(
          margin: EdgeInsets.only(bottom: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizPlayScreen(quiz: quiz),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceHome,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.quiz_rounded,
                      color: AppTheme.primaryHome,
                      size: 32,
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quiz.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.backgroundColor,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.question_answer_outlined,
                                  size: 16,
                                  color: AppTheme.backgroundColor,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '${quiz.questions.length} Questions',
                                  style: TextStyle(
                                    color: AppTheme.backgroundColor,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Icon(
                                  Icons.timer_outlined,
                                  size: 16,
                                  color: AppTheme.backgroundColor,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '${quiz.timeLImit} mins',
                                  style: TextStyle(
                                    color: AppTheme.backgroundColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 30,
                    color: AppTheme.primaryHome,
                  ),
                ],
              ),
            ),
          ),
        )
        .animate(delay: Duration(milliseconds: 100 * index))
        .slideX(begin: 0.5, end: 0, duration: Duration(milliseconds: 300))
        .fadeIn();
  }
}
