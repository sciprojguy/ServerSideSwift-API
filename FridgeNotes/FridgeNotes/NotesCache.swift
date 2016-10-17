import Foundation

public class NoteCache {

    var theNotes:[Note] = []
    
    static let sharedCache:NoteCache = NoteCache(initialNotes: [])
    
    public init(initialNotes:[Note]) {
        self.theNotes = initialNotes
    }
    
    public func add(note:Note) {
        self.theNotes.append(note)
    }
    
    public func remove(note:Note) {
        self.theNotes = self.theNotes.filter({ return false == $0.equals(note:note)
        })
    }
    
    public func clear() {
        self.theNotes.removeAll()
    }
    
    public func notes() -> [Note] {
        return self.theNotes.sorted { return $0.id > $1.id }
    }
}

