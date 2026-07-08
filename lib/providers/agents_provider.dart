// lib/providers/agents_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/master_data_api.dart';
import '../api/agent_properties_api.dart';


// =================================
// ALL AGENTS LIST
// =================================

final agentsProvider =
    FutureProvider<List<dynamic>>((ref) async {

  try {

    final agents =
        await MasterDataApi.getAgents();

    return agents;

  } catch (e) {

    throw Exception(
      'Failed to load agents: $e',
    );

  }

});





// =================================
// SINGLE AGENT PROFILE
// =================================

final agentProfileProvider =
    FutureProvider.family<Map<String,dynamic>, int>(
  (ref, agentId) async {


    try {

      final response =
          await AgentPropertiesApi.getAgent(
            agentId,
          );


      if(response["success"] == true){

        return response;

      }


      throw Exception(
        response["message"] ??
        "Agent not found",
      );


    } catch(e){

      throw Exception(
        'Failed to load agent profile: $e',
      );

    }


  },
);






// =================================
// AGENT PROPERTIES
// =================================

final agentPropertiesProvider =
    FutureProvider.family<Map<String,dynamic>, int>(
  (ref, agentId) async {


    try {


      final response =
          await AgentPropertiesApi.getAgentProperties(
            agentId,
          );



      if(response["success"] == true){

        return response;

      }



      throw Exception(
        response["message"] ??
        "Failed to load properties",
      );



    } catch(e){


      throw Exception(
        'Failed to load agent properties: $e',
      );


    }


  },
);