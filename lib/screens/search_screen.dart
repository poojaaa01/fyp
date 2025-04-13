import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
          leading: Padding(
          padding: const EdgeInsets.all(8.0),
      child: Image.asset(
      AssetsManager.logoApp,
      ),
      ),
      title: const TitlesTextWidget(label: "Search Doctors"),
          ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: searchTextController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: GestureDetector(
                    onTap: (){setState(() {
                      FocusScope.of(context).unfocus();
                      searchTextController.clear();
                    });
                      },
                    child: const Icon(
                        Icons.clear,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                onChanged: (value){
                  log("Value of the text is $value");
                },
                onSubmitted: (value){
                  log("Value of the text is $value");
                  log("value of the controller text: ${searchTextController.text}");
                },
              ),
              Expanded(
                child: DynamicHeightGridView
                  (builder: (context, index){
                  return Center(
                    child: Text(index.toString()),
                  );
                },
                    itemCount: 200,
                    crossAxisCount: 2
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}