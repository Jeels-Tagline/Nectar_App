import 'package:flutter/material.dart';

class CommonExpansionTile extends StatelessWidget {
  final String title;
  final Icon icon;
  final Function()? onTap;
  const CommonExpansionTile({
    required this.title,
    required this.icon,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          // Padding(
          //   padding: EdgeInsets.only(left: w * 0.04, right: w * 0.04),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: IconButton(onPressed: () {}, icon: icon),
          //       ),
          //       Expanded(
          //         flex: 8,
          //         child: Padding(
          //           padding: EdgeInsets.only(left: w * 0.02),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Text(
          //                 title,
          //                 style: const TextStyle(fontSize: 16),
          //               ),
          //               const Icon(Icons.arrow_forward_ios_rounded)
          //             ],
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          ListTile(
            onTap: onTap,
            leading: icon,
            title: Text(
              title,
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
