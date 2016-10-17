import Kitura
import SwiftyJSON
import HeliumLogger
import LoggerAPI

HeliumLogger.use()

let notes:[Note] = [
    Note(dict: ["Id":11,"From":"Joe","To":"Max","Text":"Pick Up Milk, We're Out"])!,
    Note(dict: ["Id":12,"From":"Max","To":"Joe","Text":"Store is out of milk, we need a cow"])!,
    Note(dict: ["Id":13,"From":"Joe","To":"Max","Text":"That is udderly ridiculous"])!
]

let router = Router()
let cache = NoteCache(initialNotes: notes)

router.all("/", allowPartialMatch: true, middleware: BodyParser())

router.get("/notes") {
    
    request, response, next in
    
    //serialize notes from cache as JSON
    let cachedNotes = cache.notes()
    let serializedNotes = cachedNotes.map {
        return $0.json()
    }
    let responseJson = "[" + serializedNotes.joined(separator: ",") + "]"
    Log.info("Sending \(responseJson)")
    
    //set response to 200 and send back JSON
    response.statusCode = .OK
    response.send(responseJson)
    next()
}

router.post("/notes") {
    request, response, next in
    
    // log for the demo
    Log.info("POST notes with \(request.body)")
    guard let parsedBody = request.body
    else {
        next()
        return
    }
    
    // make sure it's JSON
    switch(parsedBody) {
        case .json(let jsonBody):
            for jsonRow in jsonBody {
                let jsonDict = jsonRow.1.dictionaryObject!
                if let note = Note(dict: jsonDict) {
                    cache.add(note: note)
                    Log.info("added \(note.json())")
                    Log.info("notes: \(cache.notes())")
                }
            }
        default:
            break
    }
    response.statusCode = .OK
    response.send("{\"Status\":\"OK\"}")
    next()
}

Kitura.addHTTPServer(onPort: 8090, with: router )
Kitura.run()

