//
//  FAQViewController.swift
//  Moon
//
//  Created by PYTHON on 27/10/23.
//

import UIKit

class FAQViewController: UIViewController {
    @IBOutlet var lblFirstQue: UILabel!
    @IBOutlet var lbl2ndQue: UILabel!
    @IBOutlet var lbl3rdQue: UILabel!
    @IBOutlet var lbl4thQue: UILabel!
    @IBOutlet var lbl5thQue: UILabel!
    @IBOutlet var lbl6thQue: UILabel!

    @IBOutlet var lbl1stAns: UILabel!
    @IBOutlet var lbl2ndAns: UILabel!
    @IBOutlet var lbl3rdAns: UILabel!
    @IBOutlet var lbl4thAns: UILabel!
    @IBOutlet var lbl5thAns: UILabel!
    @IBOutlet var lbl6thAns: UILabel!

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.lblTitle.font = UIFont(name: "GraphikArabic-Regular", size: 18)
        configLanguage()
    }

    func configLanguage() {
//        lblFirstQue.textAlignment = defaultAlignment
//        lbl2ndQue.textAlignment = defaultAlignment
//        lbl3rdQue.textAlignment = defaultAlignment
//        lbl4thQue.textAlignment = defaultAlignment
//        lbl5thQue.textAlignment = defaultAlignment
//        lbl6thQue.textAlignment = defaultAlignment
//
//        lbl1stAns.textAlignment = defaultAlignment
//        lbl2ndAns.textAlignment = defaultAlignment
//        lbl3rdAns.textAlignment = defaultAlignment
//        lbl4thAns.textAlignment = defaultAlignment
//        lbl5thAns.textAlignment = defaultAlignment
//        lbl6thAns.textAlignment = defaultAlignment

        lblFirstQue.text = APPLocalizable.faq_1st_que
        lbl2ndQue.text = APPLocalizable.faq_2nd_que
        lbl3rdQue.text = APPLocalizable.faq_3rd_que
        lbl4thQue.text = APPLocalizable.faq_4th_que
        lbl5thQue.text = APPLocalizable.faq_5th_que
        lbl6thQue.text = APPLocalizable.faq_6th_que

        lbl1stAns.text = APPLocalizable.faq_1st_ans
        lbl2ndAns.text = APPLocalizable.faq_2nd_ans
        lbl3rdAns.text = APPLocalizable.faq_3rd_ans
        lbl4thAns.text = APPLocalizable.faq_4th_ans
        lbl5thAns.text = APPLocalizable.faq_5th_ans
        lbl6thAns.text = APPLocalizable.faq_6th_ans
        
        lblTitle.text = APPLocalizable.faq
        
//        let image = UIImage(named: AppUtility.isRTL ? "icn_back_arabic" : "icn_back")
//        btnBack.setImage(image, for: .normal)
    }

    func hideAllAnswers(label: UILabel) {
        if label.isHidden {
            lbl1stAns.isHidden = true
            lbl2ndAns.isHidden = true
            lbl3rdAns.isHidden = true
            lbl4thAns.isHidden = true
            lbl5thAns.isHidden = true
            lbl6thAns.isHidden = true
        }
        label.isHidden.toggle()
        label.sizeToFit()
        view.layoutIfNeeded()
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn1stAction(_ sender: UIButton) {
        hideAllAnswers(label: lbl1stAns)
    }

    @IBAction func btn2ndAction(_ sender: UIButton) {
        hideAllAnswers(label: lbl2ndAns)
    }

    @IBAction func btn3rdAction(_ sender: UIButton) {
        hideAllAnswers(label: lbl3rdAns)
    }

    @IBAction func btn4thAction(_ sender: UIButton) {
        hideAllAnswers(label: lbl4thAns)
    }

    @IBAction func btn5thAction(_ sender: UIButton) {
        hideAllAnswers(label: lbl5thAns)
    }

    @IBAction func btn6thAction(_ sender: UIButton) {
        hideAllAnswers(label: lbl6thAns)
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
