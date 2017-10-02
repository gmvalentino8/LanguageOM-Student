//
//  LoginViewController.swift
//  LanguageOM
//
//  Created by Gian Marco Valentino on 6/10/16.
//  Copyright © 2016 Valentino. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    
    @IBAction func loginOnClick(sender: UIButton) {
        //Logic for Login
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setWarningField(field : UITextField, warning : String) {
        field.text = nil
        field.layer.borderColor = UIColor.redColor().CGColor
        field.attributedPlaceholder = NSAttributedString(string: warning, attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
    }
    
    @IBAction func loginUser(sender: AnyObject) {
        FIRAuth.auth()?.signInWithEmail(usernameText.text!, password: passwordText.text!, completion: {
            user, error in
            if let error = error {
                if let errorCode = FIRAuthErrorCode(rawValue: error.code) {
                    switch errorCode {
                    case .ErrorCodeWrongPassword:
                        self.setWarningField(self.passwordText, warning: "Password is Incorrect")
                        print("Password is Incorrect")
                    case .ErrorCodeUserNotFound:
                        self.setWarningField(self.usernameText, warning: "This email is not registered")
                        print("User not registered")
                    default:
                        print(errorCode)
                    }
                }
            }
            else {
                    let controller : UITabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
                    self.presentViewController(controller
                        , animated: true, completion: nil)
                
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
