//
//  AppDelegate.swift
//  AWS_Azure_Cognito
//
//  Created by Kseniia Zozulia on 7/17/18.
//  Copyright © 2018 Sezorus. All rights reserved.
//

import UIKit
import AWSCognitoAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return AWSCognitoAuth.default().application(app, open: url, options:options )
    }
}
