import 'dart:html';

InputElement noteInput;
UListElement notesWrapper;
ButtonElement notesDeleteAll;

void main() {
  noteInput = querySelector("#note_add_input");
  noteInput.onChange.listen(createNote); 
  
  notesWrapper = querySelector("#notes_wrapper");
  
  notesDeleteAll = querySelector("#notes_delete_all");
  notesDeleteAll.onClick.listen(deleteAll); 
}

void createNote(Event event) {
  String noteText = noteInput.value;
  if (noteText.isNotEmpty) {
    addNote(noteText);
  }
}

void addNote(String noteText) {  
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
  actualNote.remove();  
}

void deleteAll(Event event) {
  notesWrapper.children.clear();
}