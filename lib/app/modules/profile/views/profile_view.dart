import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/theme/style.dart';
import '../../../../core/tour_maker_icons.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_errorscreen.dart';
import '../../../widgets/custom_loadinscreen.dart';
import '../../../widgets/my_drawer.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    return Scaffold(
        drawer: Obx(() {
          return MyDrawer(controller: controller.userData.value);
        }),
        appBar: const CustomAppBar(
          title: Text('Profile'),
        ),
        body: controller.obx(
          onError: (String? e) =>
              CustomErrorScreen(errorText: '$e', onRefresh: controller.getData),
          onLoading: const CustomLoadingScreen(),
          (ProfileView? state) => RefreshIndicator(
            onRefresh: controller.getData,
            color: englishViolet,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(children: <Widget>[
                Stack(
                  children: <Widget>[
                    Obx(() {
                      return SizedBox(
                        height: 180,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: controller.showUserPic.value
                              ? MemoryImage(controller.getImageFromBytes())
                                  as ImageProvider<Object>?
                              : AssetImage(controller.image.value),
                        ),
                      );
                    }),
                    Positioned(
                      top: 130,
                      left: 43,
                      child: GestureDetector(
                        onTap: () => onClckProfileIcon(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: englishViolet,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/camera.svg',
                              fit: BoxFit.cover,
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Obx(() {
                  return buildTile(
                      icon: TourMaker.profile_icon,
                      data: controller.userData.value.name.toString(),
                      label: 'Full Name');
                }),
                Obx(() {
                  return buildTile(
                    icon: TourMaker.call,
                    data: controller.userData.value.phoneNumber.toString(),
                    label: 'Phone Number',
                  );
                }),
                Obx(() {
                  return buildTile(
                      icon: TourMaker.location_icon,
                      label: 'State',
                      data: controller.userData.value.state.toString());
                }),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: ExpansionTileCard(
                    borderRadius: BorderRadius.circular(18),
                    baseColor: const Color.fromARGB(255, 232, 231, 233),
                    expandedColor: const Color.fromARGB(255, 232, 231, 233),
                    animateTrailing: true,
                    contentPadding: const EdgeInsets.all(4),
                    turnsCurve: Curves.bounceInOut,
                    colorCurve: Curves.decelerate,
                    duration: const Duration(milliseconds: 400),
                    elevationCurve: Curves.decelerate,
                    expandedTextColor: englishViolet,
                    key: controller.cardB,
                    title: const Text('        More about you'),
                    subtitle: const Text('             Tap to view'),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Address :', style: subheading1),
                            SizedBox(
                              width: 200,
                              child: controller.userData.value.address == ''
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () =>
                                              controller.onClickAdddetail(),
                                          child: Text(
                                            'Add your address',
                                            style: paragraph2.copyWith(
                                              color: englishViolet,
                                              overflow: TextOverflow.visible,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      controller.userData.value.address
                                          .toString(),
                                      style: paragraph2.copyWith(
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('city :', style: subheading1),
                            if (controller.userData.value.district == '')
                              GestureDetector(
                                onTap: () => controller.onClickAdddetail(),
                                child: Text(
                                  'Add your City',
                                  style: paragraph2.copyWith(
                                    color: englishViolet,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              )
                            else
                              Text(
                                controller.userData.value.district.toString(),
                                style: paragraph2.copyWith(
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('country :', style: subheading1),
                            if (controller.userData.value.country == '')
                              GestureDetector(
                                onTap: () => controller.onClickAdddetail(),
                                child: Text(
                                  'Add your Country',
                                  style: paragraph2.copyWith(
                                    color: englishViolet,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              )
                            else
                              Text(
                                controller.userData.value.country.toString(),
                                style: paragraph2.copyWith(
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Category :', style: subheading1),
                            if (controller.userData.value.category == '')
                              GestureDetector(
                                onTap: () => controller.onClickAdddetail(),
                                child: Text(
                                  'Add your Category',
                                  style: paragraph2.copyWith(
                                    color: englishViolet,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              )
                            else
                              Text(
                                controller.userData.value.category.toString(),
                                style: paragraph2.copyWith(
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('EnterPrise Name :', style: subheading1),
                            if (controller.userData.value.enterpriseName == '')
                              GestureDetector(
                                onTap: () => controller.onClickAdddetail(),
                                child: Text(
                                  'Add your Category',
                                  style: paragraph2.copyWith(
                                    color: englishViolet,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              )
                            else
                              Text(
                                controller.userData.value.enterpriseName
                                    .toString(),
                                style: paragraph2.copyWith(
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Email :', style: subheading1),
                            if (controller.userData.value.email == '')
                              GestureDetector(
                                onTap: () => controller.onClickAdddetail(),
                                child: Text(
                                  'Add your Email',
                                  style: paragraph2.copyWith(
                                    color: englishViolet,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              )
                            else
                              Text(
                                controller.userData.value.email.toString(),
                                style: paragraph2.copyWith(
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Gender :', style: subheading1),
                            if (controller.userData.value.gender == '')
                              GestureDetector(
                                onTap: () => controller.onClickAdddetail(),
                                child: Text(
                                  'Add your Gender',
                                  style: paragraph2.copyWith(
                                    color: englishViolet,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              )
                            else
                              Text(
                                controller.userData.value.gender.toString(),
                                style: paragraph2.copyWith(
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ));
  }

  Widget registeredUser(ProfileController controller, BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.getData,
      color: englishViolet,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(children: <Widget>[
          Stack(
            children: <Widget>[
              Obx(() {
                return SizedBox(
                  height: 180,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: controller.showUserPic.value
                        ? MemoryImage(controller.getImageFromBytes())
                            as ImageProvider<Object>?
                        : AssetImage(controller.image.value),
                  ),
                );
              }),
              Positioned(
                top: 130,
                left: 43,
                child: GestureDetector(
                  onTap: () => onClckProfileIcon(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: englishViolet,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/camera.svg',
                        fit: BoxFit.cover,
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Obx(() {
            return buildTile(
                icon: TourMaker.profile_icon,
                data: controller.userData.value.name.toString(),
                label: 'Full Name');
          }),
          Obx(() {
            return buildTile(
              icon: TourMaker.call,
              data: controller.userData.value.phoneNumber.toString(),
              label: 'Phone Number',
            );
          }),
          Obx(() {
            return buildTile(
                icon: TourMaker.location_icon,
                label: 'State',
                data: controller.userData.value.state.toString());
          }),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: ExpansionTileCard(
              borderRadius: BorderRadius.circular(18),
              baseColor: const Color.fromARGB(255, 232, 231, 233),
              expandedColor: const Color.fromARGB(255, 232, 231, 233),
              animateTrailing: true,
              contentPadding: const EdgeInsets.all(4),
              turnsCurve: Curves.bounceInOut,
              colorCurve: Curves.decelerate,
              duration: const Duration(milliseconds: 400),
              elevationCurve: Curves.decelerate,
              expandedTextColor: englishViolet,
              key: controller.cardB,
              title: const Text('        More about you'),
              subtitle: const Text('             Tap to view'),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Address :', style: subheading1),
                      SizedBox(
                        width: 200,
                        child: controller.userData.value.address == ''
                            ? GestureDetector(
                                onTap: () => controller.onClickAdddetail(),
                                child: Text(
                                  'Add your address',
                                  style: paragraph2.copyWith(
                                    color: englishViolet,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              )
                            : Text(
                                controller.userData.value.address.toString(),
                                style: paragraph2.copyWith(
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('city :', style: subheading1),
                      if (controller.userData.value.district == '')
                        GestureDetector(
                          onTap: () => controller.onClickAdddetail(),
                          child: Text(
                            'Add your City',
                            style: paragraph2.copyWith(
                              color: englishViolet,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        )
                      else
                        Text(
                          controller.userData.value.district.toString(),
                          style: paragraph2.copyWith(
                            overflow: TextOverflow.visible,
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('country :', style: subheading1),
                      if (controller.userData.value.country == null)
                        GestureDetector(
                          onTap: () => controller.onClickAdddetail(),
                          child: Text(
                            'Add your Country',
                            style: paragraph2.copyWith(
                              color: englishViolet,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        )
                      else
                        Text(
                          controller.userData.value.country.toString(),
                          style: paragraph2.copyWith(
                            overflow: TextOverflow.visible,
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Category :', style: subheading1),
                      if (controller.userData.value.category == '')
                        GestureDetector(
                          onTap: () => controller.onClickAdddetail(),
                          child: Text(
                            'Add your Category',
                            style: paragraph2.copyWith(
                              color: englishViolet,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        )
                      else
                        Text(
                          controller.userData.value.category.toString(),
                          style: paragraph2.copyWith(
                            overflow: TextOverflow.visible,
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Enterprise Name :', style: subheading1),
                      if (controller.userData.value.enterpriseName == '')
                        GestureDetector(
                          onTap: () => controller.onClickAdddetail(),
                          child: Text(
                            'Add your EnterpriseName',
                            style: paragraph2.copyWith(
                              color: englishViolet,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        )
                      else
                        Text(
                          controller.userData.value.enterpriseName.toString(),
                          style: paragraph2.copyWith(
                            overflow: TextOverflow.visible,
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Email :', style: subheading1),
                      if (controller.userData.value.email == '')
                        GestureDetector(
                          onTap: () => controller.onClickAdddetail(),
                          child: Text(
                            'Add your Email',
                            style: paragraph2.copyWith(
                              color: englishViolet,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        )
                      else
                        Text(
                          controller.userData.value.email.toString(),
                          style: paragraph2.copyWith(
                            overflow: TextOverflow.visible,
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Gender :', style: subheading1),
                      if (controller.userData.value.gender == '')
                        GestureDetector(
                          onTap: () => controller.onClickAdddetail(),
                          child: Text(
                            'Add your Gender',
                            style: paragraph2.copyWith(
                              color: englishViolet,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        )
                      else
                        Text(
                          controller.userData.value.gender.toString(),
                          style: paragraph2.copyWith(
                            overflow: TextOverflow.visible,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget nonRegisteredUser(ProfileController controller, BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.getData,
      color: englishViolet,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Obx(() {
                  return SizedBox(
                    height: 180,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: controller.showUserPic.value
                          ? MemoryImage(controller.getImageFromBytes())
                              as ImageProvider<Object>?
                          : AssetImage(controller.image.value),
                    ),
                  );
                }),
                Positioned(
                  top: 130,
                  left: 43,
                  child: GestureDetector(
                    onTap: () => onClckProfileIcon(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: englishViolet,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/camera.svg',
                          fit: BoxFit.cover,
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Obx(() {
              return buildTile(
                  icon: TourMaker.profile_icon,
                  data: controller.userData.value.name.toString(),
                  label: 'Full Name');
            }),
            Obx(() {
              return buildTile(
                icon: TourMaker.call,
                data: controller.userData.value.phoneNumber.toString(),
                label: 'Phone Number',
              );
            }),
            Obx(() {
              return buildTile(
                  icon: TourMaker.location_icon,
                  label: 'State',
                  data: controller.userData.value.state.toString());
            }),
            const SizedBox(height: 20),
            // Obx(() {
            //   return Padding(
            //     padding: const EdgeInsets.all(10),
            //     child: CustomButton().showIconButtonWithGradient(
            //       height: 75,
            //       width: 100.h,
            //       isLoading: controller.isloading.value,
            //       text: '  Pay Service Charge Now',
            //       onPressed: () => controller.onClickPayment(),
            //     ),
            //   );
            // })
          ],
        ),
      ),
    );
  }

  Future<void> onClckProfileIcon(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text('Choose profile pic from :'),
          content: Container(
            padding: const EdgeInsets.all(8),
            height: 140,
            child: Column(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.image, color: englishViolet),
                    title: const Text('Gallery'),
                    onTap: () {
                      controller.getImage(ImageSource.gallery);
                      Get.back();
                    }),
                ListTile(
                    leading:
                        Icon(Icons.camera_alt_rounded, color: englishViolet),
                    title: const Text('Camera'),
                    onTap: () {
                      controller.getImage(ImageSource.camera);
                      Get.back();
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildTile(
      {required IconData icon, required String label, required String data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 23),
      child: Container(
        width: 100.w,
        height: 85,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 232, 231, 233),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(icon, color: fontColor),
                ],
              ),
              const SizedBox(width: 15),
              VerticalDivider(
                color: Colors.grey.shade600,
                endIndent: 10,
                indent: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(label, style: paragraph3),
                    Text(data, style: subheading2),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
// Obx(() {
//                           return Padding(
//                             padding: const EdgeInsets.all(10),
//                             child: CustomButton().showIconButtonWithGradient(
//                               height: 75,
//                               width: 100.h,
//                               isLoading: controller.isloading.value,
//                               text: '  Pay Service Charge Now',
//                               onPressed: () => controller.onClickPayment(),
//                             ),
//                           );
//                         })
