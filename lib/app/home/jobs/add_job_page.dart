import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker/services/database.dart';

class AddJobPage extends StatefulWidget {
  final Database database;

  const AddJobPage({Key key, @required this.database}) : super(key: key);

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddJobPage(
          database: database,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _AddJobPageState createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  int _ratePerHour;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        print('form saved : $_name $_ratePerHour');
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();

        if (allNames.contains(_name)) {
          showAlertDialog(
            context,
            title: 'Name is already used',
            content: 'Please choose a different name',
            defaultActionText: 'Ok',
          );
        } else {
          final job = Job(name: _name, ratePerHour: _ratePerHour);
          await widget.database.createJob(job);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: 'Operation failed',
          exception: e,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text('New Job'),
        centerTitle: true,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onPressed: _submit,
          ),
        ],
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildern(),
      ),
    );
  }

  List<Widget> _buildFormChildern() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Job name'),
        textCapitalization: TextCapitalization.sentences,
        onSaved: (value) => _name = value.trim(),
        validator: (value) => value.isNotEmpty ? null : "Name cannot be empty",
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Rate per hour'),
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
        validator: (value) => value.isEmpty
            ? 'Rate per hour cannot be empty'
            : int.parse(value) <= 0
                ? 'Rate per hour cannot less than or equal 0'
                : null,
        keyboardType: TextInputType.numberWithOptions(
          decimal: false,
          signed: false,
        ),
      ),
    ];
  }
}
