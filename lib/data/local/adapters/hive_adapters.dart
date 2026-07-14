import 'package:hive_ce/hive_ce.dart';

import '../models/app_settings.dart';
import '../models/call_event.dart';
import '../models/call_record.dart';
import '../models/note.dart';

@GenerateAdapters([
  AdapterSpec<CallRecord>(),
  AdapterSpec<CallEvent>(),
  AdapterSpec<Note>(),
  AdapterSpec<AppSettings>(),
])
part 'hive_adapters.g.dart';
