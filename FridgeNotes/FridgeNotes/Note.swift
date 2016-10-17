
import Foundation

public struct Note {

    let id:Int
    let from:String
    let to:String
    let text:String
    
    public init?(dict:[String:Any]) {
        guard let noteId = dict["Id"] as? Int,
              let noteFrom = dict["From"] as? String,
              let noteTo = dict["To"] as? String,
              let noteText = dict["Text"] as? String
        else {
            return nil
        }
        
        self.id = noteId
        self.from = noteFrom
        self.to = noteTo
        self.text = noteText
    }
    
    public func equals(note:Note) -> Bool {
        return note.id == self.id
    }
    
    public func dict() -> [String:Any] {
        return ["Id":self.id, "From":self.from, "To":self.to, "Text":self.text]
    }
    
    public func json() -> String {
        var jsonStr:String = ""
        let selfDict = self.dict()
        do {
            let data = try JSONSerialization.data(withJSONObject: selfDict, options: JSONSerialization.WritingOptions(rawValue: UInt(0)))
            jsonStr = String(data: data, encoding: .utf8)!
        }
        catch {
        }
        return jsonStr
    }
    
    public init?(json:String) {
        do {
            let data = json.data(using: .utf8)!
            let dict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
            guard let noteId = dict?["Id"] as? Int,
                  let noteFrom = dict?["From"] as? String,
                  let noteTo = dict?["To"] as? String,
                  let noteText = dict?["Text"] as? String
            else {
                return nil
            }
            
            self.id = noteId
            self.from = noteFrom
            self.to = noteTo
            self.text = noteText
        }
        catch {
            return nil
        }
    }
}
