import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../core/theme/style.dart';
import '../../../data/models/network_models/single_exclusive_tour_model.dart';
import '../../../data/models/network_models/wishlist_model.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_errorscreen.dart';
import '../../../widgets/custom_loadinscreen.dart';
import '../../../widgets/package_tile.dart';
import '../controllers/exclusive_tours_controller.dart';

class ExclusiveToursView extends GetView<ExclusiveToursController> {
  const ExclusiveToursView({super.key});
  @override
  Widget build(BuildContext context) {
    final ExclusiveToursController controller =
        Get.put(ExclusiveToursController());
    final ScrollController scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        controller.loadMore();
      }
    });

    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Exclusive Tours'),
      ),
      body: controller.obx(
        onEmpty: const CustomErrorScreen(errorText: 'Nothing found Here'),
        onLoading: const CustomLoadingScreen(),
        (dynamic state) => controller.singleTour.isEmpty
            ? const CustomErrorScreen(errorText: 'Nothing found Here')
            : RefreshIndicator(
                color: englishViolet,
                onRefresh: controller.loadData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: scrollController,
                  child: Column(
                    children: <Widget>[
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.singleTour.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == controller.singleTour.length) {
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
                            final SingleExclusiveTourModel package =
                                controller.singleTour[index];
                            for (final WishListModel wm
                                in controller.wishList) {
                              if (wm.id == controller.singleTour[index].id) {
                                controller.isFavorite(package.id!).value = true;
                              } else {
                                controller.isFavorite(package.id!).value =
                                    false;
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
                                    controller.onClickSingleTour(package.id!),
                              );
                            });
                          }
                        },
                      ),
                      Obx(
                        () => controller.hasReachedEnd.value
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15.0),
                                child: Column(
                                  children: <Widget>[
                                    const Divider(indent: 70, endIndent: 70),
                                    Text('You Are All Caught Up',
                                        style: subheading1),
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
