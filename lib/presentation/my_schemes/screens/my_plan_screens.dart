import 'package:flutter/material.dart';
import 'package:sri_mahalakshmi/core/utility/app_colors.dart';
import 'package:sri_mahalakshmi/core/utility/app_images.dart';
import 'package:get/get.dart';
import 'package:sri_mahalakshmi/core/utility/app_loader.dart';
import 'package:sri_mahalakshmi/presentation/my_schemes/controller/my_scheme_controller.dart';
import '../../../core/utility/app_textstyles.dart';
import '../../Join_schemes/screens/customer_details_screen.dart';
import 'my_ledger_screen.dart';

class MyPlanScreens extends StatefulWidget {
  const MyPlanScreens({super.key});

  @override
  State<MyPlanScreens> createState() => _MyPlanScreensState();
}

class _MyPlanScreensState extends State<MyPlanScreens> {
  final MySchemeController controller = Get.put(MySchemeController());
  @override
  void initState() {
    super.initState();
    controller.mySchemes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.8),
              BlendMode.lighten,
            ),
            image: AssetImage(AppImages.bg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.chevron_left),
                    ),
                    AppTextStyles.textWith600(text: 'My Savings'),
                    Text(''),
                  ],
                ),
              ),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(child: AppLoader.circularLoader());
            }

            return RefreshIndicator(
              onRefresh: () async {
                await controller.mySchemes(); // Your fetch method
              },
              child: controller.mySchemeList.isEmpty
                  ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 100),
                  Center(child: Text('No Data Found')),
                ],
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: controller.mySchemeList.length,
                itemBuilder: (context, index) {
                  final data = controller.mySchemeList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFCC33), Color(0xFFFFCC33)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            image:   DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  Colors.white70, BlendMode.lighten),
                              image: AssetImage(AppImages.bg),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header: Image + Scheme Name + Premium Plan
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 6,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Image.asset(AppImages.gold),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data.schemeName,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.amber.shade700,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            AppTextStyles.googleFontLaTo(
                                                tittle: 'Your Premium Plan',
                                                fontSize: 12),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.greenAccent.shade700,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 6,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      data.noIns,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // User Info
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 15,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.person,
                                            color: Colors.deepPurple),
                                        const SizedBox(width: 8),
                                        Text(
                                          data.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[800]),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.credit_card,
                                            color: Colors.deepPurple),
                                        const SizedBox(width: 8),
                                        Text(
                                          data.accNo,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[800]),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Type & Amount
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Type: ${data.intType}',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade700),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.currency_rupee,
                                          color: Colors.green, size: 18),
                                      const SizedBox(width: 4),
                                      Text(
                                        data.totalCollection.toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.amber.shade600,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(12)),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        elevation: 6,
                                      ),
                                      onPressed: () {
                                        Get.to(() => MyLedgerScreen(
                                            name: data.name,
                                            noIns: data.noIns,
                                            accNo: data.accNo));
                                      },
                                      child: const Text(
                                        "View Details",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.deepPurple,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(12)),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        elevation: 6,
                                      ),
                                      onPressed: () {
                                        Get.to(() => CustomerDetailsScreen(
                                            page: 'MyPlan'),
                                            arguments: data);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                            "Pay Now",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          SizedBox(width: 6),
                                          Icon(Icons.payment, color: Colors.white),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }),
        ),

        ],
          ),
        ),
      ),
    );
  }
}
