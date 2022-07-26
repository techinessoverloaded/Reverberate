//
//  GlobalConstants.swift
//  Reverberate
//
//  Created by arun-13930 on 05/07/22.
//

import Foundation

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
    //Asset color names
    static let techinessColor = "techinessColor"
    static let darkGreenColor = "darkGreenColor"
    
    //NSNotification Names
    static let currentSongSetNotification: NSNotification.Name = NSNotification.Name("cUrReNt_SoNg_SeT_nOtIfIcAtIoN")
     
    //Album details
    static let albumDetails: [String : (String)] = [
        "Beast" : ("04/05/2022")
    ]
    
    //Artist Pictures
    static let artistPictures: [String : String] = [
        "Anirudh Ravichander" : "anirudh",
        "Jonita Gandhi" : "jonitagandhi",
        "Ku. Karthik" : "kukarthik",
        "Sivakarthikeyan" : "sivakarthikeyan",
        "Vivek" : "vivek"
    ]
    
    //Asset song names
    static let songNames: [Language: [MusicGenre: [String]]] = [
        .tamil : [
            .classical: [],
            .melody: [], //"unmelaorukannu.m4a", "paakadha.m4a",
            .western: [],
            .rock: [
                "arabickuthu.mp3",
                "jollyogymkhana.mp3",
                "beastmode.mp3",
            ],
            .folk: []
        ],
        .malayalam: [
            .classical: [],
            .melody: [],
            .western: [],
            .rock: [],
            .folk: []
        ],
        .hindi: [
            .classical: [],
            .melody: [],
            .western: [],
            .rock: [],
            .folk: []
        ],
        .telugu: [
            .classical: [],
            .melody: [],
            .western: [],
            .rock: [],
            .folk: []
        ],
        .kannada: [
            .classical: [],
            .melody: [],
            .western: [],
            .rock: [],
            .folk: []
        ],
        .english: [
            .classical: [],
            .melody: [],
            .western: [],
            .rock: [],
            .folk: []
        ]
    ]
}
