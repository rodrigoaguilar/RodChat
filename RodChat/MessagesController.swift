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
        let user = PFUser.currentUser()!
        senderId = user.objectId!
        senderDisplayName = user.email!
    }

}
