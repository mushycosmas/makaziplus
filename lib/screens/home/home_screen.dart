import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/categories_provider.dart';
import '../../providers/properties_provider.dart';
import '../../providers/agents_provider.dart';

import '../../widgets/category_box.dart';
import '../../widgets/hero_section.dart';
import '../../widgets/property_card.dart';
import '../../widgets/property_type_card.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/section_title.dart';
import '../../widgets/top_bar.dart';
import '../../widgets/agent_section.dart';

import '../property/property_detail_screen.dart';
import '../property/property_search_screen.dart';



class HomeScreen extends ConsumerWidget {

  const HomeScreen({super.key});



  String _getImageUrl(dynamic imageData) {

    const baseUrl =
        "https://makazi.nono.co.tz/uploads/";

    const fallbackImage =
        "https://images.unsplash.com/photo-1600607687939-ce8a6c25118c";



    if(imageData == null){

      return fallbackImage;

    }



    String? imagePath;



    if(imageData is Map){

      imagePath =
          imageData['url'] ??
          imageData['image'] ??
          imageData['path'];

    }


    else if(imageData is String){

      imagePath = imageData;

    }


    else if(imageData is List &&
        imageData.isNotEmpty){

      return _getImageUrl(imageData.first);

    }



    if(imagePath != null &&
       imagePath.isNotEmpty){


      if(imagePath.startsWith("http")){

        return imagePath;

      }


      return "$baseUrl$imagePath";

    }


    return fallbackImage;

  }






  @override
  Widget build(BuildContext context, WidgetRef ref) {


    final categoriesAsync =
        ref.watch(categoriesProvider);


    final propertiesAsync =
        ref.watch(propertiesProvider);


    final agentsAsync =
        ref.watch(agentsProvider);





    return Scaffold(

      backgroundColor: Colors.white,


      body: SafeArea(


        child: SingleChildScrollView(


          padding:
          const EdgeInsets.all(20),



          child:Column(


            crossAxisAlignment:
            CrossAxisAlignment.start,


            children:[



              const TopBar(),


              const SizedBox(height:30),




              const HeroSection(),


              const SizedBox(height:30),





              // SEARCH
              SearchBarWidget(


                onTap: (){


                  Navigator.push(

                    context,


                    MaterialPageRoute(

                      builder: (_) =>
                      const PropertySearchScreen(),

                    ),

                  );


                },



                onFilterPressed:(){


                  debugPrint(
                    "Open filters"
                  );


                },


              ),





              const SizedBox(height:30),





              const SectionTitle(

                title:"Property Types",

              ),



              const SizedBox(height:15),




              SizedBox(


                height:110,


                child:ListView(


                  scrollDirection:
                  Axis.horizontal,


                  children:const [


                    PropertyTypeCard(

                      icon:Icons.home,

                      title:"All",

                      active:true,

                    ),



                    PropertyTypeCard(

                      icon:Icons.home_outlined,

                      title:"House",

                    ),



                    PropertyTypeCard(

                      icon:Icons.apartment,

                      title:"Apartment",

                    ),



                    PropertyTypeCard(

                      icon:Icons.park,

                      title:"Land",

                    ),



                    PropertyTypeCard(

                      icon:Icons.business,

                      title:"Office",

                    ),



                    PropertyTypeCard(

                      icon:Icons.store,

                      title:"Shop",

                    ),


                  ],


                ),

              ),






              const SizedBox(height:30),





              const SectionTitle(

                title:"Featured Properties",

              ),



              const SizedBox(height:20),





              propertiesAsync.when(


                data:(properties){


                  if(properties.isEmpty){

                    return const Text(
                      "No properties found",
                    );

                  }




                  return SizedBox(


                    height:240,


                    child:ListView.builder(


                      scrollDirection:
                      Axis.horizontal,


                      itemCount:
                      properties.length > 5
                      ? 5
                      : properties.length,



                      itemBuilder:(context,index){


                        final property =
                        properties[index];



                        return Container(


                          width:
                          MediaQuery.of(context)
                          .size.width * .45,



                          margin:
                          const EdgeInsets.only(
                            right:12,
                          ),



                          child:PropertyCard(


                            image:
                            _getImageUrl(
                              property['images'],
                            ),



                            title:
                            property['title']
                            ??
                            "Property",



                            price:
                            property['price']
                            ?.toString()
                            ??
                            "0",



                            status:
                            property['status']
                            ??
                            "Available",



                            propertyData:
                            property,



                            onTap:(){


                              Navigator.push(

                                context,

                                MaterialPageRoute(

                                  builder:(_)=>
                                  PropertyDetailScreen(

                                    property:property,

                                  ),

                                ),

                              );


                            },


                          ),


                        );


                      },


                    ),


                  );


                },



                loading:()=>const Center(

                  child:
                  CircularProgressIndicator(),

                ),



                error:(e,_)=>
                const Text(
                  "Failed to load properties",
                ),


              ),






              const SizedBox(height:30),





              const SectionTitle(

                title:"Browse by Category",

              ),



              const SizedBox(height:20),





              categoriesAsync.when(


                data:(categories){


                  return SizedBox(


                    height:130,


                    child:ListView.builder(


                      scrollDirection:
                      Axis.horizontal,


                      itemCount:
                      categories.length > 6
                      ? 6
                      : categories.length,



                      itemBuilder:(context,index){


                        final category =
                        categories[index];



                        return Padding(


                          padding:
                          const EdgeInsets.only(
                            right:12,
                          ),



                          child:CategoryBox(


                            category:
                            category,



                            color:
                            Colors.green.shade50,



                            onTap:(){


                              debugPrint(
                                category['name']
                              );


                            },


                          ),


                        );


                      },


                    ),


                  );


                },



                loading:()=>const CircularProgressIndicator(),



                error:(e,_)=>
                const SizedBox(),


              ),





              const SizedBox(height:30),





              agentsAsync.when(


                data:(agents)=>
                const AgentSection(),



                loading:()=>const CircularProgressIndicator(),



                error:(e,_)=>
                const SizedBox(),


              ),


            ],


          ),


        ),


      ),


    );


  }


}