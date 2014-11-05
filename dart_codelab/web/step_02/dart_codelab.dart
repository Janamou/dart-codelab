import 'dart:html';

InputElement noteInput;
UListElement notesWrapper;

void main() {
  noteInput = querySelector("#note_add_input");
  noteInput.onChange.listen(createNote); 
  
  notesWrapper = querySelector("#notes_wrapper");
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
  notesWrapper.append(note);
}