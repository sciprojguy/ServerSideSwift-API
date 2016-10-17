//
//  NotesViewController.swift
//  FridgeNotes
//
//  Created by Chris Woodard on 10/13/16.
//  Copyright © 2016 Minimal. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var toField:UITextField? = nil
    @IBOutlet var fromField:UITextField? = nil
    @IBOutlet var noteText:UITextView? = nil
    @IBOutlet var notesList:UITableView? = nil
    
    var notesCache:NoteCache? = nil
    var notes:[Note] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.notesCache = NoteCache(initialNotes: [])
        self.notes = (self.notesCache?.notes())!
        syncWithAPI()
    }

    func syncWithAPI() {
        getnotes { results in
            self.notesCache?.clear()
            for row in (results["data"] as! [[String:Any]]) {
                if let note = Note(dict:row) {
                    self.notesCache?.add(note: note)
                }
            }
            self.notes = (self.notesCache?.notes())!
            DispatchQueue.main.async {
                self.notesList?.reloadData()
            }
        }
    }

    @IBAction public func postNote(sender:AnyObject?) -> Void {
        if let note = Note(dict: ["Id":-1, "From":self.fromField?.text, "To":self.toField?.text, "Text":self.noteText?.text]) {
            post(notes: [note] ) { results in
                self.syncWithAPI()
                DispatchQueue.main.async {
                    self.fromField?.text = ""
                    self.toField?.text = ""
                    self.noteText?.text = ""
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell)

        let note = self.notes[indexPath.row]
        cell.fromLabel.text = note.from
        cell.toLabel.text = note.to
        cell.noteLabel.text = note.text
        
        return cell
    }

}
