import 'package:scoped_model/scoped_model.dart';

// import './products.dart';
import './connected-model.dart';
// import './user.dart';

class MainModel extends Model with ConnectedNotesModel, NotesLists, Utility {}