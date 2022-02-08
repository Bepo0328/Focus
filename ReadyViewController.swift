//
//  ViewController.swift
//  Focus
//
//  Created by 전윤현 on 2022/02/06.
//

import UIKit

extension Medal {
    init(by duration: TimeInterval) {
        if duration < 30 {
            self = .bronze
        } else if 30 <= duration && duration < 50 {
            self = .sliver
        } else {
            self = .gold
        }
    }
    
    var icon: UIImage {
        switch self {
        case .gold:
            return UIImage(named: "gold")!
        case .sliver:
            return UIImage(named: "sliver")!
        case .bronze:
            return UIImage(named: "bronze")!
        }
    }
    
    var color: UIColor {
        switch self {
        case .gold:
            return UIColor(red: 255 / 255, green: 208 / 255, blue: 81 / 255, alpha: 1)
        case .sliver:
            return UIColor(red: 177 / 255, green: 161 / 255, blue: 182 / 255, alpha: 1)
        case .bronze:
            return UIColor(red: 225 / 255, green: 179 / 255, blue: 170 / 255, alpha: 1)
        }
    }
}

extension UIView {
    func animateHighlight() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                self.transform = .identity
            })
        })
    }
}

extension UIView {
    func makeRound(masksToBounds: Bool = false) {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.cornerCurve = .continuous
        self.layer.masksToBounds = masksToBounds
    }
}

extension UIView {
    func addShadow(with color: UIColor) {
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = 5
    }
}

class ReadyViewController: UIViewController {
    private var currentMedal = Medal.bronze
    private let range: (from: Float, to: Float) = (from: 20, to: 60)
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var startButton: UIButton!
    @IBOutlet weak private var durationLabel: UILabel!
    @IBOutlet weak private var slider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        slider.value = 0
        slider.minimumValue = range.from
        slider.maximumValue = range.to
        
        startButton.makeRound()
        
        self.durationDidChange()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        if identifier == "Start" {
            let controller = segue.destination as! StartViewController
//            controller.duration = Int(slider.value) * 60
            controller.duration = 20
        }
    }
    

    @IBAction func presentMedalList() {
        print("medal list")
    }

    @IBAction func start() {
        performSegue(withIdentifier: "Start", sender: nil)
    }
    
    @IBAction func durationDidChange() {
        let medal = Medal(by: TimeInterval(slider.value))
        let medalDidChange = medal != currentMedal
        
        if medalDidChange {
            imageView.animateHighlight()
        }
        
        durationLabel.text = "\(Int(slider.value)) minutes"
        startButton.backgroundColor = medal.color
        startButton.addShadow(with: currentMedal.color)
        
        imageView.image = medal.icon
        slider.tintColor = medal.color
        
        self.currentMedal = medal
    }
}

