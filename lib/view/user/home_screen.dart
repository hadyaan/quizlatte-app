import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quiz/model/category.dart';
import 'package:quiz/theme/theme.dart';
import 'package:quiz/view/user/category_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Category> _allCategories = [];
  List<Category> _filteredCategories = [];

  List<String> _categoryFilters = ['All'];
  String _selectedFilter = "All";
  late FocusNode _searchFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchCategories();
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchCategories() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('categories')
        .orderBy('createdAt', descending: true)
        .get();

    setState(() {
      _allCategories = snapshot.docs
          .map((doc) => Category.fromMap(doc.id, doc.data()))
          .toList();

      _categoryFilters =
          ['All'] +
          _allCategories.map((category) => category.name).toSet().toList();

      _filteredCategories = _allCategories;
    });
  }

  void _filterCategories(String query, {String? categoryFilters}) {
    setState(() {
      _filteredCategories = _allCategories.where((category) {
        final matchesSearch =
            category.name.toLowerCase().contains(query.toLowerCase()) ||
            category.description.toLowerCase().contains(query.toLowerCase());

        final matchesCategory =
            categoryFilters == null ||
            categoryFilters == "All" ||
            category.name.toLowerCase() == categoryFilters.toLowerCase();

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppTheme.backgroundHome, // Warna latar belakang scaffolding
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 230,
            pinned: true,
            floating: true,
            centerTitle: false,
            backgroundColor: AppTheme.primaryHome, // Warna coklat gelap
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            title: Text("Quizlatte", style: GoogleFonts.pacifico()),
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                color: Colors.white,
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacementNamed('/');
                  }
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: kToolbarHeight + 16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome Back!",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFF8E1), // Krem Muda
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Let’s level up your brain today",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFF8E1), // Krem Muda
                            ),
                          ),
                          SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _searchController,
                                focusNode: _searchFocusNode,
                                onChanged: (value) => _filterCategories(value),
                                decoration: InputDecoration(
                                  fillColor: AppTheme
                                      .surfaceHome, // Warna latar belakang untuk input search
                                  filled: true, // Penting untuk fillColor
                                  hintText: "Search categories...",
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: AppTheme
                                        .primaryHome, // Warna coklat gelap
                                  ),
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? IconButton(
                                          onPressed: () {
                                            _searchController.clear();
                                            _filterCategories('');
                                          },
                                          icon: Icon(Icons.clear),
                                          color: AppTheme.primaryHome,
                                        )
                                      : null,
                                  enabledBorder: OutlineInputBorder(
                                    // Border saat TextField tidak difokus
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors
                                          .black, // Warna border saat tidak fokus
                                      width: 2.0,
                                    ),
                                  ),
                                  // border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              collapseMode: CollapseMode.pin,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(16),
              height: 40,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categoryFilters.length,
                itemBuilder: (context, index) {
                  final filter = _categoryFilters[index];
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        filter,
                        style: TextStyle(
                          color: _selectedFilter == filter
                              ? AppTheme
                                    .textPrimaryColor // Warna teks untuk selected filter
                              : AppTheme
                                    .backgroundColor, // Warna teks untuk unselected filter (disarankan menggunakan warna yang kontras dengan backgroundColor chip)
                        ),
                      ),
                      selected: _selectedFilter == filter,
                      selectedColor: AppTheme.primaryHome, // Warna coklat gelap
                      backgroundColor: AppTheme.backgroundHome,
                      side: BorderSide(
                        color: _selectedFilter == filter
                            ? AppTheme
                                  .primaryHome // warna border saat selected
                            : AppTheme
                                  .backgroundColor, // warna border saat tidak selected
                        width: 2.0,
                      ), // Warna latar belakang chip unselected (krem/beige)
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedFilter = filter;
                          _filterCategories(
                            _searchController.text,
                            categoryFilters: filter,
                          );
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: _filteredCategories.isEmpty
                ? SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        "No categories found",
                        style: TextStyle(color: AppTheme.textSecondaryColor),
                      ),
                    ),
                  )
                : SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          _buildCategoryCard(_filteredCategories[index], index),
                      childCount: _filteredCategories.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.6,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Category category, int index) {
    return Card(
          elevation:
              6, // Meningkatkan elevasi sedikit agar border lebih terlihat
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              width: 2.0, // Lebar border
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryScreen(category: category),
                ),
              );
            },
            child: Container(
              // Tambahkan warna background pada container agar card tidak transparan di dalamnya
              // Menggunakan warna latar belakang krem/beige untuk isi card
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme
                          .surfaceHome, // Warna latar belakang icon (bisa sama dengan backgroundHome atau warna lain yang kontras)
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.quiz,
                      size: 48,
                      color: AppTheme.primaryHome, // Warna coklat gelap
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme
                          .backgroundColor, // Menggunakan warna teks utama (misal coklat gelap atau hitam)
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    category.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme
                          .backgroundColor, // Menggunakan warna teks sekunder (misal abu-abu gelap)
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        )
        .animate(delay: Duration(milliseconds: 100 * index))
        .slideY(begin: 0.5, end: 0, duration: Duration(milliseconds: 300))
        .fadeIn();
  }
}
