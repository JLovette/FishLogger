//
//  SelectStream.swift
//  FishLogger
//
//  Created by Jamie Lovette on 7/13/18.
//  Copyright © 2018 Jamie Lovette Labs. All rights reserved.
//

import UIKit
import CoreData

class SelectStream: UIViewController {
    
    @IBOutlet weak var streamFlow: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
      
        
    }
    
    @IBAction func findFlow() {
        let usgsQuery: String = "http://waterservices.usgs.gov/nwis/iv/?format=json&sites=01332500&parameterCd=00060,00065&siteStatus=all"
        guard let url = URL(string: usgsQuery) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        let session = URLSession.shared
        /**let task = session.dataTask(with: urlRequest, completionHandler:{ _, _, _ in })
        
        task.resume()

        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            // do stuff with response, data & error here
        }
        task.resume()
        */
        let task = session.dataTask(with: urlRequest) {
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
                guard let response = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                print("The USGS is: " + response.description)
                /**guard let foundFlow = response["value"]/**["timeSeries"][0]["variable"]["variableName"] */ as? String else {
                    print("Could not get todo title from JSON")
                    return
                }*/
               
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()

    }
    
}
