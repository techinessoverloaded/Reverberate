//
//  SessionManager.swift
//  Reverberate
//
//  Created by arun-13930 on 10/08/22.
//

import Foundation
import CoreData
import UIKit
import AVKit

class SessionManager
{
    // Singleton Object
    static let shared = SessionManager()
    
    // Prevent Instantiation
    private init() {}
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let contextSaveAction = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
    var isUserLoggedIn: Bool
    {
        get
        {
            return UserDefaults.standard.string(forKey: GlobalConstants.currentUserId) != nil
        }
    }
    
    func fetchUser(withId id: String) -> User?
    {
        print("fetchUser called")
        var allUsers: [User]!
        do
        {
            allUsers = try context.fetch(User.fetchRequest())
            print(allUsers ?? "nil")
        }
        catch
        {
            print("An error occurred while fetching users \(error)!")
            return nil
        }
        let indexOfFoundUser = allUsers.firstIndex(where: { $0.id! == id })!
        let foundUser = allUsers[indexOfFoundUser]
        return foundUser
    }
    
    func doesUserAlreadyExist(phone: String, email: String) -> Bool
    {
        var allUsers: [User]!
        do
        {
            allUsers = try context.fetch(User.fetchRequest())
            print(allUsers ?? "nil")
        }
        catch
        {
            print("An error occurred while fetching users \(error)!")
            return false
        }
        return !allUsers.allSatisfy {
            $0.email != email && $0.phone != phone
        }
    }
    
    func createNewUserWith(name: String, phone: String, email: String, password: String) -> User
    {
        let newUser = User(context: context)
        newUser.id = UUID().uuidString
        newUser.profilePicture = UIImage(systemName: "person.crop.circle.fill")!.withTintColor(.systemGray).jpegData(compressionQuality: 1)
        newUser.name = name
        newUser.phone = phone
        newUser.email = email
        newUser.password = password
        newUser.favouriteSongs = []
        newUser.favouriteArtists = []
        newUser.playlists = []
        newUser.favouriteAlbums = []
        contextSaveAction()
        let defaultPlaylist = Playlist()
        defaultPlaylist.name = "Default Playlist"
        defaultPlaylist.setSongs( [DataProcessor.shared.getSong(named: "Arabic Kuthu")!])
        newUser.addToPlaylists(defaultPlaylist)
        UserDefaults.standard.set(newUser.id, forKey: GlobalConstants.currentUserId)
        UserDefaults.standard.set(false, forKey: GlobalConstants.isFirstTime)
        GlobalVariables.shared.currentUser = newUser
        return newUser
    }
    
    func validateUser(email: String, password: String) -> User?
    {
        var allUsers: [User]!
        do
        {
            allUsers = try context.fetch(User.fetchRequest())
            print(allUsers ?? "No users")
        }
        catch
        {
            print("Error in retrieving saved Users !")
            return nil
        }
        let filteredUsers = allUsers.filter {
            $0.email == email && $0.password == password
        }
        if filteredUsers.isEmpty
        {
            return nil
        }
        return filteredUsers[0]
    }
    
    func validateUser(phone: String, password: String) -> User?
    {
        var allUsers: [User]!
        do
        {
            allUsers = try context.fetch(User.fetchRequest())
            print(allUsers ?? "No users")
        }
        catch
        {
            print("Error in retrieving saved Users !")
            return nil
        }
        let filteredUsers = allUsers.filter {
            $0.phone == phone && $0.password == password
        }
        if filteredUsers.isEmpty
        {
            return nil
        }
        return filteredUsers[0]
    }
    
    func loginUser(_ user: User)
    {
        UserDefaults.standard.set(user.id, forKey: GlobalConstants.currentUserId)
        UserDefaults.standard.set(false, forKey: GlobalConstants.isFirstTime)
        GlobalVariables.shared.currentUser = user
        DataManager.shared.clearRecentlyPlayedItems()
        NotificationCenter.default.post(name: .userLoggedInNotification, object: nil, userInfo: nil)
    }
    
    func logoutUser()
    {
        UserDefaults.standard.set(nil, forKey: GlobalConstants.currentUserId)
        UserDefaults.standard.set(true, forKey: GlobalConstants.isFirstTime)
        try! AVAudioSession.sharedInstance().setActive(false)
        if GlobalVariables.shared.avAudioPlayer != nil
        {
            GlobalVariables.shared.avAudioPlayer.stop()
        }
        DataManager.shared.clearRecentlyPlayedItems()
        NotificationCenter.default.post(name: .userLoggedOutNotification, object: nil)
    }
}
