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
    
    static func getFlow (stream: Stream) -> Int16
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
    
    static func getFlow (stream:Stream) -> Int16 {
        return 0
    }
    
    
}


