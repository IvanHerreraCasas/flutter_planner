import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_planner/planner/bloc/planner_bloc.dart';

class MockPlannerBloc extends MockBloc<PlannerEvent, PlannerState>
    implements PlannerBloc {}
