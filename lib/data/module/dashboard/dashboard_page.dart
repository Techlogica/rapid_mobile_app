import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rapid_mobile_app/data/module/dashboard/dashboard_controller.dart';
import 'package:rapid_mobile_app/data/widget/container/background_widget.dart';
import 'package:rapid_mobile_app/data/widget/container/home_card_view_widget.dart';
import 'package:rapid_mobile_app/res/values/colours.dart';
import 'package:rapid_mobile_app/res/values/logs/logs.dart';
import 'package:rapid_mobile_app/res/values/strings.dart';

class Dashboard extends GetView<DashboardController> {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _BodyWidget();
  }
}

class _BodyWidget extends GetView<DashboardController> {
  const _BodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
      childWidget: Obx(
        () {
          if (controller.metadataTable.isEmpty) {
            return const SizedBox(
              width: double.infinity,
              height: 50,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: controller.firstPageData.length,
              itemBuilder: (context, index) {
                return HomeCardViewWidget(
                  // icon: controller.firstPageData[index].mdtIcon,
                  icon: Icons.downloading_rounded,
                  title: controller.firstPageData[index].mdtTblTitle.toString(),
                  iconColor: colours.black,
                  backgroundColor: colours.icon_background_light_grey,
                  onTap: () => _onTap(
                      controller.firstPageData[index].mdtSysId,
                      controller.firstPageData[index].mdtTblName,
                      controller.firstPageData[index].mdtTblTitle,
                      controller.firstPageData[index].mdtDefaultwhere),
                );
              },
            );
          }
        },
      ),
    );
  }

  _onTap(int? mdtSysId, String? menuName, String? menuTitle,
      String? defaultCondition) {
    // call sub menus
    controller.fetchMenusFromLocalDb(sysId: mdtSysId);
    // check list is empty (there are no submenus under that sys_id)
    if (controller.firstPageData.isEmpty) {
      Logs.logData("sysId :: ", mdtSysId.toString());
      defaultCondition ??= '';
      Get.toNamed(
        Strings.kMenuDetailedPage,
        arguments: {
          "MDT_SYS_ID": mdtSysId,
          "MENU_NAME": menuName,
          "MENU_TITLE": menuTitle,
          "MDT_DEFAULT_WHERE": defaultCondition
        },
      );
    }
  }
}
