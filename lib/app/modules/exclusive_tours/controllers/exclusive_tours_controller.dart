import 'package:get/get.dart';

import '../../../data/models/network_models/single_exclusive_tour_model.dart';
import '../../../data/models/network_models/wishlist_model.dart';
import '../../../data/repo/network_repo/exclusive_repo.dart';
import '../../../data/repo/network_repo/wishlist_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';
import '../../../widgets/custom_dialogue.dart';
import '../views/exclusive_tours_view.dart';

class ExclusiveToursController extends GetxController
    with StateMixin<ExclusiveToursView> {
  String? destination;
  RxList<SingleExclusiveTourModel> singleTour =
      <SingleExclusiveTourModel>[].obs;
  RxList<WishListModel> wishList = <WishListModel>[].obs;
  int page = 1;
  bool isLoading = false;
  RxBool hasReachedEnd = false.obs;
  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    if (singleTour.isNotEmpty) {
      singleTour.clear();
    }
    await getData();
    await getWishList();
  }

  Future<void> loadTours(String destination, {int page = 1}) async {
    final ApiResponse<List<SingleExclusiveTourModel>> res =
        await ExclusiveTourRepository()
            .getAllSingleExclusiveTours(destination, page);
    try {
      if (res.status == ApiResponseStatus.completed) {
        final List<SingleExclusiveTourModel> newData = res.data!;
        if (newData.isNotEmpty) {
          singleTour.addAll(newData);
          this.page = page;
          if (newData.length < 10) {
            hasReachedEnd.value = true;
          }
        } else {
          hasReachedEnd.value = true;
          // Empty response, indicating end of data
        }
      } else {
        // Error response
      }
    } catch (e) {
      // Exception occurred
    }
  }

  void loadMore() {
    final int nextPage = page + 1;
    loadTours(destination!, page: nextPage);
  }

  Future<void> getData() async {
    change(null, status: RxStatus.loading());
    if (Get.arguments != null) {
      destination = Get.arguments as String;
      await loadTours(destination!);
    }
  }

  Future<void> getWishList() async {
    final ApiResponse<dynamic> res = await WishListRepo().getAllFav();
    if (res.status == ApiResponseStatus.completed) {
      wishList.value = res.data! as List<WishListModel>;
      change(null, status: RxStatus.success());
    } else {}
  }

  Future<void> toggleFavorite(int productId) async {
    try {
      final bool isInWishList =
          wishList.any((WishListModel package) => package.id == productId);
      if (isInWishList) {
        await WishListRepo().deleteFav(productId);
        wishList
            .removeWhere((WishListModel package) => package.id == productId);
      } else {
        await WishListRepo().createFav(productId);
        // final PackageModel package = singleCategoryList
        //     .firstWhere((PackageModel package) => package.id == productId);
        // wishlists.add(package as WishListModel);
        final SingleExclusiveTourModel package = singleTour.firstWhere(
            (SingleExclusiveTourModel package) => package.id == productId);
        final WishListModel wishlistItem = WishListModel(
          id: package.id,
          name: package.name,
          // add any other properties that are required for the wishlist item
        );
        wishList.add(wishlistItem);
      }
    } catch (e) {
      CustomDialog().showCustomDialog('Error !', contentText: e.toString());
    }
  }

  RxBool isFavorite(int productId) =>
      RxBool(wishList.any((WishListModel package) => package.id == productId));

  void onClickSingleTour(int id) {
    Get.toNamed(Routes.SINGLE_TOUR, arguments: <int>[id])!
        .whenComplete(() => loadData());
  }
}
