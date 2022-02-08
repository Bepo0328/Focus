//
//  MedalListViewController.swift
//  Focus
//
//  Created by 전윤현 on 2022/02/08.
//

import Foundation
import UIKit

extension Date {
    func formated() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd. HH:mm"
        return formatter.string(from: self)
    }
}

class MedalCell: UITableViewCell {
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
}

class MedalListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak private var tableView: UITableView!
    
    var medals: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.medals = UserDefaults.standard.object(forKey: "list") as? [[String: Any]] ?? []
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedalCell", for: indexPath) as! MedalCell
        let info = medals[indexPath.row]
        let date = info["date"] as! Date
        let duration = info["duration"] as! Seconds
        let medal = Medal(by: TimeInterval(duration / 60))
        
        cell.dateLabel.text = date.formatted()
        cell.durationLabel.text = "\(duration / 60) Minutes"
        cell.iconView?.image = medal.icon
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        medals.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
