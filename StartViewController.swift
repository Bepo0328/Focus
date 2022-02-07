//
//  StartViewController.swift
//  Focus
//
//  Created by 전윤현 on 2022/02/07.
//

import Foundation
import UIKit

enum TimerStatus {
    case active
    case background
    case lockscreen
}

class StartViewController: UIViewController {
    typealias Seconds = Int
    
    var duration: Seconds = 0
    
    private var status: TimerStatus = .active
    private var timer: Timer?
    private var start = Date()
    private var deActiveTime: Date?
    private var finished = false
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
        progressWidth.constant = progressContainer.frame.width * CGFloat(remaining) / CGFloat(duration)
    }
    
    
    @objc func tick() {
        guard status == .active else {
            return
        }
        
        if remaining <= 0 {
            timer?.invalidate()
            finished = true
            save()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.finish(success: true)
            }
        }
        
        updateDuration(seconds: remaining)
    }
    
    func save() {
        let defaults = UserDefaults.standard
        let key = "list"
        var list = defaults.object(forKey: key) as? [[String: Any]] ?? []
        
        list.append(["duration": duration, "date": start])
        defaults.setValue(list, forKey: key)
    }
    
    private func finish(success: Bool) {
        let title = success ? "성공했어요!" : "실패했어요 ㅠㅠ"
        let message = success ? "메달을 획득했어요!" : "집중하기에 실패했어요! 다시 시도해주세요!"
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        })
        
        controller.addAction(action)
        
        // 띄워진 Alert 닫기
        if self.presentedViewController != nil {
            self.dismiss(animated: false, completion: nil)
        }
        
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction private func cancel() {
        let controller = UIAlertController(title: "취소하시겠습니까?", message: "취소하면 메달을 얻을 수 없어요!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "그만하기", style: .destructive, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "계속하기", style: .cancel, handler: nil)
        
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        
        self.present(controller, animated: true, completion: nil)
    }
}
