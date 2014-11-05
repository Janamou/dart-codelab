import 'dart:html';

InputElement noteInput;
UListElement notesWrapper;
ButtonElement notesDeleteAll;
List notes;

void main() {
  noteInput = querySelector("#note_add_input");
  noteInput.onChange.listen(createNote); 
  
  notesWrapper = querySelector("#notes_wrapper");
  
  notesDeleteAll = querySelector("#notes_delete_all");
  notesDeleteAll.onClick.listen(deleteAll); 
  
  notes = new List();
}

void createNote(Event event) {
  String noteText = noteInput.value;
  if (noteText.isNotEmpty) {
    addNote(noteText);
  }
}

void addNote(String noteText) { 
  notes.add(new Note(noteText));
  addNoteElement(noteText);
  noteInput.value = "";
}

void addNoteElement(String noteText) {
  LIElement note = new LIElement();
  note.text = noteText; 
  addDeleteNoteButton(note);
  notesWrapper.append(note);
}

void addDeleteNoteButton(LIElement note) {
  ButtonElement deleteButton = new ButtonElement();
  deleteButton
    ..text = "Delete"
    ..classes.add("btn btn-danger btn-sm")
    ..onClick.listen(deleteNote);
  note.append(deleteButton);
}

void deleteNote(Event event) {
  LIElement actualNote = ((event.target as ButtonElement).parent as LIElement);  
  int actualIndex = notesWrapper.children.indexOf(actualNote);
  notes.removeAt(actualIndex);  
  actualNote.remove();  
}

void deleteAll(Event event) {
  notes.clear();
  notesWrapper.children.clear();
}

class Note {
  String text;
  
  Note(this.text);
}