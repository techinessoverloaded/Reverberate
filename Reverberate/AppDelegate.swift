//
//  AppDelegate.swift
//  Reverberate
//
//  Created by arun-13930 on 05/07/22.
//

import UIKit
import CoreData
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate
{
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool
    {
//        DataManager.shared.makeSongsAndAlbumsReady(onCompletion: {
//            startTime in
//            let endTime = DispatchTime.now()
//            let interval = TimeInterval(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds)
//            print("Time Taken: \(interval / 1000000000) seconds")
//            print("Number of Artists: \(DataManager.shared.availableArtists.count)")
//            print("Number of songs contributed by each artist: \n")
//            DataManager.shared.availableArtists.forEach({
//                print("\($0.name!) : \($0.contributedSongs!.count) songs : \($0.artistType!)")
//            })
//        })
        DataManager.shared.makeSongsAndAlbumsReady(onCompletion: {
            startTime in
            let endTime = DispatchTime.now()
            let interval = TimeInterval(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds)
            print("Time Taken: \(interval / 1000000000) seconds")
        })
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.
        let audioSession = AVAudioSession.sharedInstance()
        do
        {
            try audioSession.setCategory(.playback, mode: .moviePlayback, policy: .longFormAudio)
        }
        catch
        {
            print("Setting category to AVAudioSessionCategoryPlayback failed")
        }
        application.beginReceivingRemoteControlEvents()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Reverberate")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

