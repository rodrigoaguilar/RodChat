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
import ParseLiveQuery

class MessagesController: JSQMessagesViewController {
    
    var messages = [JSQMessage]()
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    var subscription: Subscription<Message>?

    override func viewDidLoad() {
        super.viewDidLoad()
        // No avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        title = "Rod Chat"
        setupBubbles()
        let user = PFUser.currentUser()!
        senderId = user.objectId!
        senderDisplayName = user.email!
        loadMessages()
        subscribe()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: #selector(MessagesController.loadMessages))
    }
    
    private func setupBubbles() {
        let factory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = factory.outgoingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImageView = factory.incomingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleLightGrayColor())
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func subscribe() {
        print("Subscribe: \(senderId)")
        let query = Message.query()!
        query.whereKey("senderId", notEqualTo: senderId)
        subscription = query.subscribe()
        subscription?.handle(Event.Created) { _, message in
            print("Received: \(message)")
            self.delay(0) {
                self.showTypingIndicator = !self.showTypingIndicator
            }
            
            self.delay(2) {
                self.scrollToBottomAnimated(true)
                JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
                self.messages.append(message.jsqMessage())
                self.finishReceivingMessageAnimated(true)
            }
        }
    }
    
    func loadMessages() {
        let query = Message.query()
        query?.findObjectsInBackgroundWithBlock { objects, error in
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
    
    override func collectionView(collectionView: UICollectionView,
                                 cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
            as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        
        if cell.textView != nil {
            if message.senderId == senderId {
                cell.textView!.textColor = UIColor.whiteColor()
            } else {
                cell.textView!.textColor = UIColor.blackColor()
            }
        }
        
        return cell
    }

}
