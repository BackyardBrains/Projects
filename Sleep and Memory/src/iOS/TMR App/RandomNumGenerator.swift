//
//  RandomNumGenerator.swift
//  TMR App
//
//  Created by Robert Zhang on 6/17/17.
//  Copyright © 2017 iLaunch. All rights reserved.
//

import Foundation

class RandomNumberGenerator {
    
    
    static func generateRandomNumbers(range:Int, sampleSize:Int) -> [Int] {
        var retNumbers = [Int]()
        while retNumbers.count<sampleSize {
    
            let random = Int(arc4random_uniform(UInt32(range)))
            if retNumbers.contains(random) {
                continue
            }
            retNumbers.append(random)
    
        }
        return retNumbers
    }
    
    static func generateRandomPositions(rangeX:(Int,Int), rangeY:(Int,Int), sampleSize:Int) ->[(Int,Int)] {
        var retPositions = [(Int, Int)]()
        
        for _ in 0..<sampleSize {
            let randomX = Int(arc4random_uniform(UInt32(rangeX.1-rangeX.0))) + Int(rangeX.0)
            let randomY = Int(arc4random_uniform(UInt32(rangeY.1-rangeY.0))) + Int(rangeY.0)
            retPositions.append((randomX, randomY))
        }
        return retPositions
    }
}

extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}
