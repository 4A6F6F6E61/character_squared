// ignore_for_file: implementation_imports

import 'dart:developer' as dev;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:character_squared/api/tmdb.dart';
import 'package:character_squared/pages/details_view.dart';
import 'package:character_squared/settings.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchController = TextEditingController();

  PaginatedResponse<MovieSummaryModel> results = PaginatedResponse(results: []);

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
              final r = await MyTmdb.searchMovies(
                query: value,
                includeAdult: Settings.includeAdult,
              );

              setState(() {
                results = r;
              });
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: results.results.length,
            itemBuilder: (_, i) {
              final result = results.results[i];

              return ListTile(
                leading: SizedBox(
                  height: 100,
                  child: AspectRatio(
                    aspectRatio: 9 / 16,
                    child: CachedNetworkImage(imageUrl: MyTmdb.imageUrl(result.posterPath) ?? ""),
                  ),
                ),
                title: Text(result.title ?? "ERROR"),
                subtitle: Text("${result.releaseDate?.year}"),
                onPressed: () {
                  final id = result.id;

                  dev.log("$id");
                  context.go("/tabs/search/details", extra: {"id": id, "mType": MediaType.film});
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
