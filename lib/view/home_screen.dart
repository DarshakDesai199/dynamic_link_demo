import 'package:dynamic_link_demo/api_routs/api_response.dart';
import 'package:dynamic_link_demo/common/dynamic_link_service.dart';
import 'package:dynamic_link_demo/model/response_model/product_response_model.dart';
import 'package:dynamic_link_demo/view/product_detail_screen.dart';
import 'package:dynamic_link_demo/view_model/product_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProductViewModel productViewModel = Get.put(ProductViewModel());
  @override
  void initState() {
    productViewModel.productViewModel();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GetBuilder<ProductViewModel>(
          builder: (controller) {
            if (controller.productApiResponse.status == Status.LOADING) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
            if (controller.productApiResponse.status == Status.COMPLETE) {
              return MasonryGridView.count(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(15),
                itemCount: controller.products.value.products?.length,
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => ProductDetailScreen(
                          productId: controller
                              .products.value.products![index].id
                              .toString()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              controller
                                  .products.value.products![index].thumbnail!,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  controller
                                      .products.value.products![index].title!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '\$ ${controller.products.value.products![index].price!}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text('Something went wrong'),
              );
            }
          },
        ),
      ),
    );
  }
}
