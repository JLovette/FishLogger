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

class StreamViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Used for fresh presentation during development
        //TripHandler.deleteCoreData()
        self.title = "Steams"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        print("Reloaded table data")
    }
}


extension StreamViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StreamHandler.streamCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let stream = StreamHandler.getAllStreams()[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "StreamTableViewCell") as! StreamTableViewCell
        if let name = stream.value(forKey: "streamName") as? String {
            cell.streamName.text = name
        }
        if let flow = stream.value(forKey: "streamFlow") as? Int16 {
            cell.streamFlow.text = String(flow)
        }
        return cell
    }
}

