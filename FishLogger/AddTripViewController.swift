//
//  AddTripViewController.swift
//  FishLogger
//
//  Created by Jamie Lovette on 1/17/18.
//  Copyright © 2018 Jamie Lovette Labs. All rights reserved.
//

import UIKit
import CoreData

class AddTripViewController: UIViewController {

    @IBOutlet weak var streamPicker: UIPickerView!
    @IBOutlet weak var tripNameTextField: UITextField!
    @IBOutlet weak var tripDatePicker: UIDatePicker!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var fishCaught: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepper.autorepeat = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        fishCaught.text = Int(sender.value).description
    }
    
    @IBAction func addTrip() {
        guard let tripName = tripNameTextField.text else {
            return
        }
        guard tripName != "" else {
            return
        }
        guard let tripDate = tripDatePicker.date as NSDate! else {
            return
        }
        TripHandler.createTrip(fishCaught: Int(stepper.value), date: tripDate, tripName: tripName)
        tripNameTextField.text = ""
        print("Added trip with date \(stepper.value)")
        
        self.navigationController?.popViewController(animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
