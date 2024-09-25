//
//  LanguagePopupVC.swift
//  cpx
//
//  Created by Ritesh Sinha on 19/09/24.
//

import UIKit

class LanguagePopupVC: UIViewController {

    @IBOutlet weak var enCheckMark: UIImageView!
    @IBOutlet weak var arCheckMark: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 0.8)
    }
    
    @IBAction func onClickClose(_ sender: Any) {
        self.dismiss(animated: false)
    }

    @IBAction func onClickLangauge(_ sender: UIButton) {
        if sender.tag == 101 {
            enCheckMark.isHidden = false
            arCheckMark.isHidden = true
        } else {
            enCheckMark.isHidden = true
            arCheckMark.isHidden = false
        }
        self.dismiss(animated: false)
    }
    
}
