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
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
      onViewModelReady: (viewModel) {
        viewModel.init();
      },
      builder: (context, viewModel, _) {
        return Scaffold(
          key: scaffoldKey,
          drawer: const AppDrawer(),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                shape: const CircleBorder(),
                onPressed: () async {
                  dynamic isPop = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateAccountView(
                              categoryModel:
                                  viewModel.categorySelected.value)));

                  if (isPop['filter'] == "reload") {
                    Future.delayed(const Duration(milliseconds: 50), () {
                      viewModel.handleFilterByCategory(
                          viewModel.categorySelected.value);
                    });
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
                onPressed: () {
                  if (scaffoldKey.currentState!.isDrawerOpen) {
                    scaffoldKey.currentState!.closeDrawer();
                    //close drawer, if drawer is open
                  } else {
                    scaffoldKey.currentState!.openDrawer();
                    //open drawer, if drawer is closed
                  }
                },
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
                  child: RefreshIndicator(
                    color: Theme.of(context).colorScheme.primary,
                    onRefresh: () async {},
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          ValueListenableBuilder(
                              valueListenable:
                                  viewModel.dataShared.categoryList,
                              builder: (context, value, child) {
                                return value.isEmpty || viewModel.isAccountEmpty
                                    ? Center(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(
                                              height: 100,
                                            ),
                                            Image.asset(
                                              "assets/images/exclamation-mark.png",
                                              width: 60,
                                              height: 60,
                                            ),
                                            const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("Ấn nút"),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                CircleAvatar(
                                                  child: Icon(Icons.add),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text("để thêm tài khoản"),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        dragStartBehavior:
                                            DragStartBehavior.down,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: value.length,
                                        addAutomaticKeepAlives: true,
                                        addRepaintBoundaries: true,
                                        itemBuilder: (context, index) {
                                          var cateItem = value[index];
                                          return cateItem.accounts!.isEmpty
                                              ? const SizedBox.shrink()
                                              : CardItem<AccountModel>(
                                                  title: cateItem.name ?? "",
                                                  items:
                                                      cateItem.accounts ?? [],
                                                  itemBuilder:
                                                      (item, itemIndex) {
                                                    return AccountItemWidget(
                                                        onCallBackPop: () {
                                                          viewModel
                                                              .handleFilterByCategory(
                                                                  viewModel
                                                                      .categorySelected
                                                                      .value);
                                                        },
                                                        onLongPress: () {
                                                          bottomSheetOptionAccountItem(
                                                              viewModel:
                                                                  viewModel,
                                                              context: context);
                                                        },
                                                        onTapSubButton: () {
                                                          bottomSheetOptionAccountItem(
                                                              viewModel:
                                                                  viewModel,
                                                              context: context);
                                                        },
                                                        accountModel: item,
                                                        isLastItem: cateItem
                                                                .accounts!
                                                                .length ==
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
                            viewModel.dataShared.categoryListForFilterBar,
                            viewModel.categorySelected,
                            builder: (context, listCate, cateSelected, child) {
                              listCate = [
                                CategoryModel(id: "-1", name: Strings.all),
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
                                        color: cateSelected.id ==
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
