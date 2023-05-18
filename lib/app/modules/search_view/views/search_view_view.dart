import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/theme/style.dart';
import '../../../../core/tour_maker_icons.dart';
import '../../../data/models/local_model/recent_search_mode.dart';
import '../../../data/models/network_models/package_model.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_loadinscreen.dart';
import '../controllers/search_view_controller.dart';

class SearchViewView extends GetView<SearchViewController> {
  const SearchViewView({super.key});
  @override
  Widget build(BuildContext context) {
    final SearchViewController controller = Get.find();
    return Scaffold(
        appBar: CustomAppBar(
          isBack: false,
          title: buildTextField(),
        ),
        body: controller.obx(
          onLoading: const CustomLoadingScreen(),
          (SearchViewView? state) => Obx(() {
            return SingleChildScrollView(
              child: RefreshIndicator(
                color: englishViolet,
                onRefresh: controller.loadRecentSearchesFromStorage,
                child: controller.recentSearchesList.isEmpty
                    ? Column(
                        children: [
                          const SizedBox(height: 10),
                          ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(indent: 30, endIndent: 50),
                            shrinkWrap: true,
                            itemCount: controller.packagesList.length,
                            itemBuilder: (BuildContext context, int index) {
                              final PackageModel package =
                                  controller.packagesList[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 2,
                                ),
                                child: ListTile(
                                  dense: true,
                                  title: Text(package.destination.toString(),
                                      style: subheading1),
                                  onTap: () => controller.onSubmitSearch(
                                      package.destination.toString()),
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    : Column(
                        children: <Widget>[
                          const SizedBox(height: 10),
                          ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(indent: 30, endIndent: 50),
                            shrinkWrap: true,
                            itemCount: controller.recentSearchesList.length,
                            itemBuilder: (BuildContext context, int index) {
                              final RecentSearch search =
                                  controller.recentSearchesList[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 2,
                                ),
                                child: ListTile(
                                  dense: true,
                                  title: Text(
                                    search.keyword,
                                    style: subheading1.copyWith(
                                      color: englishlinearViolet,
                                    ),
                                  ),
                                  trailing: GestureDetector(
                                    onTap: () => controller
                                        .onClickDeleteSuggestion(index),
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color: englishViolet,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.close_sharp,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () =>
                                      controller.onSubmitSearch(search.keyword),
                                ),
                              );
                            },
                          ),
                          const Divider(),
                          ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(indent: 30, endIndent: 50),
                            shrinkWrap: true,
                            itemCount: controller.packagesList.length,
                            itemBuilder: (BuildContext context, int index) {
                              final PackageModel package =
                                  controller.packagesList[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 2,
                                ),
                                child: ListTile(
                                  dense: true,
                                  title: Text(package.destination.toString(),
                                      style: subheading1),
                                  onTap: () => controller.onSubmitSearch(
                                      package.destination.toString()),
                                ),
                              );
                            },
                          )
                        ],
                      ),
              ),
            );
          }),
        ));
  }

  Widget buildTextField() {
    return Container(
      height: 50,
      width: 100.w,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        onChanged: (String text) => controller.onSerchTextChanged(text),
        controller: controller.textController,
        textInputAction: TextInputAction.search,
        onSubmitted: (String value) => controller.onSubmitSearch(value),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 23, top: 15),
          border: InputBorder.none,
          hintText: '  Search Destinations',
          prefixIcon: Icon(
            TourMaker.search,
            color: englishViolet,
            size: 33,
          ),
          suffixIcon: IconButton(
            constraints: const BoxConstraints(),
            onPressed: () => controller.onClickClearTextfIeld(),
            icon: Icon(Icons.close_rounded, color: englishlinearViolet),
          ),
        ),
      ),
    );
  }
}
