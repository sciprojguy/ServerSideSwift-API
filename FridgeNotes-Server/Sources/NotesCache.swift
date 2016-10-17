import Foundation

public class NoteCache {

    var theNotes:[Note] = []
    
    static let sharedCache:NoteCache = NoteCache(initialNotes: [])
    
    public init(initialNotes:[Note]) {
        self.theNotes = initialNotes
    }
    
    public func nextId() -> Int {
        let largestId = theNotes.map{$0.id}.reduce(0) { $0 > $1 ? $0 : $1 }
        return largestId+1
    }
    
    public func add(note:Note) {
        if let noteToAdd = Note(dict: ["Id":self.nextId(), "From":note.from, "To":note.to, "Text":note.text]) {
            self.theNotes.append(noteToAdd)
        }
    }
    
    public func remove(note:Note) {
        self.theNotes = self.theNotes.filter({ return false == $0.equals(note:note)
        })
    }
    
    public func notes() -> [Note] {
        return self.theNotes.sorted { return $0.id > $1.id }
    }
}

