import 'package:flutter/material.dart';
import 'package:fyp/models/doc_type.dart';
import 'package:fyp/widgets/products/doc_widget.dart';
import 'package:provider/provider.dart';
import '../providers/doc_provider.dart';
import '../services/assets_manager.dart';
import '../widgets/title_text.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchTextController;
  List<DoctorType> doctorListSearch = [];

  @override
  void initState() {
    searchTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final docProvider = Provider.of<DocProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.logoApp),
        ),
        title: const TitlesTextWidget(label: "Search Doctors"),
      ),
      body: StreamBuilder<List<DoctorType>>(
        stream: docProvider.fetchDoctorsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('No doctors available'));
          }

          final doctors = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: searchTextController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintText: "Search by name or specialty...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: searchTextController.text.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchTextController.clear();
                        setState(() => doctorListSearch = []);
                        FocusScope.of(context).unfocus();
                      },
                    )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      doctorListSearch = docProvider.searchQuery(
                        searchText: value.trim(),
                      );
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Results Grid
                Expanded(
                  child: (searchTextController.text.isNotEmpty &&
                      doctorListSearch.isEmpty)
                      ? const Center(child: Text('No doctors found'))
                      : DynamicHeightGridView(
                    itemCount: searchTextController.text.isNotEmpty
                        ? doctorListSearch.length
                        : doctors.length,
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    builder: (context, index) {
                      final doctor = searchTextController.text.isNotEmpty
                          ? doctorListSearch[index]
                          : doctors[index];
                      return DocWidget(docId: doctor.docId);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}