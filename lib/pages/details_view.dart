import 'dart:developer' as dev;

import 'package:cached_network_image/cached_network_image.dart';
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
  MovieDetailsModel? movieDetails;

  @override
  void initState() {
    super.initState();

    asyncInit();
  }

  Future<void> asyncInit() async {
    if (widget.mType == MediaType.film) {
      final result = await tmdb.getMovieDetails(id: widget.id);
      dev.inspect(result);
      setState(() {
        movieDetails = result;
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
    if (movieDetails == null) {
      return Center(child: SizedBox(width: 350, child: ProgressBar()));
    }
    return CustomScrollView(
      slivers: [
        m.SliverAppBar(
          pinned: true,
          expandedHeight: 300.0,
          actions: [Button(onPressed: openMore, child: Icon(FluentIcons.more))],

          flexibleSpace: m.FlexibleSpaceBar(
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
                imageUrl: imageUrl(movieDetails!.backdropPath!),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),

        m.SliverList.list(
          children: List.generate(
            20,
            (i) =>
                Padding(padding: const EdgeInsets.all(16.0), child: Text("Movie detail line $i")),
          ),
        ),
      ],
    );
  }
}
