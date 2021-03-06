import 'package:flutter/foundation.dart';

import '../helpers/database.dart';
import '../json_parser/flow_node.dart';
import '../json_parser/flow_tree.dart';
import '../user_response.dart';

//ToDo: Separate these two
///Class for single App store
class AppState {

  ///Constructor
  AppState({
    @required this.currentNode,
    @required this.dashBoardNode,
    @required this.userResponse,
    @required this.database,
  });

  ///Initializing store for the first time
  AppState.initialState(String flowPath, String dataPath, this.database) {
    FlowTree(flowPath, dataPath);
    userResponse = UserResponse();
  }

  ///variable to store current node
  FlowNode currentNode;

  ///variable to store dashboard node
  FlowNode dashBoardNode;

  ///variable to store user response
  UserResponse userResponse;

  Database database;


}
