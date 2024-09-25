//
//  OnBoardingVC.swift
//  cpx
//
//  Created by Ritesh Sinha on 16/09/24.
//

import UIKit

class OnBoardingVC: UIViewController {

    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setFont()
        for family in UIFont.familyNames {
            print("Font family: \(family)")
            for font in UIFont.fontNames(forFamilyName: family) {
                print("Font: \(font)")
            }
        }

    }
    
    private func setFont() {
//        titleLbl.font = UIFont(name: Font.AktivGrotsekExtended.bold, size: 24)
//        titleLbl.font =  UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLbl.font = UIFont(name: Font.AktivGrotsekExtended.bold, size: 24)
        descLbl.font = UIFont(name: Font.AktivGrotsek.regular, size: 16)
    }
    
    @IBAction func onClickNext(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as! AuthVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    

}
