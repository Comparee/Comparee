//
//  RandomGenerator.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/20/23.
//

import Foundation

func getRandomTwoElements<T: Equatable>(_ array: [T], avoiding elementToAvoid: T?) -> (T, T)? {
    guard array.count >= 2 else {
        return nil
    }
    
    var candidates = array
    
    if let elementToAvoid, let index = candidates.firstIndex(of: elementToAvoid) {
        candidates.remove(at: index)
    }
    
    let shuffledCandidates = candidates.shuffled()
    
    let element1 = shuffledCandidates[0]
    let element2 = shuffledCandidates[1]
    
    return (element1, element2)
}
