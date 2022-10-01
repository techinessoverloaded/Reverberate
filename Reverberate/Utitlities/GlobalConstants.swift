//
//  GlobalConstants.swift
//  Reverberate
//
//  Created by arun-13930 on 05/07/22.
//

import Foundation
import UIKit
import CoreData

class GlobalConstants
{
    //Prevent Instantiation
    private init() { }
    
    static let isFirstTime = "Is_FiRsT_tImE"
    static let isUserLoggedIn = "Is_UsEr_LoGgEd_In"
    static let themePreference = "ThEmE_PrEfErEnCe"
    static let currentUserId = "cUrReNt_UsEr_Id"
    static let preferredLanguages = "pReFeRrEd_lAnGuAgEs"
    static let preferredGenres = "PrEfErReD_gEnReS"
    static let recentlyPlayedSongNames = "rEcEnTlYpLaYeDsOnGnAmEs"
    static let recentlyPlayedAlbumNames = "rEcEnTlYpLaYeDAlbumnAmEs"
    static let previouslySelectedTabIndex = "pReViOuSlYsElEcTeDtAbInDeX"
    //Asset color names
    static let techinessColor = "techinessColor"
    static let darkGreenColor = "darkGreenColor"
    static let textHighlightColor = "textHighlightColor"
    //NSNotification Names
    static let currentSongSetNotification: NSNotification.Name = NSNotification.Name("cUrReNt_SoNg_SeT_nOtIfIcAtIoN")
     
    //Album Release Dates
    static let albumReleaseDates: [String : String] = [
        "Beast" : "04/05/2022",
        "Beast (Telugu)" : "04/05/2022",
        "Etharkkum Thunindhavan" : "31/01/2022",
        "Sarkaru Vaari Paata" : "13/06/2022",
        "Mimi" : "16/07/2021",
        "Ayyappanum Koshiyum" : "10/02/2020",
        "Valimai" : "01/01/2022",
        "Etharkkum Thunindhavan (Kannada)" : "31/01/2022"
    ]
    
    //Asset song names
    static let songNames: [Language: [MusicGenre: [String]]] = [
        .tamil : [
            .classical: [
                "ullamurugudhaiya.mp3", "ennakurai.mp3"
            ],
            .melody: [
                "mothersong.mp3"
            ],
            .western: [],
            .rock: [
                "arabickuthu.mp3", "jollyogymkhana.mp3",
                "beastmode.mp3", "summasurrunu.mp3",
                "naangaveramaari.mp3"
            ],
            .folk: [
                "vaadathambi.mp3"
            ]
        ],
        .malayalam: [
            .classical: [],
            .melody: ["ariyathariyathe.mp3", "thaalampoyi.mp3"],
            .western: [],
            .rock: [],
            .folk: ["kalakkatha.mp3"]
        ],
        .hindi: [
            .classical: ["chotisichiraiya.mp3",],
            .melody: ["hututu.mp3",],
            .western: ["rihaayide.mp3", "phuljhadiyon.mp3",],
            .rock: ["paramsundari.mp3", "yaaneyaane.mp3"],
            .folk: []
        ],
        .telugu: [
            .classical: ["kalaavathi.mp3",],
            .melody: ["murarivaa.mp3",],
            .western: ["penny.mp3",],
            .rock: ["halamathitelugu.mp3", "jollyogymkhanatelugu.mp3", "beastmodetelugu.mp3", "mamamahesha.mp3"],
            .folk: []
        ],
        .kannada: [
            .classical: ["nallaehrudayavu.mp3"],
            .melody: [],
            .western: [],
            .rock: ["silkujubba.mp3"],
            .folk: ["erueru.mp3"]
        ],
    ]
    
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static let contextSaveAction = (UIApplication.shared.delegate as! AppDelegate).saveContext
}
