import 'package:fluent_ui/fluent_ui.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchController = TextEditingController();
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
          ),
        ),
      ],
    );
  }
}
