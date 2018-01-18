//
//  StatViewController.swift
//  FishLogger
//
//  Created by Jamie Lovette on 1/18/18.
//  Copyright © 2018 Jamie Lovette Labs. All rights reserved.
//

import UIKit
import CoreData

class StatViewController: UIViewController {

    @IBOutlet weak var totalFish: UILabel!
    @IBOutlet weak var tripCount: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       /** totalFish.text = String(TripHandler.getTotalCaught())
        let c = TripHandler.getAllTrips().count
        tripCount.text = String(c)*/

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        totalFish.text = String(TripHandler.getTotalCaught())
        let c = TripHandler.getAllTrips().count
        tripCount.text = String(c)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
