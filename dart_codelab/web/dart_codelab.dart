import 'dart:html';
import 'dart:convert';

InputElement noteInput;
UListElement notesWrapper;
AnchorElement notesDeleteAll;
List notes;
final String NOTES_LIST = "notesList";

void main() {
  noteInput = querySelector("#note_add_form");
  noteInput.onChange.listen(createNote);  
  
  notesWrapper = querySelector("#notes_wrapper");
  
  notesDeleteAll = querySelector("#notes_delete_all");
  notesDeleteAll.onClick.listen(deleteAll); 
  
  loadData();
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
  saveToLocalStorage();
}

void addNoteElement(String noteText) {
  LIElement note = new LIElement();
  note.text = noteText; 
  addDeleteNoteButton(note);
  notesWrapper.append(note);
}

void addDeleteNoteButton(LIElement note) {
  AnchorElement anchor = new AnchorElement(href: "#");
  anchor
    ..text = "Click"
    ..onClick.listen(deleteNote);
  note.append(anchor);
}

void deleteNote(Event event) {
  event.preventDefault();
  LIElement actualNote = ((event.target as AnchorElement).parent as LIElement);  
  int actualIndex = notesWrapper.children.indexOf(actualNote);
  notes.removeAt(actualIndex);  
  actualNote.remove();  
  saveToLocalStorage();
}

void deleteAll(Event event) {
  event.preventDefault();
  notes.clear();  
  notesWrapper.children.clear();
  saveToLocalStorage();
}

void addNotes() {
  for (Note note in notes) {
    addNoteElement(note.text);
  }
}

void loadFromLoacalStorage() {
  if (window.localStorage[NOTES_LIST] != null) {
    notes = Note.fromJson(window.localStorage[NOTES_LIST]);
    addNotes();
  } else {
    notes = new List();
  }
}

void saveToLocalStorage() {
  window.localStorage[NOTES_LIST] = Note.toJson(notes);
}

void loadData() {
  HttpRequest.getString("notes.json")
    .then((String jsonString) {
      notes = Note.fromJson(jsonString);      
      addNotes();
      saveToLocalStorage();
    })
    .catchError((error) {
      loadFromLoacalStorage();
    });
}


class Note {
  String text;
  
  Note(this.text);
  
  static List fromJson(String jsonString) {
    List notes = new List();    
    Map notesJsonMap = JSON.decode(jsonString);
    List notesJsonList = notesJsonMap["notes"];
    
    for (Map noteJsonMap in notesJsonList) {
      Note note = new Note(noteJsonMap["text"]);
      notes.add(note);
    }
    return notes;
  }
  
  static String toJson(List notes) {
    Map notesJsonMap = new Map();
    List notesJsonList = new List();
    
    for (Note note in notes) {
      Map noteJsonMap = new Map();
      noteJsonMap["text"] = note.text;
      notesJsonList.add(noteJsonMap);
    }
    
    notesJsonMap["notes"] = notesJsonList;
    return JSON.encode(notesJsonMap);
  }
}