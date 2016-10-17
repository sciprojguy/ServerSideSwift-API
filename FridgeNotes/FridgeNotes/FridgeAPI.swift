//
//  FridgeAPI.swift
//  FridgeNotes
//
//  Created by Chris Woodard on 10/8/16.
//  Copyright © 2016 Minimal. All rights reserved.
//

import Foundation

/************************************************************************
 * Really simplified NSURLSession-based REST client.
 ************************************************************************/

public typealias CallBack = ([String:Any]) -> Void

var session:URLSession? = URLSession.shared

// this is a HTTP address, which means you have to add a whitelist entry to Info.plist
// for iOS9+ to not reject it
let urlBase:String = "http://fridgenotes.local:8090"

// connects to http://fridgenotes.local:8090
// GET /notes HTTP/1.1
public func getnotes(cb:@escaping CallBack) {
    let url = URL(string: "\(urlBase)/notes")
    var request = URLRequest(url: url!)
    request.httpMethod = "GET"
    let task = session?.dataTask(with: request, completionHandler: { data, response, error in
        // we're inside NSURLSession's callback closure now.  we process the response *it* got
        // and then call our own CallBack callback with the results of the request
        do {
            var results:[String:Any] = [:]
            if let theData = data {
                let dict = try JSONSerialization.jsonObject(with: theData, options: .mutableContainers)
                results["data"] = dict
            }
            if let theResponse = response {
                results["response"] = theResponse
            }
            results["error"] = error
            cb(results)
        }
        catch {
            cb(["Error":"Epic Fail"])
        }
    })
    task?.resume()
}

// connects to http://fridgenotes.local:8090
// POST /notes HTTP/1.1
// <headers>
// <body>
public func post(notes:[Note], cb:@escaping CallBack) {
    let url = URL(string: "\(urlBase)/notes")
    var request = URLRequest(url: url!)
    
    // set method to POST
    request.httpMethod = "POST"
    
    // set request Content-Type header to MIME type application/json.  this tells
    // the server that the body is JSON and needs to be deserialized
    request.allHTTPHeaderFields = [
        "Content-Type" : "application/json"
    ]
    
    // construct body from list of notes in parameter, mapped to serialized JSON format
    let strBody = "[" + notes.map { return $0.json() }.joined(separator: ",") + "]"
    request.httpBody = strBody.data(using: .utf8)
    
    let task = session?.dataTask(with: request, completionHandler: { data, response, error in
        // we're inside NSURLSession's callback closure now.  we process the response *it* got
        // and then call our own CallBack callback with the results of the request
        do {
            var results:[String:Any] = [:]
            if let theData = data {
                let dict = try JSONSerialization.jsonObject(with: theData, options: .mutableContainers)
                results["data"] = dict
            }
            if let theResponse = response {
                results["response"] = theResponse
            }
            results["error"] = error
            cb(results)
        }
        catch {
            cb(["Error":"Epic Fail"])
        }
    })
    task?.resume()
}
