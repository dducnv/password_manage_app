import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ItemCoppyValue extends StatefulWidget {
  final bool isLastItem;
  final String title;
  final String value;
  final bool isPrivateValue;
  const ItemCoppyValue(
      {Key? key,
      this.isLastItem = false,
      required this.title,
      required this.value,
      this.isPrivateValue = false})
      : super(key: key);

  @override
  State<ItemCoppyValue> createState() => _ItemCoppyValueState();
}

class _ItemCoppyValueState extends State<ItemCoppyValue> {
  bool _isShowValue = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: !widget.isLastItem ? const EdgeInsets.only(bottom: 10) : null,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        border: !widget.isLastItem
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
              Text(widget.title,
                  style: const TextStyle(
                      color: Colors.grey,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
              Text(
                widget.isPrivateValue
                    ? (_isShowValue ? widget.value : "************")
                    : widget.value,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          Row(
            children: [
              if (widget.isPrivateValue)
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isShowValue = !_isShowValue;
                    });
                  },
                  icon: _isShowValue
                      ? Icon(Icons.visibility_off,
                          color: Theme.of(context).colorScheme.primary)
                      : const Icon(
                          Icons.visibility,
                        ),
                ),
              IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: widget.value));
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard')));
                  },
                  icon: const Icon(Icons.copy, size: 20)),
            ],
          )
        ],
      ),
    );
  }
}
