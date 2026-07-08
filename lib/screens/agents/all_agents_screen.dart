// lib/screens/agents/all_agents_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/agents_provider.dart';
import '../../widgets/agent_card.dart';
import 'agent_profile_screen.dart';



class AllAgentsScreen extends ConsumerWidget {

  const AllAgentsScreen({
    super.key,
  });



  @override
  Widget build(BuildContext context, WidgetRef ref) {


    final agentsState =
        ref.watch(agentsProvider);



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

          "All Agents",

          style:
          TextStyle(

            color:Colors.black,

            fontWeight:
            FontWeight.bold,

          ),

        ),

      ),




      body:

      agentsState.when(



        loading:()=>const Center(

          child:
          CircularProgressIndicator(),

        ),




        error:(error,stack)=>

        Center(

          child:
          Column(

            mainAxisAlignment:
            MainAxisAlignment.center,


            children:[



              Icon(

                Icons.error_outline,

                size:64,

                color:
                Colors.red.shade400,

              ),



              const SizedBox(
                height:15,
              ),



              const Text(

                "Failed to load agents",

                style:
                TextStyle(

                  fontSize:18,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),




              const SizedBox(
                height:10,
              ),




              Text(

                error.toString(),

                textAlign:
                TextAlign.center,

              ),




              const SizedBox(
                height:20,
              ),




              ElevatedButton.icon(

                onPressed:(){

                  ref.invalidate(
                    agentsProvider,
                  );

                },


                icon:
                const Icon(
                  Icons.refresh,
                ),


                label:
                const Text(
                  "Retry",
                ),

              ),


            ],

          ),

        ),





        data:(agents){



          if(agents.isEmpty){

            return const Center(

              child:
              Text(
                "No agents found",
              ),

            );

          }




          return GridView.builder(


            padding:
            const EdgeInsets.all(16),




            itemCount:
            agents.length,




            gridDelegate:

            const SliverGridDelegateWithFixedCrossAxisCount(

              crossAxisCount:2,


              crossAxisSpacing:12,


              mainAxisSpacing:12,


              childAspectRatio:0.75,


            ),




            itemBuilder:(context,index){



              final agent =
              agents[index];





              final int agentId =

              agent["id"] ?? 0;





              final String name =

              agent["fullName"]
              ??
              "Unknown Agent";





              final String properties =


              "${agent["_count"]?["properties"] ?? 0} Properties";





              final String rating =

              agent["rating"]
              ?.toString()
              ??
              "5.0";





              final String? imageUrl =

              agent["avatar"];







              return AgentCard(



                name:name,


                properties:properties,


                rating:rating,


                imageUrl:imageUrl,



                onTap:(){



                  Navigator.push(


                    context,


                    MaterialPageRoute(


                      builder:(context)=>


                      AgentProfileScreen(


                        agentId:agentId,


                      ),


                    ),


                  );



                },


              );



            },


          );


        },


      ),


    );

  }

}