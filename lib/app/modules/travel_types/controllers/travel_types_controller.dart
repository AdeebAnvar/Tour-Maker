import 'package:get/get.dart';

import '../../../data/models/network_models/single_traveltypes_model.dart';
import '../../../data/models/network_models/wishlist_model.dart';
import '../../../data/repo/network_repo/traveltypes_repo.dart';
import '../../../data/repo/network_repo/wishlist_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';
import '../../../widgets/custom_dialogue.dart';
import '../views/travel_types_view.dart';

class TravelTypesController extends GetxController
    with StateMixin<TravelTypesView> {
  String? destination;
  RxList<SingleTravelTypesTourModel> singleTour =
      <SingleTravelTypesTourModel>[].obs;
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

  Future<void> loadTours(String categoryName, {int page = 1}) async {
    try {
      final ApiResponse<List<SingleTravelTypesTourModel>> res =
          await TravelTypesRepository()
              .getSingleTravelTypesTours(destination!, page);
      if (res.status == ApiResponseStatus.completed) {
        final List<SingleTravelTypesTourModel> newData = res.data!;
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
        final SingleTravelTypesTourModel package = singleTour.firstWhere(
            (SingleTravelTypesTourModel package) => package.id == productId);
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

  void loadMore() {
    final int nextPage = page + 1;
    loadTours(destination!, page: nextPage);
  }

  RxBool isFavorite(int productId) =>
      RxBool(wishList.any((WishListModel package) => package.id == productId));

  void onClickSingleTour(int id) =>
      Get.toNamed(Routes.SINGLE_TOUR, arguments: <int>[id])!
          .whenComplete(() => loadData());
}
