//
//  ViewController.swift
//  TwitScore
//
//  Created by willhcodes on 6/26/23.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var queryTextField: UITextField!
    
    var networkManager = NetworkManager()

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        networkManager.delegate = self
        
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
            if let queryText = queryTextField.text {
                if queryTextField.text != "" {
                    networkManager.fetchTweet(queryText)
                    queryTextField.text = ""
                }
            }
        }
    
    
}

extension ViewController: NetworkManagerDelegate {
    func didUpdateWithSentimentScore(score: Double) {
        var grade: String = ""

        switch score {

        case _ where score > 20:
            grade = "A"
        case _ where score > 10:
            grade = "B"
        case _ where score >= 0:
            grade = "C"
        case _ where score > -10:
            grade = "D"
        case _ where score > -20:
            grade = "F"
        default:
            return
        }
        scoreLabel.text = "Score: \(Int(score))"
        gradeLabel.text = "Grade: \(grade)"
    }
    
    
}
