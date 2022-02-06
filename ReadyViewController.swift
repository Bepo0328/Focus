//
//  ViewController.swift
//  Focus
//
//  Created by 전윤현 on 2022/02/06.
//

import UIKit

class ReadyViewController: UIViewController {
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var startButton: UIButton!
    @IBOutlet weak private var durationLabel: UILabel!
    @IBOutlet weak private var slider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func presentMedalList() {
        print("medal list")
    }

    @IBAction func start() {
        print("start")
    }
    
    @IBAction func durationDidChange() {
        print(slider.value)
    }
}

