import 'dart:developer';

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

  List<DoctorType> doctorListSearch = [];
  @override
  Widget build(BuildContext context) {
    final docProvider = Provider.of<DocProvider>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsManager.logoApp),
          ),
          title: const TitlesTextWidget(label: "Search Doctors"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 15.0),
              TextField(
                controller: searchTextController,
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      //setState(() {
                      FocusScope.of(context).unfocus();
                      searchTextController.clear();
                      //});
                    },
                    child: const Icon(Icons.clear, color: Colors.blueGrey),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    doctorListSearch = docProvider.searchQuery(
                        searchText: searchTextController.text
                    );
                  });
                },
                onSubmitted: (value) {
                  setState(() {
                    doctorListSearch = docProvider.searchQuery(
                        searchText: searchTextController.text
                    );
                  });
                },
              ),
              const SizedBox(height: 15.0),
              if(searchTextController.text.isNotEmpty && doctorListSearch.isEmpty)...[
                const Center(
                  child: TitlesTextWidget(label: "No doctor found",),
                ),
              ],
              Expanded(
                child: DynamicHeightGridView(
                  itemCount: searchTextController.text.isNotEmpty
                      ? doctorListSearch.length
                      : docProvider.getDoctors.length,
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  builder: (context, index) {
                    return DocWidget(
                      docId: searchTextController.text.isNotEmpty
                          ? doctorListSearch [index].docId
                          : docProvider.getDoctors[index].docId,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
