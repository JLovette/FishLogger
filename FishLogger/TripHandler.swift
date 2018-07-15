//
//  TripHandler.swift
//  FishLogger
//
//  Created by Jamie Lovette on 1/17/18.
//  Copyright © 2018 Jamie Lovette Labs. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol FishTripHandler {
    static func getAllTrips () -> [Trip]
    
    static func createTrip (fishCaught: Int, date: NSDate, tripName: String, tripImage: UIImage, flow: String) -> ()
    
    static func getTripsByDate (date: NSDate) -> [Trip]
    
    static func getTripsOverFishCaught (fishMin: Int) -> [Trip]
    
    static func getTotalCaught () -> Int
    
    static func deleteCoreData () -> ()
    
    static func tripCount () -> Int
}


class TripHandler: FishTripHandler {
    
    // 1
    static let managedContext =
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private static let tripEntityName = "Trip"
    
    
    static func getAllTrips() -> [Trip] {
        let fetchRequest = NSFetchRequest<Trip> (entityName: tripEntityName)
        
        if let fetchResults = try? managedContext.fetch(fetchRequest) {
            return fetchResults
        } else {
            print("Fetch Failed")
            return []
        }
        
//        return []
    }
    
    static func createTrip(fishCaught: Int, date: NSDate, tripName: String, tripImage: UIImage, flow:String) {
        let entity = NSEntityDescription.entity(forEntityName: tripEntityName, in: managedContext)!
        let trip = NSManagedObject(entity: entity, insertInto: managedContext) as! Trip
        trip.fishCaught = Int16(fishCaught)
        trip.tripDate = date as Date
        trip.tripName = tripName
        trip.tripImage = UIImageJPEGRepresentation(tripImage, 1)
        trip.flow = flow;
        do {
            try managedContext.save()
            print("Saved succeeded")
        } catch {
            print("Saved failed")
        }

        // todo
    }
    
    static func getTripsByDate(date: NSDate) -> [Trip] {
        return []
    }
    
    static func getTripsOverFishCaught(fishMin: Int) -> [Trip] {
        return []
    }
    
    static func getTotalCaught() -> Int {
        let sum = getAllTrips().reduce(0, {
            (total, trip) in
            return total + trip.fishCaught
        })
        return Int(sum)
    }
    
    static func deleteCoreData() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Trip")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    static func tripCount() -> Int {
        return getAllTrips().count
    }
    
    
}

