//
//  ViewController.swift
//  RodChat
//
//  Created by Rodrigo Aguilar on 4/28/16.
//  Copyright © 2016 bContext. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ViewController: UIViewController {
    
    var token: dispatch_once_t = 0

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        dispatch_once(&token) { self.loginOrLoadBooks() }
    }
    
    func loginOrLoadBooks() {
        if PFUser.currentUser() == nil {
            let loginVC = PFLogInViewController()
            loginVC.delegate = self
            
            loginVC.fields = [.UsernameAndPassword, .LogInButton, .PasswordForgotten, .SignUpButton]
            let signUpViewController = PFSignUpViewController()
            signUpViewController.delegate = self
            signUpViewController.fields = [.UsernameAndPassword, .SignUpButton, .DismissButton]
            signUpViewController.emailAsUsername = true
            loginVC.signUpController = signUpViewController
            
            //loginVC.fields = [.UsernameAndPassword, .LogInButton]
            loginVC.modalPresentationStyle = UIModalPresentationStyle.FullScreen
            presentViewController(loginVC, animated: true, completion: nil)
        } else {
            loadMessages()
        }
    }
    
    func loadMessages() {
        let messagesController = MessagesController()
        navigationController?.pushViewController(messagesController, animated: true)
    }
}

extension ViewController: PFLogInViewControllerDelegate {
    
    func logInViewController(controller: PFLogInViewController, didLogInUser user: PFUser) -> Void {
        loadMessages()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewControllerDidCancelLogIn(controller: PFLogInViewController) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

extension ViewController: PFSignUpViewControllerDelegate {
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) -> Void {
        loadMessages()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) -> Void {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

