//
//  SelectStream.swift
//  FishLogger
//
//  Created by Jamie Lovette on 7/13/18.
//  Copyright © 2018 Jamie Lovette Labs. All rights reserved.
//

import UIKit
import CoreData
class SelectStream: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    //MARK -Outlets and Properties

    let states = [ "Choose a State:","AK","AL","AR","AS","AZ","CA","CO","CT","DC","DE","FL","GA","GU","HI","IA","ID","IL","IN","KS","KY","LA","MA","MD","ME","MI","MN","MO","MS","MT","NC","ND","NE","NH","NJ","NM","NV","NY","OH","OK","OR","PA","PR","RI","SC","SD","TN","TX","UT","VA","VI","VT","WA","WI","WV","WY"]
    

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var streamFlow: UILabel!
    //MARK - Instance Methods
    
    //MARK - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        updateLabel()
    }
    
    @IBAction func addStream() {
        updateLabel()
        let st = states[pickerView.selectedRow(inComponent: 0)] 
        let streams = StreamHandler.findStreams(state: st)
        for str in streams {
            print(str)
        }
    }
    
    //MARK - Delgates and Data Source

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return states[row]
    }
    
    func pickerView(
        pickerView: UIPickerView,
            didSelectRow row: Int,
        inComponent component: Int)
    {
        updateLabel()
    }
    //MARK - Instance Methods
    func updateLabel(){
        streamFlow.text = states[pickerView.selectedRow(inComponent: 0)]
    }

}

