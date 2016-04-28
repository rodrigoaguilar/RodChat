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
    
    var messages = [JSQMessage]()
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        // No avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        title = "Prep Chat"
        setupBubbles()
        let user = PFUser.currentUser()!
        senderId = user.objectId!
        senderDisplayName = user.email!
        loadMessages()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: #selector(MessagesController.loadMessages))
    }
    
    private func setupBubbles() {
        let factory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = factory.outgoingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImageView = factory.incomingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleLightGrayColor())
    }
    
    func loadMessages() {
        let query = PFQuery(className: Message.parseClassName())
        query.findObjectsInBackgroundWithBlock { objects, error in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) message.")
                // Do something with the found objects
                if let objects = objects as? [Message] {
                    self.messages = objects.map { $0.jsqMessage() }
                    self.finishReceivingMessageAnimated(true)
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let message = Message()
        message.text = text
        message.senderId = senderId
        message.saveInBackground()
        messages.append(message.jsqMessage())
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessageAnimated(true)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }

}
