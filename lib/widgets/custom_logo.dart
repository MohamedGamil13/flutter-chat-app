import 'package:flutter/material.dart';

class CustomLogo extends StatelessWidget {
  const CustomLogo({super.key, required this.path});
  final String path;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 25,
      backgroundImage: AssetImage(path),
      backgroundColor: Colors.transparent,
    );
  }
}

//     Image.network(
//       "https://static.vecteezy.com/system/resources/previews/018/757/862/non_2x/facebook-logo-facebook-icon-free-free-vector.jpg",
//     );
//   }
// }
