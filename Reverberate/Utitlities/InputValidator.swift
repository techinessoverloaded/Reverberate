//
//  InputValidator.swift
//  Reverberate
//
//  Created by arun-13930 on 07/07/22.
//

import Foundation

struct InputValidator
{
    //Prevent Instantiation
    private init() {}
    
    static func validateName(_ name: String) -> Bool
    {
        let regex = NSRegularExpression("[a-zA-Z\\s]+")
        return regex.matches(name)
    }
    
    static func validatePhone(_ phone: String) -> Bool
    {
        let regex = NSRegularExpression("(0/91)?[6-9][0-9]{9}")
        return regex.matches(phone)
    }
    
    static func validateEmail(_ email: String) -> Bool
    {
        let regex = NSRegularExpression("^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$")
        return regex.matches(email)
    }
    
    static func validatePassword(_ password: String) -> Bool
    {
        /*
            Password must contain at least one digit [0-9].
            Password must contain at least one lowercase character [a-z].
            Password must contain at least one uppercase character [A-Z].
            Password must contain at least one special character like ! @ # & ( ).
            Password must contain a length of at least 8 characters and a maximum of 20 characters.
        */
        let regex = NSRegularExpression("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#&()–[{}]:;',?/*~$^+=<>]).{8,20}$")
        return regex.matches(password)
    }
    
    static func validateConfirmPassword(_ password1: String, _ password2: String) -> Bool
    {
        return password2.trimmingCharacters(in: .whitespaces) == password1.trimmingCharacters(in: .whitespaces)
    }
}
