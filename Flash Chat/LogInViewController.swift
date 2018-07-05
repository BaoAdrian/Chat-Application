//
//  LogInViewController.swift
//  Flash Chat
//
//


import UIKit
import Firebase
import SVProgressHUD

class LogInViewController: UIViewController {

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   
    @IBAction func logInPressed(_ sender: AnyObject) {

        // Implemented for UI Enhancement
        SVProgressHUD.show()
        
        // Parameters entered in the text fields will be passed here for authentication
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            
            if error != nil {
                // There was an error
                // print(error!)
            } else {
                // print("Log in Successful")
                
                SVProgressHUD.dismiss()
                
                // Perfom segue that takes user to ChatViewController -> Must use .self since we are within a CLOSURE
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
            
        }
        
    }
    


    
}  
