//
//  StartViewController.swift
//  Focus
//
//  Created by 전윤현 on 2022/02/07.
//

import Foundation
import UIKit

class StartViewController: UIViewController {
    typealias Seconds = Int
    
    var duration: Seconds = 0
    private var timer: Timer?
    private var start = Date()
    private var remaining: Seconds {
        duration - Int(Date().timeIntervalSince1970 - start.timeIntervalSince1970)
    }
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var durationLabel: UILabel!
    @IBOutlet weak private var progressContainer: UIView!
    @IBOutlet weak private var progressWidth: NSLayoutConstraint!
    @IBOutlet weak private var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.progressWidth.constant = 50
        self.cancelButton.makeRound()
        self.progressContainer.makeRound(masksToBounds: true)
        self.imageView.image = Medal(by: TimeInterval(duration / 60)).icon
        self.updateDuration(seconds: duration)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        }
    }
    
    func updateDuration(seconds: Seconds) {
        let minutes = seconds / 60
        let seconds = seconds % 60
        
        durationLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    
    @objc func tick() {
        updateDuration(seconds: remaining)
    }
}
