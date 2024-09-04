import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_finder/utils/RFColors.dart';
import 'package:roomie_finder/utils/RFConstant.dart';
import 'package:roomie_finder/utils/RFImages.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../main.dart';

Widget socialLoginButton(BuildContext context,
    {String? socialImage, String? socialLoginName}) {
  return OutlinedButton(
    onPressed: () {},
    style: OutlinedButton.styleFrom(
      backgroundColor: context.scaffoldBackgroundColor,
      side: BorderSide(color: context.dividerColor, width: 1),
      padding: const EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        commonCacheImageWidget(socialImage!, 20, fit: BoxFit.cover),
        8.width,
        Text(socialLoginName!, style: primaryTextStyle()),
      ],
    ),
  ).paddingSymmetric(horizontal: 24);
}

InputDecoration rfInputDecoration(
    {Widget? suffixIcon,
    String? hintText,
    Widget? prefixIcon,
    bool? showPreFixIcon,
    String? lableText,
    String? prefixText,
    bool? showPrefixText,
    bool showLableText = false}) {
  return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: gray.withOpacity(0.4)),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      hintText: hintText,
      hintStyle: secondaryTextStyle(),
      labelStyle: secondaryTextStyle(),
      labelText: showLableText.validate() ? lableText! : null,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: rfPrimaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: gray.withOpacity(0.4)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: redColor.withOpacity(0.4)),
      ),
      filled: true,
      fillColor: appStore.isDarkModeOn ? scaffoldDarkColor : white,
      suffix: suffixIcon.validate(),
      prefixText: showPrefixText.validate() ? prefixText : null,
      prefixIcon: showPreFixIcon.validate() ? prefixIcon.validate() : null);
}

Widget rfCommonRichText(
    {String? title,
    String? subTitle,
    int? textSize,
    double? textHeight,
    Color? titleTextColor,
    Color? subTitleTextColor,
    TextStyle? titleTextStyle,
    TextStyle? subTitleTextStyle}) {
  return RichText(
    //textAlign: TextAlign.center,
    text: TextSpan(
      text: title.validate(),
      style: titleTextStyle ??
          primaryTextStyle(
              size: textSize ?? 14,
              height: textHeight ?? 0,
              letterSpacing: 1.5),
      children: [
        TextSpan(
          text: subTitle.validate(),
          style: subTitleTextStyle ??
              primaryTextStyle(
                  color: subTitleTextColor ?? rfPrimaryColor,
                  size: textSize ?? 14,
                  letterSpacing: 1.5),
        ),
      ],
    ),
  );
}

void changeStatusColor(Color color) async {
  setStatusBarColor(color);
}

Widget text(
  String? text, {
  var fontSize = textSizeLargeMedium,
  Color? textColor,
  var fontFamily,
  var isCentered = false,
  var maxLine = 1,
  var latterSpacing = 0.5,
  bool textAllCaps = false,
  var isLongText = false,
  bool lineThrough = false,
}) {
  return Text(
    textAllCaps ? text!.toUpperCase() : text!,
    textAlign: isCentered ? TextAlign.center : TextAlign.start,
    maxLines: isLongText ? null : maxLine,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      color: textColor ?? appStore.textSecondaryColor,
      height: 1.5,
      letterSpacing: latterSpacing,
      decoration:
          lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
    ),
  );
}

class CustomTheme extends StatelessWidget {
  final Widget? child;

  const CustomTheme({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: appStore.isDarkModeOn
          ? ThemeData.dark().copyWith(
              colorScheme: ColorScheme.fromSwatch()
                  .copyWith(secondary: appColorPrimary)
                  .copyWith(surface: context.scaffoldBackgroundColor),
            )
          : ThemeData.light(),
      child: child!,
    );
  }
}

Widget socialLoginWidget(BuildContext context,
    {Function? callBack, String? title1, String? title2}) {
  return Column(
    children: [
      Column(
        children: [
          28.height,
          Text('Or Sign Up with', style: primaryTextStyle()),
          16.height,
          socialLoginButton(context,
                  socialImage: rfFacebookLogo,
                  socialLoginName: "Continue With Facebook")
              .onTap(() {
            //
          }),
          16.height,
          socialLoginButton(context,
                  socialImage: rfGoogleLogo,
                  socialLoginName: "Continue With Google")
              .onTap(() {
            //
          }),
          24.height,
          rfCommonRichText(title: title1, subTitle: title2)
              .paddingAll(8)
              .onTap(() {
            callBack!.call();
          })
        ],
      )
    ],
  );
}

BoxDecoration boxDecoration(
    {double radius = 2,
    Color color = Colors.transparent,
    Color? bgColor,
    var showShadow = false}) {
  return BoxDecoration(
    color: bgColor ?? appStore.scaffoldBackground,
    boxShadow: showShadow
        ? defaultBoxShadow(shadowColor: shadowColorGlobal)
        : [const BoxShadow(color: Colors.transparent)],
    border: Border.all(color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

Decoration shadowWidget(BuildContext context) {
  return boxDecorationWithRoundedCorners(
    backgroundColor: context.cardColor,
    boxShadow: [
      BoxShadow(
          spreadRadius: 0.4,
          blurRadius: 3,
          color: gray.withOpacity(0.1),
          offset: const Offset(1, 6)),
    ],
  );
}

Widget rfCommonCachedNetworkImage(
  String? url, {
  double? height,
  double? width,
  BoxFit? fit,
  AlignmentGeometry? alignment,
  bool usePlaceholderIfUrlEmpty = true,
  double? radius,
  Color? color,
}) {
  if (url!.validate().isEmpty) {
    return placeHolderWidget(
        height: height,
        width: width,
        fit: fit,
        alignment: alignment,
        radius: radius);
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: fit,
      color: color,
      alignment: alignment as Alignment? ?? Alignment.center,
      errorWidget: (_, s, d) {
        return placeHolderWidget(
            height: height,
            width: width,
            fit: fit,
            alignment: alignment,
            radius: radius);
      },
      placeholder: (_, s) {
        if (!usePlaceholderIfUrlEmpty) return const SizedBox();
        return placeHolderWidget(
            height: height,
            width: width,
            fit: fit,
            alignment: alignment,
            radius: radius);
      },
    );
  } else {
    return Image.asset(url,
            height: height,
            width: width,
            fit: fit,
            color: color,
            alignment: alignment ?? Alignment.center)
        .cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }
}

Widget placeHolderWidget(
    {double? height,
    double? width,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    double? radius}) {
  return Image.asset('images/app/placeholder.jpg',
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          alignment: alignment ?? Alignment.center)
      .cornerRadiusWithClipRRect(radius ?? defaultRadius);
}

Widget viewAllWidget({String? title, String? subTitle, Function? onTap}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title!, style: boldTextStyle()),
      TextButton(
        onPressed: onTap!(),
        child: Text(subTitle!,
            style: secondaryTextStyle(decoration: TextDecoration.underline)),
      )
    ],
  );
}

PreferredSizeWidget commonAppBarWidget(BuildContext context,
    {String? title,
    double? appBarHeight,
    bool? showLeadingIcon,
    bool? bottomSheet,
    bool? roundCornerShape}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(appBarHeight ?? 100.0),
    child: AppBar(
      title: Text(title!, style: boldTextStyle(color: whiteColor, size: 20)),
      systemOverlayStyle:
          const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
      backgroundColor: rfPrimaryColor,
      centerTitle: true,
      leading: showLeadingIcon.validate()
          ? const SizedBox()
          : IconButton(
              onPressed: () {
                finish(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: whiteColor, size: 18),
              color: rfPrimaryColor,
            ),
      elevation: 0,
      shape: roundCornerShape.validate()
          ? const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)))
          : const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.zero),
            ),
    ),
  );
}

extension StrExt on String {
  Widget iconImage({Color? iconColor, double size = bottomNavigationIconSize}) {
    return Image.asset(
      this,
      width: size,
      height: size,
      color: iconColor ?? gray,
      errorBuilder: (_, __, ___) =>
          placeHolderWidget(width: size, height: size),
    );
  }
}

Widget commonCacheImageWidget(String? url, double height,
    {double? width, BoxFit? fit}) {
  if (url.validate().startsWith('http')) {
    if (isMobile) {
      return CachedNetworkImage(
        placeholder:
            placeholderWidgetFn() as Widget Function(BuildContext, String)?,
        imageUrl: '$url',
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        errorWidget: (_, __, ___) {
          return SizedBox(height: height, width: width);
        },
      );
    } else {
      return Image.network(url!,
          height: height, width: width, fit: fit ?? BoxFit.cover);
    }
  } else {
    return Image.asset(url!,
        height: height, width: width, fit: fit ?? BoxFit.cover);
  }
}

Widget? Function(BuildContext, String) placeholderWidgetFn() =>
    (_, s) => placeholderWidget();

Widget placeholderWidget() =>
    Image.asset('images/app/placeholder.jpg', fit: BoxFit.cover);

Future<void> commonLaunchUrl(String address,
    {LaunchMode launchMode = LaunchMode.inAppWebView}) async {
  await launchUrl(Uri.parse(address), mode: launchMode).catchError((e) {
    toast('Invalid URL: $address');
    return false;
  });
}

void launchCall(String? url) {
  if (url.validate().isNotEmpty) {
    if (isIOS) {
      commonLaunchUrl('tel://${url!}',
          launchMode: LaunchMode.externalApplication);
    } else {
      commonLaunchUrl('tel:${url!}',
          launchMode: LaunchMode.externalApplication);
    }
  }
}

void launchMail(String? url) {
  if (url.validate().isNotEmpty) {
    commonLaunchUrl('mailto:${url!}',
        launchMode: LaunchMode.externalApplication);
  }
}
