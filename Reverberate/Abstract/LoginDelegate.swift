//
//  LoginDelegate.swift
//  Reverberate
//
//  Created by arun-13930 on 14/07/22.
//

protocol LoginDelegate: AnyObject
{
    func onSuccessfulLogin()
    
    func onLoginFailure()
    
    func onNoAccountButtonTap()
}
