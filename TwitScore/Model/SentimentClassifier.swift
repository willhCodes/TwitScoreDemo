//
//  SentimentClassifier.swift
//  TwitScore
//
//  Created by willhcodes on 6/26/23.
//

import Foundation
import CoreML


struct SentimentClassifier {
    
    let tweetSentimentClassifier = TextClassifier()

    
    func sentimentClassify(input: [TextClassifierInput]) -> Double {
        var sentimentScore: Double = 0

        do {
            
            let predictions = try self.tweetSentimentClassifier.predictions(inputs: input)
            
            
            for prediction in predictions {
                
                let sentiment = prediction.label
                
                if sentiment == "Pos" {
                    sentimentScore += 1.5
                } else if sentiment == "Neg" {
                    sentimentScore -= 1
                } else if sentiment == "Neutral" {
                    sentimentScore += 0.10
                }
            }

        } catch {
            print ("there was an error with making a prediction: \(error)")
        }
        
        return sentimentScore
        
    }
    
}

