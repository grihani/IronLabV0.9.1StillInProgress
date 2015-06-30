//
//  AppDelegate.swift
//  IronLab
//
//  Created by CSC CSC on 22/05/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

var DataBase: FMDatabase!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let fileManager : NSFileManager = NSFileManager.defaultManager()
        var fileCopyError:NSError? = NSError()
        let pathToDocumentsFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let storePath = pathToDocumentsFolder.stringByAppendingPathComponent("/DataBase.sqlite")
        if !fileManager.fileExistsAtPath(storePath) {
            if let defaultStorePath : NSString = NSBundle.mainBundle().pathForResource("DataBase", ofType: "sqlite") {
                fileManager.copyItemAtPath(defaultStorePath as String, toPath: storePath, error: &fileCopyError)
            }
        }
        // uncomment the next part when you want to change the database
//        else {
//            println("exists")
//            if let defaultStorePath : NSString = NSBundle.mainBundle().pathForResource("DataBase", ofType: "sqlite") {
//                println("trying to save sqlite")
//                if !fileManager.contentsEqualAtPath(storePath, andPath: defaultStorePath as String) {
//                    fileManager.removeItemAtPath(storePath, error: &fileCopyError)
//                    fileManager.copyItemAtPath(defaultStorePath as String, toPath: storePath, error: &fileCopyError)
//                    println("saving")
//                }
//            }
//        }
//
        println(storePath)
        DataBase = FMDatabase(path: storePath)
        if DataBase.open() {
            println("ouverture générale de la base de donnée")
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        if DataBase.close() {
            println("dataBase was closed")
        }
    }
    
    


}

