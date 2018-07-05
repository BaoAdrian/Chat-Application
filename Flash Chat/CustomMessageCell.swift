//
//  CustomMessageCell.swift
//  Flash Chat
//
//  Created by Adrian Bao on 06/22/2018.
//

import UIKit

/*
    Creating custom cell:
    -> File -> New (Command + N) -> Select Cocoa Touch Class -> Click Next -> Change Subclass to UITableViewCell ->
    Check 'Also create XIB file' -> Click Next -> Click Create (Keep in the same folder as the project - unchanged)
 */

class CustomMessageCell: UITableViewCell {


    @IBOutlet var messageBackground: UIView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var messageBody: UILabel!
    @IBOutlet var senderUsername: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }


}
