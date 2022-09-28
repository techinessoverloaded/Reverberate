//
//  SceneDelegate.swift
//  Reverberate
//
//  Created by arun-13930 on 05/07/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate
{
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions)
    {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let winScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: winScene)
        setupRootViewController()
        window!.makeKeyAndVisible()
    }

    func setupRootViewController()
    {
        let userDefaults = UserDefaults.standard
        
        if userDefaults.value(forKey: GlobalConstants.isFirstTime) == nil
        {
            userDefaults.set(true, forKey: GlobalConstants.isFirstTime)
        }
        
        if userDefaults.value(forKey: GlobalConstants.themePreference) == nil
        {
            userDefaults.set(0, forKey: GlobalConstants.themePreference)
        }
        
        if userDefaults.value(forKey: GlobalConstants.preferredLanguages) == nil
        {
            userDefaults.set([], forKey: GlobalConstants.preferredLanguages)
        }
        
        if userDefaults.value(forKey: GlobalConstants.preferredGenres) == nil
        {
            userDefaults.set([], forKey: GlobalConstants.preferredGenres)
        }
        
        if userDefaults.value(forKey: GlobalConstants.previouslySelectedTabIndex) == nil
        {
            userDefaults.set(0, forKey: GlobalConstants.previouslySelectedTabIndex)
        }
        
        if userDefaults.value(forKey: GlobalConstants.recentlyPlayedSongNames) == nil
        {
            userDefaults.set([], forKey: GlobalConstants.recentlyPlayedSongNames)
        }
        
        if userDefaults.value(forKey: GlobalConstants.recentlyPlayedAlbumNames) == nil
        {
            userDefaults.set([], forKey: GlobalConstants.recentlyPlayedAlbumNames)
        }
        
        DataManager.shared.retrieveRecentlyPlayedItems()
        
        if userDefaults.bool(forKey: GlobalConstants.isFirstTime)
        {
            window!.rootViewController = InitialViewController(style: .insetGrouped)
            window!.makeKeyAndVisible()
        }
        else
        {
            if let userId = userDefaults.string(forKey: GlobalConstants.currentUserId)
            {
                GlobalVariables.shared.currentUser = SessionManager.shared.fetchUser(withId: userId)
                if GlobalVariables.shared.currentUser!.preferredGenres!.isEmpty
                {
                    GlobalVariables.shared.currentUser!.preferredGenres = MusicGenre.allCases.filter({ $0.rawValue >= 0 }).map({ $0.rawValue })
                    GlobalConstants.contextSaveAction()
                }
                if GlobalVariables.shared.currentUser!.preferredLanguages!.isEmpty
                {
                    GlobalVariables.shared.currentUser!.preferredLanguages = Language.allCases.filter({ $0.rawValue >= 0 }).map({ $0.rawValue })
                    GlobalConstants.contextSaveAction()
                }
                let mainVc = MainViewController()
                window!.rootViewController = mainVc
                window!.makeKeyAndVisible()
                print("userId exists")
            }
            else
            {
                print("userId doesn't exist")
                let preferredGenres = userDefaults.object(forKey: GlobalConstants.preferredGenres) as! [Int16]
                let preferredLanguages = userDefaults.object(forKey: GlobalConstants.preferredLanguages) as! [Int16]
                if preferredGenres.isEmpty
                {
                    userDefaults.set(MusicGenre.allCases.filter({ $0.rawValue >= 0 }).map({ $0.rawValue }), forKey: GlobalConstants.preferredGenres)
                }
                if preferredLanguages.isEmpty
                {
                    userDefaults.set(Language.allCases.filter({ $0.rawValue >= 0 }).map({ $0.rawValue }), forKey: GlobalConstants.preferredLanguages)
                }
                let mainVc = MainViewController()
                window!.rootViewController = mainVc
                window!.makeKeyAndVisible()
            }
        }
        restoreTheme()
    }
    
    func changeRootViewController(_ newVC: UIViewController, animationOption: Int = 0)
    {
        guard window != nil else
        {
            print("Error in changing rootViewController")
            return
        }
        window!.rootViewController = newVC
        window!.makeKeyAndVisible()
        if animationOption == 0
        {
            UIView.transition(with: window!,
                              duration: 0.5,
                              options:[.transitionFlipFromRight],
                              animations: nil,
                              completion: nil)
        }
        else
        {
            UIView.transition(with: window!,
                              duration: 0.01,
                              options:[.transitionCrossDissolve],
                              animations: nil,
                              completion: nil)
        }
    }
    
    private func restoreTheme()
    {
        switch UserDefaults.standard.integer(forKey: GlobalConstants.themePreference)
        {
        case 0:
            window!.overrideUserInterfaceStyle = .unspecified
            print("System Theme")
        case 1:
            window!.overrideUserInterfaceStyle = .light
            print("Light Theme")
        default:
            window!.overrideUserInterfaceStyle = .dark
            print("Dark Theme")
        }
    }
    
    func changeTheme(themeOption: Int)
    {
        switch themeOption
        {
        case 0:
            window!.overrideUserInterfaceStyle = .unspecified
            UserDefaults.standard.set(0, forKey: GlobalConstants.themePreference)
        case 1:
            window!.overrideUserInterfaceStyle = .light
            UserDefaults.standard.set(1, forKey: GlobalConstants.themePreference)
        default:
            window!.overrideUserInterfaceStyle = .dark
            UserDefaults.standard.set(2, forKey: GlobalConstants.themePreference)
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene)
    {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

