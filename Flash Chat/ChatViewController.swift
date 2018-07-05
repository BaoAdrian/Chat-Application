//
//  ViewController.swift
//  Flash Chat
//
//  Created by Adrian Bao on 06/22/2018.
//

import UIKit
import Firebase
import ChameleonFramework


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var messageArray : [Message] = [Message]() // Creates array of message objects
    
    // IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Setting TableView as delegate/ datasource
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        // Setting TextField as delegate
        messageTextfield.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        

        // Registering MessageCell.xib file -> Found under Custom Cell folder in project
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        
        retrieveMessages()
        
        // Removes intermediary lines of tableView
        messageTableView.separatorStyle = .none
        
    }

    
    
    
    
    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    ///////////////////////////////////////////
    
    
    
    
    /* Grabs specified info/ data and displays new cell at the current indexPath */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "icons8-name-100")
        
        // Modify appearance of cells distinguishing different users in chat
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String? {
            
            // Messages that current user sent
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
            
        } else {
            
            // We didn't send this message
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
            
        }
        
        return cell
        
    }
    
    
    
    // Controls how many cells you want created and displayed
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageArray.count
        
    }
    
    
    
    @objc func tableViewTapped() {
        
        // endEditing() triggers textFieldDidEndEditing() function below
        messageTextfield.endEditing(true)
        
    }
    
    
    
    // Adjusts the size of the message body to fit all the text the user enters
    func configureTableView() {
        
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0 // Added as a baseline
        
    }
    
    
    
    
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    ///////////////////////////////////////////

    
    
    
    
    
    // NOTE: The single function below (textFieldDidBeginEditing) has been replaced by the two following functions
    
    // This method does not adjust based on screen size of device being used
    /*func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // Animating textfield movement - needs to be adjusted to match keyboard entry animation
        UIView.animate(withDuration: 0.5) {
            /* Keyboard is 258 points HIGH and app makes adjustment to animate once the keyboard is on screen */
            self.heightConstraint.constant = 308 // 50 base height + 258 keyboard height
            
            
            // If something has changed -> update layout
            self.view.layoutIfNeeded()
        }

    }*/
 
    
    
    
    /*
        The following two methods, textFieldDidBeginEditing() and keyboardWillShow() work in
        tandem to calculate the device screen dimensions and adjust the height constraint
        of the messageTextfield in order to avoid obscurity when keyboard animation begins.
        Methods triggered once user selects text field -> messageTextfield
    */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        
    }
    
    
    
    // Get Keyboard Height and Animation When Keyboard Shows Up
    @objc func keyboardWillShow(notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            let keyboardHeight = keyboardSize.height
            
            // Safe area - iPhone X
            if #available(iOS 11.0, *) {
                heightConstraint.constant = keyboardHeight - view.safeAreaInsets.bottom + 50
            } else {
                // Remain with standard height adjustment
                heightConstraint.constant = keyboardHeight + 50
            }
            
            view.layoutIfNeeded()
        }
        
    }
    
    
    
    /*
        Linked to messageTextfield - Requires a listener to see if user tapped TableView outside
        of text field -> TapGesture declared above
    */
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // Animating textfield movement - needs to be adjusted to match keyboard entry animation
        UIView.animate(withDuration: 0.5) {
            /* Return textField back to original height constraint of 50 */
            self.heightConstraint.constant = 50
            
            
            // If something has changed -> update layout
            self.view.layoutIfNeeded()
        }
        
    }

    
    
    
    
    ///////////////////////////////////////////
    
    //MARK: - Send & Recieve from Firebase
    
    ///////////////////////////////////////////
    
    
    
    
    
    
    /*
        Once user presses send, calls database with a given reference, creates dictionary of
        user and messages key-value pairs.
    */
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        // Removes the height constraint once user presses send to remove keyboard with animation
        messageTextfield.endEditing(true)
        
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        let messagesDB = Database.database().reference().child("Messages")
        
        let messageDictionary = ["Sender": Auth.auth().currentUser?.email, "MessageBody": messageTextfield.text!]
        
        // Creates custom ID for the database to save the unique messages in the database seperate from the rest
        messagesDB.childByAutoId().setValue(messageDictionary) {
            (error, reference) in
            
            if error != nil {
                // There was an error
                // print(error)
            } else {
                
                // Success
                // print("Message saved successfully")
                
                // Reinitialize these fields
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
                
            }
            
        }
        
    }
    
    
    
    func retrieveMessages() {
        
        let messageDB = Database.database().reference().child("Messages")
        
        // Observe - when there is a new event - grab the data
        messageDB.observe(.childAdded) { (snapshot) in
            
            // Grab data from snapshot -> format to Message object -> returned as dictionary (Sender, Message Body)
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            let text = snapshotValue["MessageBody"]!
            
            let sender = snapshotValue["Sender"]!
            
            // print(text, sender)
            
            let message = Message()
            message.messageBody = text
            message.sender = sender
            
            self.messageArray.append(message)
            
            // Update the TableView with new data
            self.configureTableView()
            self.messageTableView.reloadData()
            
        }
        
    }
    

    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        do {
            try Auth.auth().signOut()
            
            // Once that is successful, return back to the main (root) menu -> Returns back to WelcomeViewController
            navigationController?.popToRootViewController(animated: true)
            
            // print("Log out successful")
            
        } catch {
            
            // print("error, there was a problem signing out")
            // TODO: alert user sign out attempt was unsuccessful
        
        }
        
        
    }
    


}
