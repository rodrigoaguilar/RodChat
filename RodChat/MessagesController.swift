//
//  MessagesController.swift
//  RodChat
//
//  Created by Rodrigo Aguilar on 4/28/16.
//  Copyright © 2016 bContext. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Parse

class MessagesController: JSQMessagesViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Prep Chat"
        let user = PFUser.currentUser()!
        senderId = user.objectId!
        senderDisplayName = user.email!
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let message = PFObject(className:"Message")
        message["text"] = text
        message["senderId"] = senderId
        message.saveInBackground()
    }

}
