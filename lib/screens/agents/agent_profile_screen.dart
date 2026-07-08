import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/agents_provider.dart';
import '../../widgets/property_card.dart';



class AgentProfileScreen extends ConsumerWidget {

  final int agentId;


  const AgentProfileScreen({
    super.key,
    required this.agentId,
  });



  @override
  Widget build(BuildContext context, WidgetRef ref) {


    final agent =
        ref.watch(agentProfileProvider(agentId));


    final properties =
        ref.watch(agentPropertiesProvider(agentId));



    return Scaffold(

      backgroundColor:
      const Color(0xFFF6F7FB),



      appBar: AppBar(

        backgroundColor:
        Colors.white,

        elevation:0,


        iconTheme:
        const IconThemeData(
          color:Colors.black,
        ),



        title:

        const Text(

          "Agent Profile",

          style:
          TextStyle(

            color:Colors.black,

            fontWeight:
            FontWeight.bold,

          ),

        ),

      ),




      body:

      RefreshIndicator(

        onRefresh:() async {

          ref.invalidate(
            agentProfileProvider(agentId),
          );


          ref.invalidate(
            agentPropertiesProvider(agentId),
          );

        },



        child:

        SingleChildScrollView(

          physics:
          const AlwaysScrollableScrollPhysics(),



          child:

          Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,


            children:[



              // ==========================
              // AGENT PROFILE CARD
              // ==========================


              agent.when(



                loading:()=>const Padding(

                  padding:
                  EdgeInsets.all(40),

                  child:
                  Center(

                    child:
                    CircularProgressIndicator(),

                  ),

                ),





                error:(error,stack)=>

                Padding(

                  padding:
                  const EdgeInsets.all(20),


                  child:
                  Text(

                    error.toString(),

                    style:
                    const TextStyle(
                      color:Colors.red,
                    ),

                  ),

                ),






                data:(response){


                  final data =
                  response["data"] ?? {};



                  final propertyCount =
                  data["_count"]?["properties"]
                  ??
                  0;



                  final rating =
                  data["rating"]?.toString()
                  ??
                  "5.0";




                  return Container(

                    width:
                    double.infinity,


                    padding:
                    const EdgeInsets.all(20),


                    color:
                    Colors.white,



                    child:

                    Column(

                      mainAxisSize:
                      MainAxisSize.min,



                      children:[




                        CircleAvatar(

                          radius:55,


                          backgroundImage:

                          data["avatar"] != null

                          ?

                          NetworkImage(
                            data["avatar"],
                          )

                          :

                          null,



                          child:

                          data["avatar"] == null

                          ?

                          const Icon(

                            Icons.person,

                            size:55,

                            color:
                            Colors.grey,

                          )

                          :

                          null,


                        ),




                        const SizedBox(
                          height:15,
                        ),





                        Text(

                          data["fullName"]
                          ??
                          "Unknown Agent",


                          maxLines:1,


                          overflow:
                          TextOverflow.ellipsis,



                          style:
                          const TextStyle(

                            fontSize:23,

                            fontWeight:
                            FontWeight.bold,

                          ),

                        ),





                        const SizedBox(
                          height:12,
                        ),





                        Wrap(

                          alignment:
                          WrapAlignment.center,


                          spacing:10,


                          runSpacing:10,


                          children:[



                            _infoChip(

                              Icons.star,

                              rating,

                            ),




                            _infoChip(

                              Icons.home,

                              "$propertyCount Properties",

                            ),



                          ],

                        ),





                        const SizedBox(
                          height:15,
                        ),





                        Wrap(

                          alignment:
                          WrapAlignment.center,


                          spacing:8,


                          runSpacing:8,


                          children:[



                            if(data["phone"] != null)

                            _contactChip(

                              Icons.phone,

                              data["phone"],

                            ),




                            if(data["email"] != null)

                            _contactChip(

                              Icons.email,

                              data["email"],

                            ),





                            if(data["location"] != null)

                            _contactChip(

                              Icons.location_on,

                              data["location"],

                            ),



                          ],

                        ),





                        const SizedBox(
                          height:20,
                        ),





                        Row(

                          children:[



                            Expanded(

                              child:
                              ElevatedButton.icon(

                                onPressed:(){},


                                icon:
                                const Icon(
                                  Icons.phone,
                                ),



                                label:
                                const Text(
                                  "Call",
                                ),


                              ),

                            ),




                            const SizedBox(
                              width:10,
                            ),





                            Expanded(

                              child:
                              ElevatedButton.icon(

                                onPressed:(){},


                                icon:
                                const Icon(
                                  Icons.chat,
                                ),


                                label:
                                const Text(
                                  "Chat",
                                ),


                              ),

                            ),




                          ],

                        ),




                      ],

                    ),

                  );


                },


              ),






              const SizedBox(
                height:20,
              ),






              const Padding(

                padding:
                EdgeInsets.symmetric(
                  horizontal:16,
                ),


                child:

                Text(

                  "Agent Properties",

                  style:
                  TextStyle(

                    fontSize:20,

                    fontWeight:
                    FontWeight.bold,

                  ),

                ),

              ),






              const SizedBox(
                height:10,
              ),






              properties.when(



                loading:()=>const Center(

                  child:
                  CircularProgressIndicator(),

                ),





                error:(error,stack)=>

                Padding(

                  padding:
                  const EdgeInsets.all(20),


                  child:
                  Text(
                    error.toString(),
                  ),

                ),





                data:(response){


                  final List list =
                  response["data"] ?? [];




                  if(list.isEmpty){

                    return const Padding(

                      padding:
                      EdgeInsets.all(20),


                      child:
                      Text(
                        "No properties found",
                      ),

                    );

                  }





                  return GridView.builder(



                    shrinkWrap:true,


                    physics:
                    const NeverScrollableScrollPhysics(),




                    padding:
                    const EdgeInsets.all(12),




                    gridDelegate:

                    const SliverGridDelegateWithFixedCrossAxisCount(

                      crossAxisCount:2,


                      crossAxisSpacing:12,


                      mainAxisSpacing:12,


                      childAspectRatio:0.65,


                    ),




                    itemCount:
                    list.length,




                    itemBuilder:(context,index){


                      final property =
                      list[index];



                      return PropertyCard(


                        image:

                        property["image"]
                        ??
                        "",




                        title:

                        property["title"]
                        ??
                        "Property",





                        price:

                        property["price"]
                        ?.toString()
                        ??
                        "0",




                        status:

                        property["status"]
                        ??
                        "",



                      );


                    },



                  );


                },



              ),




              const SizedBox(
                height:30,
              ),



            ],


          ),


        ),

      ),


    );

  }





  Widget _infoChip(
      IconData icon,
      String text,
      ){

    return Container(

      padding:
      const EdgeInsets.symmetric(
        horizontal:12,
        vertical:7,
      ),


      decoration:
      BoxDecoration(

        color:
        Colors.grey.shade100,

        borderRadius:
        BorderRadius.circular(20),

      ),



      child:

      Row(

        mainAxisSize:
        MainAxisSize.min,


        children:[


          Icon(
            icon,
            size:16,
          ),



          const SizedBox(
            width:5,
          ),



          Text(
            text,
          ),


        ],

      ),

    );


  }






  Widget _contactChip(
      IconData icon,
      String text,
      ){

    return Container(

      constraints:
      const BoxConstraints(
        maxWidth:250,
      ),


      padding:
      const EdgeInsets.symmetric(
        horizontal:10,
        vertical:7,
      ),



      decoration:
      BoxDecoration(

        color:
        Colors.blue.shade50,


        borderRadius:
        BorderRadius.circular(20),

      ),



      child:

      Row(

        mainAxisSize:
        MainAxisSize.min,


        children:[



          Icon(
            icon,
            size:15,
          ),



          const SizedBox(
            width:5,
          ),




          Flexible(

            child:
            Text(

              text,

              overflow:
              TextOverflow.ellipsis,

            ),

          ),



        ],


      ),


    );


  }


}