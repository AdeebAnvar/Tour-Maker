import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/theme/style.dart';

class CustomButton {
  Widget showButton({
    Key? key,
    required String text,
    Color? textColor,
    Color? bgColor,
    EdgeInsets padding = const EdgeInsets.all(10),
    EdgeInsets contentPadding = const EdgeInsets.all(10),
    bool isLoading = false,
    bool isIconRight = false,
    IconData? icon,
    double? elevation,
    required Function() onPressed,
    double? height,
    double? width,
  }) {
    return customButton(
      bgColor: bgColor,
      contentPadding: contentPadding,
      elevation: elevation,
      height: height,
      width: width,
      icon: icon,
      onPressed: onPressed,
      isIconRight: isIconRight,
      isLoading: isLoading,
      padding: padding,
      text: text,
      textColor: textColor,
      key: key,
    );
  }

  Widget showIconButtonWithGradient({
    Key? key,
    required String text,
    Color textColor = Colors.white,
    Color bgColor = const Color.fromRGBO(86, 60, 92, 1),
    EdgeInsets padding = const EdgeInsets.all(10),
    EdgeInsets contentPadding = const EdgeInsets.all(10),
    bool isLoading = false,
    bool isIconRight = false,
    IconData? icon,
    double? elevation,
    required Function() onPressed,
    double? height,
    double? width,
    TextStyle? textStyle,
  }) {
    return customIconButtonWithGradient(
      bgColor: bgColor,
      contentPadding: contentPadding,
      elevation: elevation,
      height: height,
      width: width,
      icon: icon,
      onPressed: onPressed,
      isIconRight: isIconRight,
      isLoading: isLoading,
      padding: padding,
      text: text,
      textColor: textColor,
      key: key,
      textstyle: textStyle,
    );
  }

  Widget showIconButton({
    Key? key,
    required String text,
    Color textColor = Colors.white,
    Color bgColor = Colors.red,
    EdgeInsets padding = const EdgeInsets.all(10),
    EdgeInsets contentPadding = const EdgeInsets.all(10),
    bool isLoading = false,
    bool isIconRight = false,
    IconData? icon,
    double? elevation,
    required Function() onPressed,
    double? height,
    double? width,
  }) {
    return customIconButton(
      bgColor: bgColor,
      contentPadding: contentPadding,
      elevation: elevation,
      height: height,
      width: width,
      icon: icon,
      onPressed: onPressed,
      isIconRight: isIconRight,
      isLoading: isLoading,
      padding: padding,
      text: text,
      textColor: textColor,
      key: key,
    );
  }

  Widget showButtonWithGradient({
    Key? key,
    required String text,
    Color textColor = Colors.white,
    Color bgColor = Colors.red,
    EdgeInsets padding = const EdgeInsets.all(10),
    EdgeInsets contentPadding = const EdgeInsets.all(10),
    bool isLoading = false,
    bool isIconRight = false,
    IconData? icon,
    double? elevation,
    required Function() onPressed,
    double? height,
    double? width,
  }) {
    return customButtomwithGradient(
      bgColor: bgColor,
      contentPadding: contentPadding,
      elevation: elevation,
      height: height,
      width: width,
      icon: icon,
      onPressed: onPressed,
      isIconRight: isIconRight,
      isLoading: isLoading,
      padding: padding,
      text: text,
      textColor: textColor,
      key: key,
    );
  }

  Widget customButtomwithGradient({
    Key? key,
    required String text,
    Color? textColor,
    Color? bgColor,
    EdgeInsets? padding,
    EdgeInsets? contentPadding,
    bool isLoading = false,
    bool isIconRight = true,
    IconData? icon,
    double? elevation,
    Function()? onPressed,
    double? height,
    double? width,
  }) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(25),
      child: GestureDetector(
        onTap: onPressed,
        child: AnimatedContainer(
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 500),
          height: height ?? 50,
          width: width ?? 250,
          decoration: BoxDecoration(
            color: englishViolet,
            borderRadius: BorderRadius.circular(15),
          ),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Center(
                  child: Text(text, style: buttonwithWhiteTextStyle),
                ),
        ),
      ),
    );
  }

  Widget customButton(
      {Color? bgColor,
      EdgeInsets? contentPadding,
      double? elevation,
      double? height,
      double? width,
      IconData? icon,
      Function()? onPressed,
      required bool isIconRight,
      required bool isLoading,
      EdgeInsets? padding,
      required String text,
      Color? textColor,
      Key? key}) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(15),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: height ?? 50,
          width: width ?? 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: bgColor,
          ),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Center(
                  child: Text(text, style: buttonwithbLACKTextStyle),
                ),
        ),
      ),
    );
  }

  Widget customIconButtonWithGradient(
      {Key? key,
      required String text,
      Color? textColor,
      Color? bgColor,
      EdgeInsets? padding,
      EdgeInsets? contentPadding,
      bool isLoading = false,
      bool isIconRight = true,
      IconData? icon,
      double? elevation,
      Function()? onPressed,
      double? height,
      double? width,
      TextStyle? textstyle}) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(25),
      child: GestureDetector(
        onTap: onPressed,
        child: AnimatedContainer(
          curve: Curves.easeInOut,
          duration: const Duration(seconds: 2),
          child: Container(
            height: height ?? 50,
            width: width ?? 250,
            decoration: BoxDecoration(
              color: bgColor ?? const Color.fromARGB(255, 97, 45, 109),
              // gradient: buttonColorGradient,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(isLoading ? '        Please Wait' : text,
                      style: textstyle ?? buttonwithWhiteTextStyle),
                  Container(
                    height: 100.h,
                    width: 14.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white24,
                    ),
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Icon(
                            Icons.keyboard_arrow_right_outlined,
                            size: 25,
                            color: textColor ?? Colors.white,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget customIconButton({
    Key? key,
    required String text,
    Color? textColor,
    Color? bgColor,
    EdgeInsets? padding,
    EdgeInsets? contentPadding,
    bool isLoading = false,
    bool isIconRight = true,
    IconData? icon,
    double? elevation,
    Function()? onPressed,
    double? height,
    double? width,
  }) {
    return isLoading
        ? Container(
            alignment: Alignment.center,
            height: 10.h,
            width: 14.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: englishViolet,
            ),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          )
        : Padding(
            padding: padding ?? const EdgeInsets.all(25),
            child: GestureDetector(
              onTap: onPressed,
              child: AnimatedContainer(
                curve: Curves.easeInOut,
                duration: const Duration(seconds: 2),
                child: Container(
                  height: height ?? 50,
                  width: width ?? 250,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // gradient: buttonColorGradient,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(text, style: buttonwithbLACKTextStyle),
                        Container(
                          height: 100.h,
                          width: 14.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white24,
                          ),
                          child: const Icon(
                            Icons.keyboard_arrow_right_outlined,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}

// class CustomElevatedButton extends StatelessWidget {
//   final bool isloading;
//   final bool isIconRight;
//   final String text;
//   final Function() onPressed;
//   final Color bgColor;
//   final Color textColor;
//   final IconData? icon;
//   final EdgeInsets padding;
//   final EdgeInsets contentPadding;
//   final double elevation;
//   final double height;
//   final double width;
//   final bool isGradient;
//   CustomElevatedButton({
//     Key? key,
//     required this.text,
//     Color? textColor,
//     Color? bgColor,
//     this.isGradient = false,
//     EdgeInsets? padding,
//     EdgeInsets? contentPadding,
//     bool? isLoading,
//     this.isIconRight = true,
//     this.icon,
//     double? elevation,
//     required this.onPressed,
//     double? height,
//     double? width,
//   })  : textColor = textColor ?? Colors.white,
//         bgColor = bgColor ?? englishlinearViolet,
//         elevation = elevation ?? 3,
//         padding = padding ?? const EdgeInsets.symmetric(vertical: 12.0),
//         contentPadding = contentPadding ??
//             const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
//         isloading = isLoading ?? false,
//         height = height ?? 68,
//         width = width ?? 340,
//         super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 70,
//       width: width,
//       decoration: BoxDecoration(
//         color: isGradient ? Colors.black : bgColor,
//         borderRadius: const BorderRadius.all(Radius.circular(100)),
//         gradient: isGradient
//             ? LinearGradient(
//                 begin: Alignment.center,
//                 end: Alignment.centerLeft,
//                 colors: [
//                   Color.fromARGB(255, 94, 68, 99),
//                   Color.fromARGB(255, 97, 45, 109),
//                 ],
//               )
//             : LinearGradient(
//                 begin: Alignment.center,
//                 end: Alignment.centerLeft,
//                 colors: [
//                   Color.fromARGB(255, 255, 255, 255),
//                   Color.fromARGB(255, 255, 255, 255),
//                 ],
//               ),
//       ),
//       child: Padding(
//         padding: padding,
//         child: TextButton(
//           onPressed: () => isloading ? null : onPressed(),
//           style: TextButton.styleFrom(
//             // fixedSize: Size.fromWidth(20),

//             // backgroundColor: bgColor,
//             elevation: 0,
//             foregroundColor: textColor,
//             padding: contentPadding,
//             // shape: const RoundedRectangleBorder(
//             //     borderRadius: BorderRadius.all(Radius.circular(100)))),
//           ),
//           child: isloading
//               ? const Center(
//                   child: SizedBox(
//                       width: 24,
//                       height: 24,
//                       child: CircularProgressIndicator(color: Colors.white)),
//                 )
//               : isIconRight
//                   ? Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children:<Widget> [
//                         Text(text,
//                             style: TextStyle(
//                               fontSize: 18,
//                             )),
//                         if (icon != null) ...[
//                           const SizedBox(
//                             width: 3,
//                           ),
//                           Icon(
//                             icon,
//                             color: textColor,
//                           )
//                         ]
//                       ],
//                     )
//                   : Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children:<Widget> [
//                         if (icon != null) ...[
//                           const SizedBox(
//                             width: 3,
//                           ),
//                           Icon(
//                             icon,
//                             color: textColor,
//                           ),
//                           Text(
//                             text,
//                           ),
//                         ]
//                       ],
//                     ),
//         ),
//       ),
//     );
//   }
// }
