import 'package:flutter/material.dart';

class ItemPrivateValue extends StatelessWidget {
  final bool isLastItem;
  final String title;
  final String value;
  const ItemPrivateValue(
      {Key? key,
      this.isLastItem = false,
      required this.title,
      required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: !isLastItem ? const EdgeInsets.only(bottom: 10) : null,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        border: !isLastItem
            ? Border(
                bottom: BorderSide(
                    color: Theme.of(context).colorScheme.surfaceVariant))
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: Colors.grey,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
              Text(
                value,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.more_vert, size: 20))
        ],
      ),
    );
  }
}
