import 'package:flutter/material.dart';
import 'package:flutter_app/DBHelper.dart';
import 'package:flutter_app/mynote.dart';

class NotePage extends StatefulWidget {
  NotePage(this._mynote, this._isNew);
  final Mynote _mynote;
  final bool _isNew;

  @override
  _NotePageState createState() => new _NotePageState();
}

class _NotePageState extends State<NotePage> {
  String title;
  bool btnSave = false;
  bool btnEdit = true;
  bool btnDelete = true;

  Mynote mynote;
  String createDate;

  final cTitle = TextEditingController();
  final cNote  = TextEditingController();

  var now = DateTime.now();

  bool _enabeTextField = true;

  Future addRecord() async{
    var db = DBHelper();
    String dateNow = "${now.day}-${now.month}-${now.year}";
    var mynote = Mynote(cTitle.text, cNote.text, dateNow, dateNow, now.toString());
    await db.saveNote(mynote);
    print("saved");
  }

  Future updateRecord()async{
    var db = new DBHelper();
    String dateNow = "${now.day}-${now.month}-${now.year}";
    var mynote = Mynote(cTitle.text, cNote.text, createDate, dateNow, now.toString());
    mynote.setNoteId(this.mynote.id);
    await db.UpdateNote(mynote);
  }

  void _saveData(){
    if(widget._isNew){
      addRecord();
    }else{
      updateRecord();
    }
    Navigator.of(context).pop();
  }

  void _editData(){
    setState(() {
        _enabeTextField = true;
        btnEdit = false;
        btnSave = true;
        btnDelete = true;
        title = "Edit Catatan Aini";
    });
  }

  void delete(Mynote note){
    var db = new DBHelper();
    db.DeleteNote(note);
  }

  void _confirmDelete(){
    AlertDialog alertDialog = AlertDialog(
      content: Text("Tenan e ape apus.. gak gelo to??", style: TextStyle(fontSize: 20.0),),
      actions: <Widget>[
        RaisedButton(
            color: Colors.yellow,
            child: Text("Hmmm.. iya.", style: TextStyle(color: Colors.white),),
            onPressed: (){
                Navigator.pop(context);
                delete(mynote);
                Navigator.pop(context);
            }
        ),
        RaisedButton(
            color: Colors.red,
            child: Text("Gak Jadi.",  style: TextStyle(color: Colors.white),),
            onPressed: (){
              Navigator.pop(context);
            }
        )
      ],
    );
    showDialog(context: context, child: alertDialog);
  }

  @override
  void initState() {
    if(widget._mynote != null){
        mynote = widget._mynote;
        cTitle.text = mynote.title;
        cNote.text = mynote.note;
        _enabeTextField = false;
        createDate = mynote.createDate;
        title = "My Note";
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget._isNew){
      title = "Catatan Aini";
      btnSave   = true;
      btnEdit   = false;
      btnDelete = false;
    }else{
      title = "View Catatan Aini";
    }
    return Scaffold(
      appBar: AppBar(
          title: Text(title, style: TextStyle(color: Colors.white, fontSize: 20.0),),
//          actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CreateButton(icon: Icons.save,enable: btnSave,onpress: _saveData,),
                CreateButton(icon: Icons.edit,enable: btnEdit,onpress: _editData,),
                CreateButton(icon: Icons.delete,enable: btnDelete,onpress: _confirmDelete,),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child:
              TextFormField(
                enabled: _enabeTextField,
                controller: cTitle,
                decoration: InputDecoration(
                    hintText: "Masukkan Judul..",
                    border: InputBorder.none
                ),
                style: TextStyle(fontSize: 18.0, color: Colors.grey[800]),
                maxLines: null,
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child:
              TextFormField(
                enabled: _enabeTextField,
                controller: cNote,
                decoration: InputDecoration(
                    hintText: "Masukkan Catatan..",
                    border: InputBorder.none
                ),
                style: TextStyle(fontSize: 17.0, color: Colors.grey[800]),
                maxLines: null,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.newline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class CreateButton extends StatelessWidget {
  final IconData icon;
  final bool enable;
  final onpress;

  CreateButton({this.icon, this.enable, this.onpress});
  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle, color: enable ? Colors.purple : Colors.grey
      ),
      child: IconButton(
        icon: Icon(icon),
        color: Colors.white,
        iconSize: 18.0,
        onPressed: (){
          if(enable){
            onpress();
          }
        },
      ),
    );
  }
}
