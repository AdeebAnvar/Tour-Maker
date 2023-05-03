// ignore_for_file: strict_raw_type, always_specify_types

import 'dart:developer';

import 'package:get/get.dart';

import '../../../data/models/network_models/package_model.dart';
import '../../../data/models/network_models/wishlist_model.dart';
import '../../../data/repo/network_repo/package_repository.dart';
import '../../../data/repo/network_repo/wishlist_repo.dart';
import '../../../routes/app_pages.dart';
import '../views/favourites_screen_view.dart';

class FavouritesScreenController extends GetxController
    with StateMixin<FavouritesScreenView> {
  RxList<WishListModel> favouritesList = <WishListModel>[].obs;
  RxList<PackageModel> packageList = <PackageModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    loadData();
    log('loghdbhabsc ');
  }

  Future<void> loadData() async {
    change(null, status: RxStatus.loading());
    await getAllFavourites();
    await getAllPackages();
  }

  Future<void> getAllFavourites() async {
    final res = await WishListRepo().getAllFav();
    log('ihdiv getAllFav ${res.message}');
    if (res.data != null) {
      favouritesList.value = res.data!;
      change(null, status: RxStatus.success());
    } else {
      change(null, status: RxStatus.empty());
    }
  }

  Future<void> getAllPackages() async {
    final res = await PackageRepository().getAllPackages();
    if (res.data != null) {
      packageList.value = res.data!;
    }
  }

  Future<void> toggleFavorite(int productId) async {
    log('kumbalangi  toggled');
    try {
      final bool isInWishList =
          packageList.any((PackageModel package) => package.id == productId);
      if (isInWishList) {
        await WishListRepo().deleteFav(productId);
        packageList
            .removeWhere((PackageModel package) => package.id == productId);
        log('kumbalangi isinWishlist =true ');
      } else {
        await WishListRepo().createFav(productId);
        final WishListModel wishList = favouritesList
            .firstWhere((WishListModel wishList) => wishList.id == productId);
        final PackageModel pckg = PackageModel(
          id: wishList.id,
          name: wishList.name,
          // add any other properties that are required for the wishlist item
        );
        packageList.add(pckg);

        log('kumbalangi  isinwishlist nott true');
      }
    } catch (e) {
      log('kumbalangi  Error toggling favorite: $e');
    }
  }

  RxBool isFavorite(int productId) {
    return RxBool(packageList.any((pckg) => pckg.id == productId));
  }

  Future<void> onSingleTourPressed(int id) async {
    Get.toNamed(Routes.SINGLE_TOUR, arguments: <int>[id])!
        .whenComplete(() => loadData());
  }
}
