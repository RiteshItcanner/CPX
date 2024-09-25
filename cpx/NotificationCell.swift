//
//  NotificationCell.swift
//  cpx
//
//  Created by Ritesh Sinha on 25/09/24.
//

import UIKit
import MoEngageInbox

class NotificationCell: UITableViewCell {

    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(notification: MoEngageInboxEntry) {
        title.text = notification.notificationTitle
        descLbl.text = notification.notificationBody
        timeLbl.text = notification.receivedDate?.toString(format: "hh:mm a")
        isNotificationBeenRead(notification)
    }
    
    private func isNotificationBeenRead(_ notification: MoEngageInboxEntry) {
        let blue = UIColor(named: "ThemeTextColor")
        title.textColor = !notification.isRead ? blue : .gray
        descLbl.textColor = !notification.isRead ? .black : .gray
        timeLbl.textColor = !notification.isRead ? blue : .gray
    }

}
