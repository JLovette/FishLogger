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
    
    static func createStream (id: String, name: String, url:String) -> ()
    
    static func streamCount () -> Int
    
    static func findFlow (id:String) -> String
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
    
    static func createStream (id: String, name: String, url:String) -> () {
        let entity = NSEntityDescription.entity(forEntityName: streamEntityName, in: managedContext)!
        let stream = NSManagedObject(entity: entity, insertInto: managedContext) as! Stream
        stream.id = id
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
    
    
    static func findStreams(state:String) -> [[String:String]] {
         var streams = [[String:String]]()
        let usgsQuery: String = "https://waterservices.usgs.gov/nwis/iv/?format=json&stateCd=\(state)&parameterCd=00060,00065&siteStatus=all"
        guard let targetURL = URL(string: usgsQuery) else {
            print("Error: cannot create URL")
            return streams
        }
        print("Made the url:")
        print(usgsQuery)
       
        let urlRequest = URLRequest(url: targetURL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) { (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            print(statusCode)
            if(statusCode == 200)
            {
                do {
                    let response = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? Dictionary<String, Any>
                    guard let valueDict = response!["value"] as? [String:AnyObject] else { return }
                    guard let timeSeries = valueDict["timeSeries"] as? Array<AnyObject> else {return}
                    for stream in timeSeries {
                        guard let source = stream["sourceInfo"] as? [String:AnyObject] else {return }
                        guard let siteName = source["siteName"] as? String else {return }
                        guard let siteCode = source["siteCode"] as? Array<AnyObject> else {return }
                        guard let index = siteCode[0] as? [String:String] else {return }
                        let code = index["value"]
                        let tempStream: [String:String] = ["id":code!, "name":siteName]
                        streams.append(tempStream)
                        print(code! + ": " + siteName)
                        // streams.append(siteName)
                       // pprint.pprint(response['value']['timeSeries'][0]['sourceInfo']['siteCode'][0]["value"])
                       // print(siteName)
                    }
                }
                catch let error
                {
                    print("Error extracting flow from JSON")
                    print(error)
                }
            }
            else { print("HTTP Error Code")}
        }
        task.resume()
        return streams
    }
    
    static func findFlow(id:String) -> String {
        let usgsQuery: String = "http://waterservices.usgs.gov/nwis/iv/?format=json&sites=\(id)&parameterCd=00060,00065&siteStatus=all"
        guard let targetURL = URL(string: usgsQuery) else {
            print("Error: cannot create URL")
            return "Not found"
        }
        let request = URLRequest(url: targetURL)
        var streamflow = "Not found"
        findFlowHelper(urlRequest: request) {
            flow in
            print(flow)
            streamflow = flow
        }
        print("Should have found flow:")
        print(streamflow)
        return streamflow
    }
    
    static func findFlowHelper(urlRequest:URLRequest, completionHandler: @escaping (String) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) { (data, response, error) -> Void in
       
        let httpResponse = response as! HTTPURLResponse
        let statusCode = httpResponse.statusCode
          
            if(statusCode == 200)
            {
                do {
                    let response = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? Dictionary<String, Any>
                    guard let valueDict = response!["value"] as? [String:AnyObject] else { return }
                    guard let timeSeries = valueDict["timeSeries"] as? Array<AnyObject> else {return}
                    guard let index = timeSeries[0] as? [String:AnyObject] else {return}
                    guard let omgTheUSGSIsBadAtCoding = index["variable"] as? [String:AnyObject] else {return}
                    guard let flow = omgTheUSGSIsBadAtCoding["variableName"] as? String else {return}
                    completionHandler(flow)
                }
                catch let error
                {
                    print("Error extracting flow from JSON")
                    print(error)
                }
            }
            else { print("HTTP Error Code")}
        }
        task.resume()
    }
        
        /**let task = session.dataTask(with: urlRequest) {
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
            } catch {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }*/
}


