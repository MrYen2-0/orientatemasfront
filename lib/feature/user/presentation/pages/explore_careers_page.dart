import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../model/career_models.dart';
import '../widgets/career_card_widget.dart';
import '../widgets/career_detail_sheet.dart';
import '../data/careers_data.dart';

class ExploreCareersPage extends StatefulWidget {
  const ExploreCareersPage({super.key});

  @override
  State<ExploreCareersPage> createState() => _ExploreCareersPageState();
}

class _ExploreCareersPageState extends State<ExploreCareersPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Todas';

  final List<String> _categories = [
    'Todas',
    'Salud',
    'Ingenieria',
    'Negocios',
    'Oficios Tecnicos',
  ];

  List<CareerItem> get _filteredCareers {
    if (_selectedCategory == 'Todas') {
      return CareersData.popularCareers;
    }
    return CareersData.popularCareers
        .where((career) => career.category == _selectedCategory)
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text('Explorar Carreras', style: textTheme.titleLarge),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: colorScheme.surface,
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar carreras...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Container(
            height: 50,
            color: colorScheme.surface,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    backgroundColor: colorScheme.surfaceVariant.withOpacity(0.3),
                    selectedColor: colorScheme.primaryContainer,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredCareers.length,
              itemBuilder: (context, index) {
                final career = _filteredCareers[index];
                return CareerCardWidget(
                  career: career,
                  onTap: () => _showCareerDetails(career),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showCareerDetails(CareerItem career) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CareerDetailSheet(career: career),
    );
  }
}