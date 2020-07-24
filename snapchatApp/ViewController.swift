//
//  ViewController.swift
//  snapchatApp
//
//  Created by El nino Cholo on 2020/07/23.
//  Copyright © 2020 El nino Cholo. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var logInbutton: UIButton!
    @IBOutlet weak var signupbutton: UIButton!
    
    var signUpMode:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        logInbutton.layer.cornerRadius = 12.5
        signupbutton.layer.cornerRadius = 12.5
        
    }
    
    
    
    @IBAction func logIn(_ sender: Any) {
        if email.text?.count == 0 || password.text?.count == 0
        {
            alertmessage(title: "Error Fields", message: "Please Fill all the field in order for you to proceed")
        }else
        {
            if let useremail = email.text
            {
                if let userpassword = password.text
                {
                    if signUpMode
                    {
                        Auth.auth().createUser(withEmail: useremail, password: userpassword) { (user, error) in
                            if error != nil
                            {
                                self.alertmessage(title: "Error", message: error!.localizedDescription)
                            }else
                            {
                                if let myuser = user
                                {
                                     print("Your account was created !")
                                Database.database().reference().child("Users").child(myuser.user.uid).child("email").setValue(myuser.user.email)
                                   
                                    self.performSegue(withIdentifier: "snapsegue", sender: self)
                                    
                                }
                                
                                
                            }
                        }
                    }else
                    {
                        Auth.auth().signIn(withEmail: useremail, password: userpassword) { (result, error) in
                            if error != nil
                            {
                                self.alertmessage(title: "Error", message: error!.localizedDescription)
                            }else
                            {
                                print("You logged In Successfully")
                                self.performSegue(withIdentifier: "snapsegue", sender: self)
                            }
                        }
                    }
                }
            }
        }
        
    }
    @IBAction func switchtosignupbutton(_ sender: Any)
    {
        if signUpMode
        {
            logInbutton.setTitle("Log In", for: UIControl.State.normal)
            signupbutton.setTitle("Switch SignUp", for: UIControl.State.normal)
            
            signUpMode = false
        }else
        {
            
            logInbutton.setTitle("Sign Up", for: UIControl.State.normal)
            signupbutton.setTitle("Switch LogIn", for: UIControl.State.normal)
            
            
            signUpMode = true
        }
    }
    
    func alertmessage(title: String,message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "ok", style: .default) { (erickhendler) in
            print("I love you so much")
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}

