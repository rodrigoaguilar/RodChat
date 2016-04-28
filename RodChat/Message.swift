//
//  Message.swift
//  RodChat
//
//  Created by Rodrigo Aguilar on 4/28/16.
//  Copyright © 2016 bContext. All rights reserved.
//

import Parse
import JSQMessagesViewController

class Message: PFObject, PFSubclassing {
    
    @NSManaged var text: String
    @NSManaged var senderId: String

    static func parseClassName() -> String {
        return "Message"
    }
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    func jsqMessage() -> JSQMessage {
        return JSQMessage(senderId: senderId, displayName: "", text: text)
    }
}