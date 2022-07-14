//
//  SignupDelegate.swift
//  Reverberate
//
//  Created by arun-13930 on 14/07/22.
//

protocol SignupDelegate: AnyObject
{
    func onSuccessfulSignup()
    
    func onSignupFailure()
    
    func onAccountExistsButtonTap()
}
