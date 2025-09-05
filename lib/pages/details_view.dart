import 'dart:developer' as dev;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:character_squared/api/tmdb.dart';
import 'package:character_squared/components/action_button.dart';
import 'package:character_squared/db.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;
import 'package:go_router/go_router.dart';
import 'package:tmdb_api_kit/src/models/movie_details_model.dart';

enum MediaType { film, tv, actor }

class DetailsView extends StatefulWidget {
  const DetailsView({super.key, required this.id, required this.mType});

  final int id;
  final MediaType mType;

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  Movie? movie;

  @override
  void initState() {
    super.initState();

    asyncInit();
  }

  Future<void> asyncInit() async {
    if (widget.mType == MediaType.film) {
      final result = await Movie.fromId(widget.id);
      dev.inspect(result);
      setState(() {
        movie = result;
      });
    }
    // TODO: Add everything else
  }

  void openMore() {
    /* TODO: */
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mType != MediaType.film) {
      return Text("Unsupported");
    }
    if (movie == null) {
      return Center(child: SizedBox(width: 350, child: ProgressBar()));
    }
    return CustomScrollView(
      slivers: [
        m.SliverAppBar(
          pinned: true,
          expandedHeight: 300.0,
          backgroundColor: Colors.transparent,
          actions: [Button(onPressed: openMore, child: Icon(FluentIcons.more))],
          flexibleSpace: m.FlexibleSpaceBar(
            collapseMode: m.CollapseMode.pin,
            background: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.transparent],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: CachedNetworkImage(
                width: double.maxFinite,
                height: 300,
                imageUrl: movie!.backdropUrl ?? "",
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),

        m.SliverList.list(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0, left: 16.0, right: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(movie!.title, style: TextStyle(fontSize: 20)),
                        SizedBox(height: 20),
                        Text(
                          "${movie!.release.year}  •  DIRECTED BY",
                          style: TextStyle(color: Colors.grey[100]),
                        ),
                        SizedBox(height: 5),
                        Text(movie?.director?.name ?? "ERROR"),
                      ],
                    ),
                  ),
                  CachedNetworkImage(width: 100, imageUrl: movie!.posterUrlHigh ?? ""),
                ],
              ),
            ),
            ...List.generate(
              20,
              (i) =>
                  Padding(padding: const EdgeInsets.all(16.0), child: Text("Movie detail line $i")),
            ),
          ],
        ),
      ],
    );
  }
}
