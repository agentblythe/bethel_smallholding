import 'package:bethel_smallholding/app/home/blog/empty_content.dart';
import 'package:flutter/material.dart';

typedef ItemWidgetBuilder<T> = Widget Function(
  BuildContext context,
  T item,
);

class ListItemsBuilder<T> extends StatelessWidget {
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;

  const ListItemsBuilder({
    Key? key,
    required this.snapshot,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T>? items = snapshot.data;
      if (items == null || items.isEmpty) {
        return const EmptyContent();
      } else {
        return _buildList(items);
      }
    } else if (snapshot.hasError) {
      return const EmptyContent(
        title: "Something went wrong",
        message: "We can't load the items right now",
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildList(List<T> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return itemBuilder(context, items[index]);
      },
    );
  }
}
