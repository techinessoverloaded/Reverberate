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
     
    //Album Release Dates
    static let albumReleaseDates: [String : String] = [
        "Beast" : "04/05/2022",
        "Beast (Telugu)" : "04/05/2022",
        "Etharkkum Thunindhavan" : "31/01/2022"
    ]
    
    //Asset song names
    static let songNames: [Language: [MusicGenre: [String]]] = [
        .tamil : [
            .classical: [
                "ullamurugudhaiya.mp3"
            ],
            .melody: [
            ], //"unmelaorukannu.m4a", "paakadha.m4a",
            .western: [],
            .rock: [
                "arabickuthu.mp3",
                "jollyogymkhana.mp3",
                "beastmode.mp3",
//                "summasurrunu.mp3",
            ],
            .folk: [
//                "vaadathambi.mp3"
            ]
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
            .rock: ["halamathitelugu.mp3", "jollyogymkhanatelugu.mp3", "beastmodetelugu.mp3"],
            .folk: []
        ],
        .kannada: [
            .classical: [],
            .melody: [],
            .western: [],
            .rock: [],
            .folk: []
        ],
    ]
}
