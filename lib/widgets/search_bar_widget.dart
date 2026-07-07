import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';


class SearchBarWidget extends StatelessWidget {


  final VoidCallback onTap;
  final VoidCallback? onFilterPressed;



  const SearchBarWidget({

    super.key,

    required this.onTap,

    this.onFilterPressed,

  });



  @override
  Widget build(BuildContext context) {


    return GestureDetector(


      onTap: onTap,


      child: Container(


        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),


        decoration: BoxDecoration(


          color: Colors.white,


          borderRadius:
          BorderRadius.circular(25),


          boxShadow: [


            BoxShadow(

              color:
              Colors.grey.withOpacity(0.15),

              blurRadius:10,

              offset:
              const Offset(0,4),

            )


          ],


        ),



        child: Row(


          children: [



            const Icon(

              Iconsax.search_normal,

              size:20,

              color:Colors.grey,

            ),



            const SizedBox(width:10),





            const Expanded(


              child: Text(


                "Search property, location...",


                style: TextStyle(

                  color:Colors.grey,

                  fontSize:14,

                ),

              ),


            ),





            GestureDetector(


              onTap: onFilterPressed,


              child: Container(


                width:42,

                height:42,



                decoration:BoxDecoration(


                  color:
                  const Color(0xFF22C55E),


                  borderRadius:
                  BorderRadius.circular(14),


                ),



                child:const Icon(


                  Icons.tune,


                  color:Colors.white,


                  size:20,


                ),


              ),


            )


          ],


        ),


      ),


    );


  }


}