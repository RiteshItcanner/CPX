//
//  NotificationsVC.swift
//  cpx
//
//  Created by Ritesh Sinha on 16/09/24.
//

import UIKit
import MoEngageInbox

struct NotificationSection {
    var date: Date
    var messages: [MoEngageInboxEntry]
    // other properties
    
    init(date: Date, messages: [MoEngageInboxEntry]) {
        self.date = date
        self.messages = messages
        // initialize other properties if needed
    }
}

class NotificationsVC: UIViewController {

    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var notiTableView: UITableView!
    
    private let moNotification: MoEngageSDKInbox = MoEngageSDKInbox.sharedInstance
    private var messages: [MoEngageInboxEntry] = []
    private var messagesBySection: [NotificationSection] = []
//    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNotifications()
    }
    
    private func loadNotifications() {
        self.messages.removeAll()
        self.messagesBySection.removeAll()
        moNotification.getInboxMessages(forAppID: Constant.moEngageWorkspaceId) { [weak self] inboxMessages, _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.messages = inboxMessages
                self.sortNotifications()
            }
        }
    }
    
    private func loadConfig() {
//        lblTitle.text = APPLocalizable.notifications
//        tblNotifications.register(nibWithCellClass: NotifictionTableViewCell.self)
//        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
//        tblNotifications.addSubview(refreshControl)
        notiTableView.delegate = self
        notiTableView.dataSource = self
        notiTableView.reloadData()
    }
    
    func sortNotifications() {
        var groupedItems: [Date: [MoEngageInboxEntry]] = [:]
        messagesBySection.removeAll()
        // Group items by date
        for item in self.messages {
            if let receivedDate = item.receivedDate?.startOfDay {
                if var existingItems = groupedItems[receivedDate] {
                    existingItems.append(item)
                    groupedItems[receivedDate] = existingItems
                } else {
                    groupedItems[receivedDate] = [item]
                }
            }
        }

        // Sort the items within each date group
        for date in groupedItems.keys {
            if var dateItems = groupedItems[date] {
                dateItems.sort { $0.receivedDate! > $1.receivedDate! }
                groupedItems[date] = dateItems
                messagesBySection.append(NotificationSection(date: date,
                                                             messages: dateItems))
            }
        }
        messagesBySection.sort { $0.date > $1.date }
        if messagesBySection.count > 0 {
            self.emptyView.isHidden = true
            notiTableView.reloadData()
        } else {
            self.emptyView.isHidden = false
//            self.emptyLbl.text = APPLocalizable.no_data_msg
        }
        
        self.markNotificationAsRead()
    }
    
    private func markNotificationAsRead() {
        for msg in self.messages {
            if !msg.isRead {
                if let id = msg.campaignID {
                    moNotification.markInboxNotificationClicked(withCampaignID: id)
                }
            }
        }
        NotificationCenter.default.post(name: Notification.Name(NotificationKey.updateNotifications),
                                        object: nil)
    }

}

extension NotificationsVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        tableView.backgroundView = nil
        if messagesBySection.count == 0 {
//            placeholderForTable()
        }
        return messagesBySection.count
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return messagesBySection[section].messages.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.configCell(notification: messagesBySection[indexPath.section].messages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 16,
                               y: 0,
                               width: notiTableView.frame.width - 32,
                               height: 30)
        myLabel.font = UIFont(name: Font.AktivGrotsek.medium, size: 14)
        myLabel.textColor = UIColor(named: "ThemeTextColor")
//        myLabel.textAlignment = defaultAlignment
        let date = messagesBySection[section].date
        if date.isInToday {
            myLabel.text = APPLocalizable.today
        } else if date.isInYesterday {
            myLabel.text = APPLocalizable.yesterday
        }else {
            myLabel.text = date.toString(format: "dd, MMM yyyy")
        }
        let headerView = UIView()
        headerView.backgroundColor = .white
        headerView.addSubview(myLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
}
