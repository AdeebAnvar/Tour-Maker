// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../data/models/local_model/checkout_model.dart';
import '../../../data/models/network_models/order_model.dart';
import '../../../data/models/network_models/single_tour_model.dart';
import '../../../data/models/network_models/wishlist_model.dart';
import '../../../data/repo/local_repo/checkout_repo.dart';
import '../../../data/repo/network_repo/passenger_repo.dart';
import '../../../data/repo/network_repo/singletourrepo.dart';
import '../../../data/repo/network_repo/wishlist_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';
import '../../../widgets/custom_dialogue.dart';
import '../views/single_tour_view.dart';

class SingleTourController extends GetxController
    with StateMixin<SingleTourView> {
  final GetStorage getStorage = GetStorage();
  late int totalAmount;
  final RxInt selectedDateIndex = 0.obs;
  RxList<PackageData> singleTours = <PackageData>[].obs;
  List<PackageData> singleTour = <PackageData>[];
  Rx<SingleTourModel> batchTours = SingleTourModel().obs;
  RxList<WishListModel> wishlists = <WishListModel>[].obs;
  Rx<int> selectedIndex = 0.obs;
  Rx<int> selectedBatchIndex = 0.obs;
  Rx<int> adult = 1.obs;
  Rx<int> children = 0.obs;
  Rx<bool> isLoading = false.obs;
  Rx<bool> isFavourite = false.obs;
  int? tourID;
  int? order;
  String? currentUserAddress;
  String? currentUserCategory;
  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchData();
  }

  Future<void> fetchData() async {
    change(null, status: RxStatus.loading());
    await datasFromLocalStorage();
    try {
      final int id = await loadData();
      singleTours.value = await loadCustomDeparturesTours(id);
      singleTour = await loadCustomDeparturesTours(id);
      batchTours.value = await loadFixedTourData(id);
      await loadWishLists(id);
      change(null, status: RxStatus.success());
    } catch (er) {
      CustomDialog().showCustomDialog('Error !', contentText: er.toString());
    }
  }

  Future<int> loadData() async {
    if (Get.arguments != null) {
      tourID = Get.arguments[0] as int;
      return tourID!;
    }
    return tourID!;
  }

  Future<SingleTourModel> loadFixedTourData(int tourID) async {
    try {
      final ApiResponse<SingleTourModel> res =
          await SingleTourRepository().getSingleTour(tourID);
      if (res.data != null) {
        return res.data!;
      } else {
        throw Exception('Failed to load single tour data: empty response');
      }
    } catch (e) {
      throw Exception(
          'Failed to fetch single tour data for tour ID $tourID: $e');
    }
  }

  Future<List<PackageData>> loadCustomDeparturesTours(int tourID) async {
    try {
      final ApiResponse<SingleTourModel> res =
          await SingleTourRepository().getSingleTourIndividual(tourID);
      log('Adeeb controll data ${res.data}');
      log('Adeeb controll message ${res.message}');
      log('Adeeb controll status ${res.status}');
      if (res.data != null) {
        final SingleTourModel customDepartureToures = res.data!;
        return customDepartureToures.packageData!;
      } else {
        throw Exception('Failed to load indivdual tour data');
      }
    } catch (e) {
      throw Exception(
          'Failed to fetch single tour data for tour ID $tourID: $e');
    }
  }

  Future<List<WishListModel>?> getWishList(int id) async {
    final ApiResponse<dynamic> res = await WishListRepo().getAllFav();
    if (res.status == ApiResponseStatus.completed) {
      if (res.data != null) {
        final List<WishListModel> wishListData =
            res.data! as List<WishListModel>;
        return wishListData;
      }
      return null;
    } else {
      throw Exception('Failed to load wishlist data');
    }
  }

  void onSerchDateChanged(String text) {
    if (text.isNotEmpty) {
      singleTours.value = singleTour
          .where(
            (PackageData package) => package.dateOfTravel!.contains(
              text,
            ),
          )
          .toList();
    } else {
      singleTours.value = singleTour;
    }
  }

  Future<void> onViewItineraryClicked(String itinerary) async =>
      Get.toNamed(Routes.PDF_VIEW, arguments: <String>[itinerary]);

  void onClickAdultSubtract() {
    if (adult.value > 1) {
      adult.value--;
    }
  }

  void onClickAdultAdd() {
    adult.value++;
  }

  void onClickSubtractChildren() {
    if (children.value > 0) {
      children.value--;
    }
  }

  void onClickAddChildren() {
    children.value++;
  }

  Future<void> onClickAddPassenger(PackageData package) async {
    if (currentUserAddress != null && currentUserAddress != '') {
      final DateTime selectedDate =
          DateTime.parse(package.dateOfTravel.toString());
      final DateTime today = DateTime.now();
      if (package.availableSeats == package.totalSeats) {
        CustomDialog().showCustomDialog(
          'Seats Filled!!',
          contentText:
              "Sorry the seat's are filled in this tour .  we will reach out you soon when the seats are available",
        );
      } else {
        if (selectedDate.difference(today).inDays <= 7) {
          await showWarningDialogue(package);
        } else {
          await confirmPayment(package.iD!, package);
        }
      }
    } else {
      await Get.toNamed(Routes.USER_REGISTERSCREEN)!
          .whenComplete(() => fetchData());
    }
  }

  Future<int?> createUserOrder(int packageID, PackageData package) async {
    final OrderModel om = OrderModel(
      noOfAdults: adult.value,
      noOfChildren: children.value,
      packageID: packageID,
    );
    final ApiResponse<dynamic> resp = await PassengerRepository().addOrder(om);
    if (resp.data != null) {
      order = resp.data as int;
      return order!;
    } else {}
    return order;
  }

  Future<void> onClickAddToFavourites() async {
    try {
      if (isFavourite.value == true) {
        await _deleteFromFav();
      } else {
        await _addToFav();
      }
    } catch (e) {
      CustomDialog().showCustomDialog('Error !', contentText: e.toString());
    }
  }

  int getTotalAmountOFtour(
      int adultCount, int childcount, PackageData packageData, int index) {
    int adultAmount;
    int childAmount;
    packageData.offerAmount == 0
        ? adultAmount = packageData.amount!
        : adultAmount = packageData.offerAmount!;
    packageData.kidsOfferAmount != 0
        ? childAmount = packageData.kidsOfferAmount!
        : childAmount = packageData.kidsAmount!;
    final int totalAdultAmount = adultCount * adultAmount;
    final int totalChildrensAmount = childcount * childAmount;
    totalAmount = totalAdultAmount + totalChildrensAmount;

    return totalAmount;
  }

  Future<void> onCallClicked() async {
    final Uri url = Uri.parse('tel:914872383104');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      CustomDialog().showCustomDialog('Error !',
          contentText: "couldn't dial to 4872383104");
    }
  }

  Future<void> onWhatsAppClicked() async {
    const String phone =
        '+918606131909'; // Replace with the phone number you want to chat with
    const String message =
        'Hi'; // Replace with the initial message you want to send
    final String url = 'https://wa.me/$phone?text=${Uri.encodeFull(message)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Get.snackbar('Error', 'Could not launch WhatsApp');
    }
  }

  Future<void> confirmPayment(int packageID, PackageData packageData) async {
    isLoading.value = true;
    order = await createUserOrder(packageID, packageData);
    if (order != null) {
      final CheckOutModel cm = CheckOutModel(
        adultCount: adult.value,
        amount: packageData.amount,
        childrenCount: children.value,
        commission: packageData.agentCommission,
        dateOfTravel: packageData.dateOfTravel,
        gst: packageData.gstPercent,
        tourID: batchTours.value.tourData?.iD,
        kidsAmount: packageData.kidsAmount,
        kidsOfferAmount: packageData.kidsOfferAmount,
        offerAmount: packageData.offerAmount,
        orderID: order,
        tourCode: batchTours.value.tourData?.tourCode,
        tourItinerary: batchTours.value.tourData?.itinerary,
        tourName: batchTours.value.tourData?.name,
        transportationMode: packageData.transportationMode,
        advanceAmount: packageData.advanceAmount,
      );
      try {
        await CheckOutRepositoy.saveData(cm);
      } catch (e) {
        CustomDialog().showCustomDialog('Error !', contentText: e.toString());
      }
      final int passengers = totaltravellers();
      Get.toNamed(Routes.ADD_PASSENGER,
          arguments: <dynamic>[order, passengers]);
    } else {
      CustomDialog().showCustomDialog('Order Not Placed',
          contentText:
              "Sorry your order $order didn't placed from our side . please order again");
    }
    isLoading.value = false;
  }

  int totaltravellers() {
    final int sum = adult.value + children.value;
    return sum;
  }

  Future<void> datasFromLocalStorage() async {
    currentUserAddress = await getStorage.read('currentUserAddress') as String;
    currentUserCategory =
        await getStorage.read('currentUserCategory') as String;
    log('Adeeb $currentUserAddress');
    log('Adeeb $currentUserCategory');
  }

  Future<void> loadWishLists(int id) async {
    final List<WishListModel>? wishlistData = await getWishList(id);
    if (wishlistData != null) {
      wishlists.value = wishlistData;

      for (final WishListModel wm in wishlists) {
        if (wm.id == id) {
          isFavourite.value = true;
          break;
        } else {
          isFavourite.value = false;
        }
      }
    }
  }

  Future<void> showWarningDialogue(PackageData package) async {
    await CustomDialog().showCustomDialog('Warning ! !',
        contentText:
            'The selected date is very near \nso you need to pay full amount and\n you have to contact and confirm the tour',
        onConfirm: () async {
      Get.back();
      await confirmPayment(package.iD!, package);
    }, onCancel: () async {
      Get.back();
    }, confirmText: 'OK', cancelText: 'back');
  }

  Future<void> _deleteFromFav() async {
    try {
      final ApiResponse<Map<String, dynamic>> res =
          await WishListRepo().deleteFav(batchTours.value.tourData?.iD);
      if (res.status == ApiResponseStatus.completed) {
        isFavourite.value = false;
      }
    } catch (e) {
      CustomDialog().showCustomDialog("Can't Delete From favourites",
          contentText: e.toString());
    }
  }

  Future<void> _addToFav() async {
    try {
      final ApiResponse<Map<String, dynamic>> res =
          await WishListRepo().createFav(batchTours.value.tourData?.iD);
      if (res.status == ApiResponseStatus.completed) {
        isFavourite.value = true;
      }
    } catch (e) {
      CustomDialog()
          .showCustomDialog("Can't Add to fav", contentText: e.toString());
    }
  }
}
