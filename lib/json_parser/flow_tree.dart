import 'package:formbuilder/helpers/common.dart';
import 'package:formbuilder/redux/actions/actions.dart';
import 'package:formbuilder/redux/store.dart';

import 'flow_node.dart';

///variable to store key used to fetch next question from flow.json
const String keyForNextQuestion = "nextQuestion";

///variable to store key used to fetch questionIds from flow.json
const String keyForQuestionIds = "questionIds";

///variable to store key used to fetch dependsOn value from flow.json
const String nextQuestionDependsOn = "branchDependsOn";

///variable to store key used to fetch dependsOn value from flow.json
const String answersBranch = "answerBranch";

/// Class to handle all node related operations
class FlowTree {
  ///Variable to store dashboard node
  FlowNode dashBoardNode;

  ///map to sore screen data json
  Map<String, dynamic> screenData;

  ///Constructing tree
  FlowTree(String flowPath, String screenMetadataPath) {
    Map<String, dynamic> flow;

    var assignFlow = Serializer.fetchJson(flowPath).then((parsedFlow) {
      flow = parsedFlow;
    });

    var assignData =
        Serializer.fetchJson(screenMetadataPath).then((parsedData) {
      screenData = parsedData;
    });

    Future.wait([assignFlow, assignData]).then((resolved) {
      buildFlowTree(flow);
    });
  }

  ///Building tree for all categories
  void buildFlowTree(Map<String, dynamic> dashboardFlow) {
    dashBoardNode = buildDashBoardNode();
    buildCategories(dashBoardNode, dashboardFlow);
    goToDashboard();
  }

  void buildCategories(
      FlowNode parentNode, Map<String, dynamic> dashboardFlow) {
    dashboardFlow.forEach((categoryName, categoryFlow) {
      var categoryNode = FlowNode(
        {"type": "section"},
        parentNode,
        null,
        categoryName,
      );
      buildSections(categoryFlow, categoryNode, categoryName);
      parentNode.child[categoryName] = categoryNode;
    });
  }

  void buildSections(Map<String, dynamic> categoryFlow, FlowNode categoryNode,
      String categoryName) {
    categoryFlow.forEach((sectionName, section) {
      var sectionNode = build(
        section,
        categoryNode,
        categoryName,
        sectionName,
      );
      categoryNode.child[sectionName] = sectionNode;
    });
  }

  //ToDo: Rename flow to category or current node
  ///Build tree for given
  FlowNode build(
    Map<String, dynamic> flow,
    FlowNode parent,
    String categoryName,
    String sectionName,
  ) {
    String screenId = flow[keyForQuestionIds].first;
    Map<String, dynamic> screenDetails = screenData[screenId];

    var currentNode = FlowNode(
      screenDetails,
      parent,
      screenId,
      categoryName,
      sectionName,
    );

    //ToDo: Rethink logic for this
    if (flow[keyForQuestionIds].length > 1) {
      flow[keyForQuestionIds].removeAt(0);
      var childNode = build(flow, currentNode, categoryName, sectionName);
      currentNode.child[keyForNextQuestion] = childNode;
      return currentNode;
    }

    Map<String, dynamic> childDetails = flow[keyForNextQuestion];
    currentNode.dependsOn = childDetails[nextQuestionDependsOn];
    //ToDo: Make this readable
    childDetails[answersBranch].forEach((answerKey, nextQuestion) {
      var childNode = build(
        nextQuestion,
        currentNode,
        categoryName,
        sectionName,
      );
      currentNode.child[answerKey] = childNode;
    });
    return currentNode;
  }

  ///Function which dispatched action to take user to dashboard
  void goToDashboard() {
    store.dispatch(SetCurrentNode(dashBoardNode));
    store.dispatch(SetDashBoardNode(dashBoardNode));
  }

  ///Function which gives dashboard node
  FlowNode buildDashBoardNode() {
    return FlowNode({"type": "dashboard"}, null, null, null);
  }
}
