//
//  ViewController.swift
//  FishLogger
//
//  Created by Jamie Lovette on 1/17/18.
//  Copyright © 2018 Jamie Lovette Labs. All rights reserved.
//

import UIKit
import CoreData
//import Foundation

class TripViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //Used for fresh presentation during development
        //TripHandler.deleteCoreData()
        self.title = "Trips"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        print("Reloaded table data")
    }
}


extension TripViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return TripHandler.tripCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let trip = TripHandler.getAllTrips()[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "TripViewCell") as! TripTableViewCell
            if let name = trip.value(forKey: "tripName") as? String {
                cell.tripNameLabel.text = name
            }
            
            if let date = trip.value(forKey: "tripDate") as? NSDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .none
                
                let dateString = dateFormatter.string(from: date as Date)
                cell.tripDateLabel.text = dateString
                
            }
            if let photo = trip.value(forKey: "tripImage") as? Data {
                cell.tripImage.image = UIImage(data:photo,scale:1.0)
            }
            if let fishCaught = trip.value(forKey: "fishCaught") as? Int16 {
                cell.tripFishCaught.text = String(fishCaught)
            }
            
            return cell
            
            
    }
}
