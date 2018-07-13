//
//  AddTripViewController.swift
//  FishLogger
//
//  Created by Jamie Lovette on 1/17/18.
//  Copyright © 2018 Jamie Lovette Labs. All rights reserved.
//

import UIKit
import CoreData

class AddTripViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tripNameTextField: UITextField!
    @IBOutlet weak var tripDatePicker: UIDatePicker!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var fishCaught: UILabel!
    @IBOutlet weak var imagePicker: UIImageView!
    
   
    
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
        TripHandler.createTrip(fishCaught: Int(stepper.value), date: tripDate, tripName: tripName, tripImage: imagePicker.image!)
        tripNameTextField.text = ""
        
        self.navigationController?.popViewController(animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectPhotoFromImageLibrary(_ sender: UITapGestureRecognizer) {
        
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        imagePicker.image = selectedImage
        
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
}
