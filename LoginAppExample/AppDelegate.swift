//
//  AppDelegate.swift
//  LoginAppExample
//
//  Created by Bartosz Nowacki on 08/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import UIKit
import SwiftyBeaver
import SVProgressHUD

let log: SwiftyBeaver.Type = {
    let l = SwiftyBeaver.self
    let console = ConsoleDestination()
    console.format = "#LOG# $DHH:mm:ss$d $L $M"
    l.addDestination(console)
    return l
}()


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupHUD()
        return true
    }
    
    fileprivate func setupHUD() {
        SVProgressHUD.setDefaultMaskType(.black)
    }
}

