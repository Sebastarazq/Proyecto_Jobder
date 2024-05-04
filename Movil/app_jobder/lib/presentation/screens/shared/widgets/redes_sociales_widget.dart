import 'package:app_jobder/domain/entities/red_social.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RedesSocialesWidget extends StatelessWidget {
  final List<RedSocial>? redesSociales;

  const RedesSocialesWidget({Key? key, required this.redesSociales}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (redesSociales == null || redesSociales!.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              color: const Color.fromARGB(255, 133, 180, 219).withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 10,
            ),
          ],
        ),
        child: ListTile(
          title: Text('Sin redes sociales'),
          tileColor: Colors.white,
        ),
      );
    }

    List<Widget> redesSocialesWidgets = [];

    for (var i = 0; i < redesSociales!.length; i++) {
      final redSocial = redesSociales![i];
      String nombreRedSocial = redSocial.nombre.toLowerCase();
      String iconPath = '';

      switch (nombreRedSocial) {
        case 'instagram':
          iconPath = 'assets/icons/instagram.svg';
          break;
        case 'github':
          iconPath = 'assets/icons/github.svg';
          break;
        case 'linkedin':
          iconPath = 'assets/icons/linkedin.svg';
          break;
        // Agrega más casos según sea necesario para otras redes sociales
      }

      Widget redSocialWidget = Container(
        margin: EdgeInsets.only(bottom: i != redesSociales!.length - 1 ? 10 : 0), // Agrega un margen inferior solo si no es el último elemento
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              color: const Color.fromARGB(255, 133, 180, 219).withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 10,
            ),
          ],
        ),
        child: ListTile(
          leading: SvgPicture.asset(
            iconPath,
            height: 30,
            width: 30,
          ),
          title: Text(redSocial.nombreUsuarioAplicacion),
          tileColor: Colors.white,
        ),
      );

      redesSocialesWidgets.add(redSocialWidget);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: redesSocialesWidgets,
    );
  }
}
