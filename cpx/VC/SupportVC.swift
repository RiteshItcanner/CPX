//
//  SupportVC.swift
//  Moon
//
//  Created by Ritesh Sinha on 29/07/24.
//

import UIKit

class SupportVC: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleStr: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    var menuArrayNames = [""]
    var menuArrayLogo = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        menuArrayNames = [APPLocalizable.faq,
                          APPLocalizable.term_condition,
                          APPLocalizable.privacy_policy,
        ]
        menuArrayLogo = ["faqMenu",
                         "termsMenu",
                         "privacyMenu",
        ]
        configlangauge()
    }
    
    func configlangauge() {
        titleStr.text = APPLocalizable.support_policies
//        let backImage = AppUtility.isRTL ? "icn_back_arabic" : "icn_back"
//        backBtn.setImage(UIImage(named: backImage), for: .normal)
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension SupportVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArrayNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewProfileTableViewCell", for: indexPath) as! NewProfileTableViewCell
//        cell.configData(index: indexPath.row)
        cell.lblTitle.text = menuArrayNames[indexPath.row]
        cell.imgLogo.image = UIImage(named: menuArrayLogo[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            guard let url = URL(string: "https://moon.influencer.ae/en/terms&conditions") else { return }
            UIApplication.shared.open(url)
        case 2:
            guard let url = URL(string: "https://moon.influencer.ae/en/privacy-policy") else { return }
            UIApplication.shared.open(url)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
