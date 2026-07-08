import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AgentCard extends StatelessWidget {

  final String name;
  final String properties;
  final String rating;
  final String? imageUrl;

  final VoidCallback? onTap;


  const AgentCard({
    super.key,
    required this.name,
    required this.properties,
    required this.rating,
    this.imageUrl,
    this.onTap,
  });



  @override
  Widget build(BuildContext context) {

    return InkWell(

      onTap: onTap,

      borderRadius: BorderRadius.circular(14),


      child: Container(

        width:160,

        margin:
        const EdgeInsets.only(right:12),


        padding:
        const EdgeInsets.all(10),


        decoration: BoxDecoration(

          color:Colors.white,

          borderRadius:
          BorderRadius.circular(14),


          boxShadow:[

            BoxShadow(

              color:
              Colors.black.withOpacity(0.05),

              blurRadius:8,

              offset:
              const Offset(0,3),

            )

          ],

        ),



        child:Column(

          mainAxisAlignment:
          MainAxisAlignment.center,


          children:[



            CircleAvatar(

              radius:20,


              backgroundImage:

              imageUrl != null

              ?

              NetworkImage(
                imageUrl!,
              )

              :

              null,



              child:

              imageUrl == null

              ?

              const Icon(
                Iconsax.user,
                size:18,
              )

              :

              null,

            ),





            const SizedBox(height:6),




            Text(

              name,

              style:
              const TextStyle(

                fontWeight:
                FontWeight.bold,

                fontSize:13,

              ),


              overflow:
              TextOverflow.ellipsis,

            ),





            const SizedBox(height:2),





            Text(

              properties,


              style:
              const TextStyle(

                fontSize:11,

                color:Colors.grey,

              ),


              overflow:
              TextOverflow.ellipsis,

            ),





            const SizedBox(height:4),




            Text(

              "⭐ $rating",


              style:
              const TextStyle(

                fontSize:12,

                color:Colors.orange,

              ),

            ),


          ],

        ),

      ),

    );

  }

}