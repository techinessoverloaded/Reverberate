//
//  Alphabet.swift
//  Reverberate
//
//  Created by arun-13930 on 07/09/22.
//

enum Alphabet: Int, CaseIterable
{
    var asString: String
    {
        String(describing: self)
    }
    
    case A = 0, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z
}
