import 'package:flutter/material.dart';

import '../../core/theme/style.dart';

class MyCustomSearchDelegate extends SearchDelegate<String> {
  TextEditingController textController = TextEditingController();
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        textController.dispose();

        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SizedBox(
      height: 100.0,
      width: 100.0,
      child: Card(
        color: Colors.red,
        child: Center(
          child: Text(query),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Scaffold(extendBody: true, body: SizedBox());
  }

  @override
  String get searchFieldLabel => 'Search Destinations';

  @override
  TextInputAction get textInputAction => TextInputAction.search;
  TextInputType get textInputType => TextInputType.text;
  Widget buildSearchField() {
    return TextField(
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Search',
      ),
      onChanged: (String value) {
        query = value;
      },
    );
  }
}

@override
ThemeData appBarTheme(BuildContext context) {
  return ThemeData(
    canvasColor: Colors.white,
    appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: fontColor,
        )),
  );
}
