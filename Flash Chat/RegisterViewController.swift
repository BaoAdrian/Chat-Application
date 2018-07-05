//
//  RegisterViewController.swift
//  Flash Chat
//
//  
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {

    
    // IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // Triggers the registration process
    @IBAction func registerPressed(_ sender: AnyObject) {
        
        // Implemented for UI Enhancement
        SVProgressHUD.show()
        
        
        // Set up a new user on our Firbase database
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) {
            
            (user, error) in
            
            if error != nil {
                // print("There was an error registering user, \(error)")
                // User already exists or some unknown error has occurred upon request to register
                // TODO: Notify the user an account has already been created with entered email
            } else {
                // success
                // print("Registration successful")
                
                SVProgressHUD.dismiss()
                
                // Continute once user information is created and verified
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
            
        }
        

        
        
    } 
    
    
}
