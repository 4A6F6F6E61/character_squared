import 'dart:developer';

import 'package:character_squared/db.dart';
import 'package:character_squared/models/search_result.dart';
import 'package:fluent_ui/fluent_ui.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchController = TextEditingController();

  List results = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          borderColor: Colors.transparent,
          child: TextFormBox(
            autocorrect: true,
            autofocus: false,
            controller: searchController,
            maxLines: 1,
            placeholder: "Search...",
            onFieldSubmitted: (value) async {
              final query = await tmdb.v3.search.queryMulti(value, includeAdult: true);

              setState(() {
                results = query["results"] as List;
              });
              inspect(results[0]);
              final test = SearchResult(results[0]);
              inspect(test);
            },
          ),
        ),
      ],
    );
  }
}
