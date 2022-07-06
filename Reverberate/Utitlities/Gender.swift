//
//  Gender.swift
//  Reverberate
//
//  Created by arun-13930 on 06/07/22.
//

enum Gender: Int, CaseIterable
{
    case male = 0, female, others
    
    static let casesAsStrings: [String] = ["Male", "Female", "Others"]
}
