//
//  StreamHandler.swift
//  FishLogger
//
//  Created by Jamie Lovette on 1/17/18.
//  Copyright © 2018 Jamie Lovette Labs. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol FishStreamHandler {
    static func getAllStreams () -> [Stream]
    
    static func createStream (id: Int16, name: String, url:String) -> ()
    
    static func streamCount () -> Int
    
   //  func findFlow (id:Int16, completion: @escaping (String) -> ())
    
}


class StreamHandler: FishStreamHandler {
  
    
    // 1
    static let managedContext =
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private static let streamEntityName = "Stream"
    
    
    static func getAllStreams() -> [Stream] {
        let fetchRequest = NSFetchRequest<Stream> (entityName: streamEntityName)
        
        if let fetchResults = try? managedContext.fetch(fetchRequest) {
            return fetchResults
        } else {
            print("Fetch Failed")
            return []
        }
        //        return []
    }
    
    static func createStream (id: Int16, name: String, url:String) -> () {
        let entity = NSEntityDescription.entity(forEntityName: streamEntityName, in: managedContext)!
        let stream = NSManagedObject(entity: entity, insertInto: managedContext) as! Stream
        stream.id = Int16(id)
        stream.name = name
        stream.url = "https://waterservices.usgs.gov/nwis/iv/?format=waterml,2.0&sites=\(id)&parameterCd=00060,00065&siteStatus=all"
        do {
            try managedContext.save()
            print("Saved succeeded")
        } catch {
            print("Saved failed")
        }
        
        // todo
    }
    
    static func streamCount() -> Int {
        return getAllStreams().count
    }
    
    
    static func pleaseWork(id:Int64) {
        let usgsQuery: String = "http://waterservices.usgs.gov/nwis/iv/?format=json&sites=\(id)&parameterCd=00060,00065&siteStatus=all"
        guard let targetURL = URL(string: usgsQuery) else {
            print("Error: cannot create URL")
            return
        }
        let request = URLRequest(url: targetURL)
        findFlow(urlRequest: request) {
            success in
            let flow = success
            print("It found some semblance of a stream flow")
            print(flow)
        }
    }
    
    static func findFlow(urlRequest:URLRequest, completionHandler: @escaping (String) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) {
           // (data:Data?, response: URLResponse?, error: Error?) in
           (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            print("got here")
            print(responseData.description)
            // parse the result as JSON, since that's what the API provides
            do {
                let response = try JSONSerialization.jsonObject(with: responseData, options: []) as? Dictionary<String, Any>
                let valueDict = response!["value"] as! [String:AnyObject]
                let timeSeries = valueDict["timeSeries"] as! Array<AnyObject>
                let index = timeSeries[0] as! [String:AnyObject]
                let omgTheUSGSIsBadAtCoding = index["variable"] as! [String:AnyObject]
                let success = omgTheUSGSIsBadAtCoding["variableName"] as! String
                print(success)
                completionHandler(success)
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
}


