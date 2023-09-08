import 'package:flutter/material.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:shimmer/shimmer.dart';

class CommonProductShimmer extends StatelessWidget {
  final int itemCount;
  const CommonProductShimmer({required this.itemCount, super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SizedBox(
        width: w,
        height: h * 0.28,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(top: h * 0.02, right: w * 0.025),
              child: Container(
                width: w * 0.4,
                padding: EdgeInsets.only(
                  top: h * 0.01,
                  bottom: h * 0.01,
                  left: w * 0.01,
                  right: w * 0.01,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: h * 0.1,
                        width: w,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: h * 00.01),
                        child: Container(
                          height: h * 0.02,
                          width: w,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: h * 00.01),
                        child: Container(
                          height: h * 0.01,
                          width: w,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: h * 0.013),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: h * 0.03,
                              width: w * 0.15,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                            Container(
                              height: h * 0.055,
                              width: w * 0.12,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Globals.greenColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
