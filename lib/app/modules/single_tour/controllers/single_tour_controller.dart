import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
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
  // late final TabController tabcontroller =
  //     TabController(length: 2, vsync: this);
  final GetStorage getStorage = GetStorage();
  late int totalAmount;
  late Razorpay razorPay;
  final RxInt selectedDateIndex = 0.obs;
  final RxList<int> favorites = <int>[].obs;
  Rx<SingleTourModel> singleTour = SingleTourModel().obs;
  Rx<SingleTourModel> batchTours = SingleTourModel().obs;
  RxList<WishListModel> wishlists = <WishListModel>[].obs;
  Logger logger = Logger();
  Rx<int> selectedIndex = 0.obs;
  Rx<int> selectDate = 0.obs;
  Rx<int> selectedBatchIndex = 0.obs;
  Rx<int> adult = 1.obs;
  Rx<int> children = 0.obs;
  Rx<bool> isLoading = false.obs;
  Rx<bool> isFavourite = false.obs;
  Rx<String> selectedDate = ' '.obs;
  Rx<String> formattedDate = ''.obs;
  int? tourID;
  int? order;
  String? currentUserAddress;
  String? currentUserCategory;
  @override
  Future<void> onInit() async {
    super.onInit();
    log('htybhhb init');
    await fetchData();
    // await getStorage.remove('currentUserAddress');
    currentUserAddress = await getStorage.read('currentUserAddress') as String;
    currentUserCategory =
        await getStorage.read('currentUserCategory') as String;
    log('useradress $currentUserAddress');
    log('uscurrentUserCategory $currentUserCategory');
    final String currentUserPoneNumber =
        await getStorage.read('currentUserPhoneNumber') as String;
    log('dfghfgfdfaghfds $currentUserPoneNumber');
  }

  Future<void> fetchData() async {
    change(null, status: RxStatus.loading());
    try {
      final int id = await loadData();
      singleTour.value = await loadIndividualTours(id);
      batchTours.value = await loadSingleTourData(id);
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
      change(null, status: RxStatus.success());
    } catch (er) {
      // logger.e('adee e message');
      // logger.i('adee i message');
      // logger.wtf('adee wrf message');
      change(null, status: RxStatus.error(er.toString()));
      // logger.d('adee d $er message');
      throw Exception('failed to load fetch data $er');
    }
  }

  Future<int> loadData() async {
    if (Get.arguments != null) {
      tourID = Get.arguments[0] as int;
      return tourID!;
    }
    return tourID!;
  }

  Future<SingleTourModel> loadSingleTourData(int tourID) async {
    try {
      final ApiResponse<SingleTourModel> res =
          await SingleTourRepository().getSingleTour(tourID);
      log('kdgknjdf msg ${res.message}');
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

  Future<SingleTourModel> loadIndividualTours(int tourID) async {
    final ApiResponse<SingleTourModel> res =
        await SingleTourRepository().getSingleTourIndividual(tourID);
    log('kdgknjdf msg ${res.message}');

    if (res.data != null) {
      return res.data!;
    } else {
      throw Exception('Failed to load batch tour data');
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

  // void onTapFixedDeparture() {
  //   tabcontroller.animateTo(1);
  // }

  // void onTapCustomDeparture() {
  //   tabcontroller.animateTo(1);
  // }

  void onDateSelected(int index) {
    selectedDateIndex.value = index;
    final DateTime inputDate =
        DateTime.parse('${singleTour.value.packageData?[index].dateOfTravel}');
    final DateFormat outputFormat = DateFormat('MMM d');
    final String formattedDate = outputFormat.format(inputDate);
    selectedDate.value = formattedDate;
  }

  Future<void> onViewItineraryClicked(String itinerary) async {
    // change(null, status: RxStatus.loading());
    // try {
    //   log('hihhihih $itinerary.pdf');
    //   launchUrl(Uri.parse(itinerary));
    // } catch (e) {
    //   log('hihhihih $e');
    //   change(null, status: RxStatus.error(e.toString()));
    // }
    // change(null, status: RxStatus.success());
    Get.toNamed(Routes.PDF_VIEW, arguments: <String>[itinerary]);
  }

  void onClickAdultSubtract() {
    if (adult.value > 1) {
      adult.value--;
    }

    log(adult.value.toString());
  }

  void onClickAdultAdd() {
    adult.value++;

    log(adult.value.toString());
  }

  void onClickSubtractChildren() {
    if (children.value > 0) {
      children.value--;
    }

    log(children.value.toString());
  }

  void onClickAddChildren() {
    children.value++;
    log(children.value.toString());
  }

  Future<void> onClickAddPassenger(PackageData package) async {
    if (currentUserAddress != null) {
      final DateTime sd = DateTime.parse(package.dateOfTravel.toString());
      final DateTime today = DateTime.now();
      if (sd.difference(today).inDays <= 7) {
        CustomDialog().showCustomDialog('Warning ! !',
            'The selected date is very near \nso you need to pay full amount and\n you have to contact and confirm the tour',
            onConfirm: () async {
          await confirmPayment(package.iD!, package);
          Get.back();
        }, onCancel: () async {
          Get.back();
        }, confirmText: 'OK', cancelText: 'back');
      } else {
        await confirmPayment(package.iD!, package);
      }
    } else {
      log('fsgsfdv $currentUserAddress');
      await Get.toNamed(Routes.USER_REGISTERSCREEN)!
          .whenComplete(() => loadData());
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
      log('kunukunnu single tour $order');

      order = resp.data as int;
      log('success $order');
      return order!;
    } else {
      log('not fno');
    }
    return order;
  }

  Future<void> onClickAddToFavourites() async {
    try {
      if (isFavourite.value == true) {
        log('Removing tour from favorites...');
        final ApiResponse<Map<String, dynamic>> res =
            await WishListRepo().deleteFav(singleTour.value.tourData?.iD);
        if (res.status == ApiResponseStatus.completed) {
          log('Tour removed from favorites.');
          isFavourite.value = false;
        } else {
          log('Failed to remove tour from favorites.');
        }
      } else {
        log('Adding tour to favorites...');
        final ApiResponse<Map<String, dynamic>> res =
            await WishListRepo().createFav(singleTour.value.tourData?.iD);
        if (res.status == ApiResponseStatus.completed) {
          log('Tour added to favorites.');
          isFavourite.value = true;
        } else {
          log('Failed to add tour to favorites.');
        }
      }
    } catch (e) {
      log('Error while updating favorites: $e');
    }
  }

  String convertDates(String date) {
    final DateTime inputDate = DateTime.parse(date);
    final DateFormat outputFormat = DateFormat('d MMM yy');
    final String formattedDate = outputFormat.format(inputDate);
    return formattedDate;
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
    // ignore: non_constant_identifier_names
    totalAmount = totalAdultAmount + totalChildrensAmount;

    return totalAmount;
  }

  Future<void> onCallClicked() async {
    final Uri url = Uri.parse('tel:914872383104');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      log('Could not launch $url');
    }
  }

  Future<void> onWhatsAppClicked() async {
    const String phone =
        '+918606131909'; // Replace with the phone number you want to chat with
    const String message =
        'Hi'; // Replace with the initial message you want to send
    final String url = 'https://wa.me/$phone?text=${Uri.encodeFull(message)}';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
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
        tourID: singleTour.value.tourData?.iD,
        kidsAmount: packageData.kidsAmount,
        kidsOfferAmount: packageData.kidsOfferAmount,
        offerAmount: packageData.offerAmount,
        orderID: order,
        tourCode: singleTour.value.tourData?.tourCode,
        tourItinerary: singleTour.value.tourData?.itinerary,
        tourName: singleTour.value.tourData?.name,
        transportationMode: packageData.transportationMode,
        advanceAmount: packageData.advanceAmount,
      );
      try {
        await CheckOutRepositoy.saveData(cm);
        log(' Data saved successfully');
      } catch (e) {
        log('Error saving data: $e');
      }
      final int passengers = totaltravellers();
      Get.toNamed(Routes.ADD_PASSENGER,
          arguments: <dynamic>[order, passengers]);
    } else {
      CustomDialog().showCustomDialog('Order Not Placed',
          "Sorry your order didn't placed from our side . please order again");
    }
    log('kunukunnu confirm single tour $order');
    isLoading.value = false;
  }

  int totaltravellers() {
    final int sum = adult.value + children.value;
    return sum;
  }
}
