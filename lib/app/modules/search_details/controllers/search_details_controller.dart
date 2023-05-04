import 'package:get/get.dart';

import '../../../data/models/network_models/package_model.dart';
import '../../../data/models/network_models/wishlist_model.dart';
import '../../../data/repo/network_repo/filter_repo.dart';
import '../../../data/repo/network_repo/wishlist_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';
import '../../../widgets/custom_dialogue.dart';
import '../views/search_details_view.dart';

class SearchDetailsController extends GetxController
    with StateMixin<SearchDetailsView> {
  String? destinationValue;
  RxList<PackageModel> destinations = <PackageModel>[].obs;
  Rx<bool> isClickedFavorites = false.obs;
  RxList<WishListModel> wishList = <WishListModel>[].obs;
  Rx<bool> isHaveOffer = true.obs;
  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    change(null, status: RxStatus.loading());
    if (Get.arguments != null) {
      destinationValue = Get.arguments as String;
      await getData(destinationValue);
      await getWishList();
    } else {}
  }

  Future<void> getWishList() async {
    final ApiResponse<dynamic> res = await WishListRepo().getAllFav();
    if (res.data != null) {
      wishList.value = res.data! as List<WishListModel>;
    } else {}
  }

  Future<void>? onClickFilter() =>
      Get.toNamed(Routes.FILTER_SCREEN)!.whenComplete(() => loadData());

  void onClickFavourites(PackageModel pckg) {
    if (isClickedFavorites.value == true) {
      isClickedFavorites.value = false;
    } else {
      isClickedFavorites.value = true;
    }
  }

  void onSingleTourPressed(int id) {
    Get.toNamed(Routes.SINGLE_TOUR, arguments: <int>[id])!
        .whenComplete(() => loadData());
  }

  Future<void> getData(String? destinationValue) async {
    try {
      final ApiResponse<List<PackageModel>> res =
          await FilterRepository().getDestination(destinationValue.toString());
      if (res.status == ApiResponseStatus.completed) {
        destinations.value = res.data!;
        change(null, status: RxStatus.success());
      } else {
        change(null, status: RxStatus.empty());
      }
    } catch (e) {
      CustomDialog().showCustomDialog('Error !', e.toString());
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
        final PackageModel package = destinations
            .firstWhere((PackageModel package) => package.id == productId);
        final WishListModel wishlistItem = WishListModel(
          id: package.id,
          name: package.name,
          // add any other properties that are required for the wishlist item
        );
        wishList.add(wishlistItem);
      }
    } catch (e) {
      CustomDialog().showCustomDialog('Error !', e.toString());
    }
  }

  RxBool isFavorite(int productId) =>
      RxBool(wishList.any((WishListModel package) => package.id == productId));
}
