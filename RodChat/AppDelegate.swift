//
//  AppDelegate.swift
//  RodChat
//
//  Created by Rodrigo Aguilar on 4/28/16.
//  Copyright © 2016 bContext. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Message.registerSubclass()
        let configuration = ParseClientConfiguration {
            $0.applicationId = "myAppId"
            $0.server = "http://your-parse-server-ip/parse"
        }
        
        Parse.initializeWithConfiguration(configuration)
        return true
    }

}

