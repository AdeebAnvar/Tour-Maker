import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/theme/style.dart';
import '../../../data/models/network_models/package_model.dart';
import '../../../data/models/network_models/wishlist_model.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_errorscreen.dart';
import '../../../widgets/custom_loadinscreen.dart';
import '../../../widgets/package_tile.dart';
import '../controllers/single_category_controller.dart';

class SingleCategoryView extends GetView<SingleCategoryController> {
  const SingleCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final SingleCategoryController controller =
        Get.put(SingleCategoryController());
    final ScrollController scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        controller.loadMore();
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(),
      body: controller.obx(
        onLoading: const CustomLoadingScreen(),
        onEmpty: const Center(
          child: Text('No Packages Found '),
        ),
        onError: (String? error) => CustomErrorScreen(
          errorText: 'Error occurred: $error',
        ),
        (SingleCategoryView? state) => RefreshIndicator(
          onRefresh: controller.loadData,
          color: englishViolet,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            child: Column(
              children: <Widget>[
                Obx(() => CachedNetworkImage(
                      imageUrl: controller.categoryImage.value.isEmpty
                          ? 'https://images.unsplash.com/photo-1589802829985-817e51171b92?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8Nnx8fGVufDB8fHx8&w=1000&q=80'
                          : controller.categoryImage.value,
                      imageBuilder: (BuildContext context,
                              ImageProvider<Object> imageProvider) =>
                          Container(
                        width: double.infinity,
                        height: 35.h,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // child: Center(
                        //   child: Text(
                        //     controller.categoryName.value,
                        //     style: const TextStyle(
                        //       fontFamily: 'Tahu',
                        //       fontSize: 50,
                        //       color: Colors.white,
                        //     ),
                        //   ),
                        // ),
                      ),
                    )),
                Obx(() {
                  return ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.packageList.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == controller.packageList.length) {
                        // Reached the end of the list, show the loading indicator
                        return const Padding(
                          padding: EdgeInsets.zero,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.transparent,
                            ),
                          ),
                        );
                      } else {
                        final PackageModel package =
                            controller.packageList[index];
                        for (final WishListModel wm in controller.wishList) {
                          if (wm.id == controller.packageList[index].id) {
                            controller.isFavorite(package.id!).value = true;
                          } else {
                            controller.isFavorite(package.id!).value = false;
                          }
                        }
                        return Obx(() {
                          return PackageTile(
                            tourAmount: package.amount.toString(),
                            tourCode: package.tourCode.toString(),
                            tourDays: package.days.toString(),
                            tourImage: package.image.toString(),
                            tourName: package.name.toString(),
                            tournights: package.nights.toString(),
                            isFavourite:
                                controller.isFavorite(package.id!).value,
                            onClickedFavourites: () =>
                                controller.toggleFavorite(package.id!),
                            onPressed: () =>
                                controller.onSingleTourPressed(package),
                          );
                        });
                      }
                    },
                  );
                }),
                Obx(
                  () => controller.hasReachedEnd.value
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Column(
                            children: <Widget>[
                              const Divider(indent: 70, endIndent: 70),
                              Text('You Are All Caught Up', style: subheading1),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: englishViolet,
                            ),
                          ),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
