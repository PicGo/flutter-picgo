import 'package:flutter/material.dart';

abstract class BaseLoadingPageState<T extends StatefulWidget> extends State<T> {
  /// 当前状态，默认状态为LOADING
  LoadState state;

  @override
  void initState() {
    super.initState();
    state = LoadState.LOADING;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ?? AppBar(),
      body: _buildStateWidget,
    );
  }

  Widget get _buildStateWidget {
    switch (state) {
      case LoadState.EMTPY:
        return buildEmtpy();
      case LoadState.ERROR:
        return buildError();
      case LoadState.LOADING:
        return buildLoading();
      case LoadState.SUCCESS:
        return buildSuccess();
    }
    return buildError();
  }

  Widget buildEmtpy();
  Widget buildError();
  Widget buildLoading();
  Widget buildSuccess();
  AppBar get appBar;
}

enum LoadState { LOADING, EMTPY, ERROR, SUCCESS }
