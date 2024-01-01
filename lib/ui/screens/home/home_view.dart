import 'package:flutter/material.dart';
import 'package:password_manage_app/core/core.dart';
import 'package:password_manage_app/core/database/data_seeder.dart';
import 'package:password_manage_app/core/domains/models/models.dart';
import 'package:password_manage_app/ui/base/base.dart';
import 'package:password_manage_app/ui/route/route.dart';
import 'package:password_manage_app/ui/screens/home/widgets/account_item_widget.dart';
import 'package:password_manage_app/ui/screens/screen.dart';
import 'package:password_manage_app/ui/widgets/widgets.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
      onViewModelReady: (viewModel) {},
      builder: (context, viewModel, _) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
              elevation: 0,
              scrolledUnderElevation: 0,
              title: Text(Strings.homePageTitle),
              leading: IconButton(
                icon: const Icon(Icons.sort_rounded),
                onPressed: () {},
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_rounded),
                  onPressed: () {
                    Navigator.pushNamed(context, RoutePaths.settingRoute);
                  },
                ),
              ]),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(25)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: categories.length,
                            addAutomaticKeepAlives: true,
                            addRepaintBoundaries: true,
                            itemBuilder: (context, index) {
                              return CardItem<AccountModel>(
                                title: categories[index].name ?? "",
                                items: categories[index].accounts ?? [],
                                itemBuilder: (item, itemIndex) {
                                  return AccountItemWidget(
                                      accountModel: item,
                                      isLastItem:
                                          categories[index].accounts!.length ==
                                              itemIndex + 1);
                                },
                              );
                            }),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
                      Flexible(
                        child: SizedBox(
                          height: 35,
                          child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 10),
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              return Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    color: index == 0
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20)),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, RoutePaths.detailsAccount);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 2),
                                    child: Center(
                                      child: Text(
                                        categories[index].name ?? "",
                                        style: TextStyle(
                                            color: index == 0
                                                ? Colors.white
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onSecondary),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
