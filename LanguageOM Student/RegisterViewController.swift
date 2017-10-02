//
//  RegisterViewController.swift
//  LanguageOM
//
//  Created by Gian Marco Valentino on 6/10/16.
//  Copyright © 2016 Valentino. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RegisterViewController: UIViewController {
    
    let rootRef = FIRDatabase.database().reference()
    
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var screenNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkFilled(field : UITextField) -> Bool {
        if(field.text == nil || field.text!.isEmpty) {
            setWarningField(field, warning: "Please fill out this field")
            return false
        }
        else {
            field.layer.borderColor = UIColor.blackColor().CGColor
            return true
        }
    }
    
    func matchPassword(passwordField : UITextField, passwordConfirmField : UITextField) -> Bool {
        if(passwordField.text == passwordConfirmField.text) {
            return true
        }
        else {
            setWarningField(passwordField, warning: "Passwords do not match")
            setWarningField(passwordConfirmField, warning: "Passwords do not match")
            return false
        }
    }
    
    func setWarningField(field : UITextField, warning : String) {
        field.text = nil
        field.layer.borderColor = UIColor.redColor().CGColor
        field.attributedPlaceholder = NSAttributedString(string: warning, attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
    }
    
    func returnToLogin() {
        let controller : UINavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginNavigationController") as! UINavigationController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func joinLanguageOM(sender: UIButton) {
        var checkFields : Bool = checkFilled(firstNameText)
        checkFields = checkFilled(lastNameText) && checkFields
        checkFields = checkFilled(screenNameText) && checkFields
        checkFields = checkFilled(emailText) && checkFields
        checkFields = checkFilled(passwordText) && checkFields
        checkFields = checkFilled(confirmPasswordText) && checkFields
        
        if(checkFields && matchPassword(passwordText, passwordConfirmField: confirmPasswordText)) {
        
            
            FIRAuth.auth()?.createUserWithEmail(emailText.text!, password: passwordText.text!, completion: {
                user, error in
                if let error = error {
                    if let errorCode = FIRAuthErrorCode(rawValue: error.code) {
                        switch errorCode {
                        case .ErrorCodeInvalidEmail:
                            self.setWarningField(self.emailText, warning: "This email is invalid")
                            print("Invalid Email")
                        case .ErrorCodeEmailAlreadyInUse:
                            self.setWarningField(self.emailText, warning: "This email is already in use")
                            print("Already In Use")
                        case .ErrorCodeWeakPassword:
                            self.setWarningField(self.passwordText, warning: "Requires at least 6 characters")
                            self.setWarningField(self.confirmPasswordText, warning: "Requires at least 6 characters")
                            print("Weak Password")
                        default:
                            print(errorCode)
                        }
                    }
                }
                else {
                    let account = ["firstname" : self.firstNameText.text!,
                        "lastname" : self.lastNameText.text!,
                        "screenname" : self.screenNameText.text!,
                        "email" : self.emailText.text!]
                    
                    self.rootRef.child("students").child(user!.uid).setValue(account)
                    
                    print("User Created")
                    
                    let alert = UIAlertController(title: "", message: "Congratulations! You are registered!", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "Let's get started!", style: .Default, handler: {action in self.returnToLogin()})
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }
            })
        }
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
