//
//  RequestsViewController.swift
//  LanguageOM
//
//  Created by Gian Marco Valentino on 6/18/16.
//  Copyright © 2016 Valentino. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RequestsViewController: UIViewController {

    let rootRef = FIRDatabase.database().reference()
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        //let userID = FIRAuth.auth()?.currentUser?.uid
        let displayDate = getRoundedDate(NSDate())
        datePicker.setDate(displayDate, animated: false)
        //let request = ["name" : self.nameText.text!, "date" : ]
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getRoundedDate(inDate: NSDate) -> NSDate {
        let minuteInterval = 10
        let dateComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.Minute, fromDate: inDate)
        let minutes = dateComponents.minute
        
        let minutesF = NSNumber(integer: minutes).floatValue
        let minuteIntervalF = NSNumber(integer: minuteInterval).floatValue
        
        // Determine whether to add 0 or the minuteInterval to time found by rounding down
        let roundingAmount = (fmodf(minutesF, minuteIntervalF)) > minuteIntervalF/2.0 ? minuteInterval : 0
        let minutesRounded = (minutes / minuteInterval) * minuteInterval
        let timeInterval = NSNumber(integer: (60 * (minutesRounded + roundingAmount - minutes))).doubleValue
        let roundedDate = NSDate(timeInterval: timeInterval, sinceDate: inDate )
        
        return roundedDate
    }
    
    @IBAction func makeRequest(sender: UIButton) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy E h:mma"
        
        let name = nameText?.text
        let date = dateFormatter.stringFromDate(datePicker.date)
        
        let request = ["studentid" : name!, "date" : date]
        let requestID = FIRDatabase.database().reference().child("requests").childByAutoId().key
        FIRDatabase.database().reference().child("requests").child(requestID).setValue(request)
        FIRDatabase.database().reference().child("teachers").observeSingleEventOfType(.Value, withBlock: {(snapshot) -> Void in
            for item in snapshot.children {
                let teacherid = item.key!!
                FIRDatabase.database().reference().child("teachers").child(teacherid).child("requests").child(requestID).setValue("new")
            }
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
