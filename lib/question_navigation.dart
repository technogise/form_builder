import 'package:flow_form/redux/actions/actions.dart';
import 'package:flow_form/redux/models/store_view_model.dart';
import 'package:flow_form/redux/store.dart';

import 'json_parser/flow_tree.dart';

class QuestionNavigation {
  final StoreViewModel _viewModel;

  QuestionNavigation(this._viewModel);

  @deprecated
  List<String> getSectionNames() {
    var sectionNode = store.state.currentNode;
    return List.from(sectionNode.child.keys);
  }

  void submitAnswer(String answerKey) {
    _viewModel.database.saveData(
      dataKey: getCurrentDataKey(),
      answer: answerKey,
    );
    _viewModel.moveToNextNode(keyForNextQuestion);
  }

  void gotoPrevious() {
    store.dispatch(NodeActions.prevNode);
  }
  /// TODO: Improve readability
  bool isRoot() {
    final currentNode = store.state.currentNode;
    final dashboardNode = store.state.dashBoardNode;
    return currentNode == dashboardNode;
  }

  String getCurrentData() {
    var currentNode = store.state.currentNode;
    return store.state.database.getCurrentData(currentNode.dataKey);
  }

  TextInputMeta getTextInputMeta() {
    return _viewModel.getTextInputMeta();
  }

  void goToNext(dynamic answer) {
    _viewModel.database.saveData(
      dataKey: getCurrentDataKey(),
      answer: answer,
    );
    String child = answer is List<dynamic> ? answer.first : answer;
    _viewModel.moveToNextNode(child);
  }

  SelectScreenMeta getSelectScreenMeta() {
    return _viewModel.getSelectScreenMeta();
  }

  String getCurrentDataKey() {
    return _viewModel.currentNode.dataKey;
  }

  /// Dashboard calls
  /// TODO: Refactor and remove
  @deprecated
  void gotoDashboard() {
    var dashBoardNode = store.state.dashBoardNode;
    store.dispatch(SetCurrentNode(dashBoardNode));
  }

  @deprecated
  void gotoSection(String sectionName) {
    var sectionNode = store.state.currentNode;
    store.dispatch(SetCurrentNode(sectionNode.child[sectionName]));
  }
}