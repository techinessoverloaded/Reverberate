//
//  GlobalConstants.swift
//  Reverberate
//
//  Created by arun-13930 on 05/07/22.
//

struct GlobalConstants
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
    static let selectionGreenColor = "selectionGreenColor"
    //Asset song names
    static let songNames: [Language: [MusicGenre: [String]]] = [
        .tamil : [
            .classical: [],
            .melody: ["aarariraro", "unmelaorukannu"],
            .western: [],
            .rap: [],
            .folk: []
        ],
        .malayalam: [
            .classical: [],
            .melody: [],
            .western: [],
            .rap: [],
            .folk: []
        ],
        .hindi: [
            .classical: [],
            .melody: [],
            .western: [],
            .rap: [],
            .folk: []
        ],
        .telugu: [
            .classical: [],
            .melody: [],
            .western: [],
            .rap: [],
            .folk: []
        ],
        .kannada: [
            .classical: [],
            .melody: [],
            .western: [],
            .rap: [],
            .folk: []
        ],
        .english: [
            .classical: [],
            .melody: [],
            .western: [],
            .rap: [],
            .folk: []
        ]
    ]
}
