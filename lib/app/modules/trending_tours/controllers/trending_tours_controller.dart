import 'package:get/get.dart';

import '../../../data/models/network_models/single_trenidng_tour_model.dart';
import '../../../data/models/network_models/wishlist_model.dart';
import '../../../data/repo/network_repo/trending_tours_rep.dart';
import '../../../data/repo/network_repo/wishlist_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';
import '../../../widgets/custom_dialogue.dart';
import '../views/trending_tours_view.dart';

class TrendingToursController extends GetxController
    with StateMixin<TrendingToursView> {
  RxList<SingleTrendingToursModel> singleTour =
      <SingleTrendingToursModel>[].obs;
  RxList<WishListModel> wishList = <WishListModel>[].obs;
  String? destination;
  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    await getData();
    await getWishList();
  }

  Future<void> loadSingleTrendingTours(String? destination) async {
    final ApiResponse<List<SingleTrendingToursModel>> res =
        await TrendingToursRepository().getSingleTrendingTours(destination!);
    if (res.data != null) {
      singleTour.value = res.data!;
      change(null, status: RxStatus.success());
    } else {
      change(null, status: RxStatus.empty());
    }
  }

  void onClickSingleTour(int i) {
    Get.toNamed(Routes.SINGLE_TOUR, arguments: <int>[i])!
        .whenComplete(() => loadData());
  }

  Future<void> getData() async {
    change(null, status: RxStatus.loading());
    if (Get.arguments != null) {
      destination = Get.arguments as String;
      await loadSingleTrendingTours(destination);
    }
  }

  Future<void> getWishList() async {
    final ApiResponse<dynamic> res = await WishListRepo().getAllFav();
    if (res.status == ApiResponseStatus.completed) {
      wishList.value = res.data! as List<WishListModel>;
    }
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
        final SingleTrendingToursModel package = singleTour.firstWhere(
            (SingleTrendingToursModel package) => package.id == productId);
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
}
