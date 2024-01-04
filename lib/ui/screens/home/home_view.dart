import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:password_manage_app/core/core.dart';
import 'package:password_manage_app/ui/base/base.dart';
import 'package:password_manage_app/ui/route/route.dart';
import 'package:password_manage_app/ui/screens/home/widgets/account_item_widget.dart';
import 'package:password_manage_app/ui/screens/screen.dart';
import 'package:password_manage_app/ui/widgets/widgets.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
      onViewModelReady: (viewModel) {
        viewModel.init();
      },
      builder: (context, viewModel, _) {
        return Scaffold(
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                shape: const CircleBorder(),
                onPressed: () async {
                  var isCreateSuccess = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateAccountView()));

                  if (isCreateSuccess != null) {
                    viewModel.getCategories();
                  }
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
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
                        ValueListenableBuilder(
                            valueListenable: viewModel.listCategory,
                            builder: (context, value, child) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  dragStartBehavior: DragStartBehavior.down,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: value.length,
                                  addAutomaticKeepAlives: true,
                                  addRepaintBoundaries: true,
                                  itemBuilder: (context, index) {
                                    var cateItem = value[index];
                                    return cateItem.accounts!.isEmpty
                                        ? const SizedBox.shrink()
                                        : CardItem<AccountModel>(
                                            title: cateItem.name ?? "",
                                            items: cateItem.accounts ?? [],
                                            itemBuilder: (item, itemIndex) {
                                              return AccountItemWidget(
                                                  accountModel: item,
                                                  isLastItem: cateItem
                                                          .accounts!.length ==
                                                      itemIndex + 1);
                                            },
                                          );
                                  });
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
                      IconButton(
                          onPressed: () {
                            bottomSheetCreateCategory(
                                context: context, viewModel: viewModel);
                          },
                          icon: const Icon(Icons.add)),
                      Flexible(
                        child: SizedBox(
                          height: 35,
                          child: DoubleValueListenBuilder(
                            viewModel.listCategoryFilterBar,
                            viewModel.categorySelected,
                            builder: (context, listCate, cateSelected, child) {
                              listCate = [
                                CategoryModel(id: "-1", name: "All"),
                                ...listCate
                              ];
                              return ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 10),
                                scrollDirection: Axis.horizontal,
                                itemCount: listCate.length,
                                itemBuilder: (context, index) {
                                  return Material(
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        color: cateSelected!.id ==
                                                listCate[index].id
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Colors.grey.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(25),
                                        onTap: () {
                                          viewModel.handleFilterByCategory(
                                              listCate[index]);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 2),
                                          child: Center(
                                            child: Text(
                                              listCate[index].name ?? "",
                                              style: TextStyle(
                                                  color: cateSelected.id ==
                                                          listCate[index].id
                                                      ? Colors.white
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .onSecondary),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
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
