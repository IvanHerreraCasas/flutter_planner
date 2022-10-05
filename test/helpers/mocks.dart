import 'package:activities_repository/activities_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:flutter_planner/reminders/reminders.dart';
import 'package:flutter_planner/routine/routine.dart';
import 'package:flutter_planner/schedule/schedule.dart';
import 'package:flutter_planner/settings/settings.dart';
import 'package:flutter_planner/sign_in/sign_in.dart';
import 'package:flutter_planner/sign_up/sign_up.dart';
import 'package:flutter_planner/task/task.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:reminders_repository/reminders_repository.dart';
import 'package:routines_repository/routines_repository.dart';
import 'package:tasks_repository/tasks_repository.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockActivitiesRepository extends Mock implements ActivitiesRepository {}

class MockRoutinesRepository extends Mock implements RoutinesRepository {}

class MockTasksRepository extends Mock implements TasksRepository {}

class MockRemindersRepository extends Mock implements RemindersRepository {}

class MockGoRouter extends Mock implements GoRouter {}

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockSignInBloc extends MockBloc<SignInEvent, SignInState>
    implements SignInBloc {}

class MockSignUpBloc extends MockBloc<SignUpEvent, SignUpState>
    implements SignUpBloc {}

class MockPlannerBloc extends MockBloc<PlannerEvent, PlannerState>
    implements PlannerBloc {}

class MockScheduleBloc extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

class MockActivityBloc extends MockBloc<ActivityEvent, ActivityState>
    implements ActivityBloc {}

class MockRoutineBloc extends MockBloc<RoutineEvent, RoutineState>
    implements RoutineBloc {}

class MockTaskBloc extends MockBloc<TaskEvent, TaskState> implements TaskBloc {}

class MockMyDetailsBloc extends MockBloc<MyDetailsEvent, MyDetailsState>
    implements MyDetailsBloc {}

class MockRemindersCubit extends MockCubit<RemindersState>
    implements RemindersCubit {}
