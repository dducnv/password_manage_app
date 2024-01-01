import 'package:flutter/material.dart';
import 'package:password_manage_app/core/domains/models/models.dart';
import 'package:password_manage_app/ui/route/route.dart';

class AccountItemWidget extends StatelessWidget {
  final AccountModel accountModel;
  final bool isLastItem;
  const AccountItemWidget(
      {Key? key, required this.accountModel, required this.isLastItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, RoutePaths.detailsAccount);
        },
        child: Container(
          padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                        child: Text(accountModel.title![0].toUpperCase()))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    border: isLastItem
                        ? null
                        : Border(
                            bottom: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant),
                          ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              accountModel.title ?? "",
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                              maxLines: 1,
                            ),
                            Text(accountModel.email ?? "",
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.more_vert))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
