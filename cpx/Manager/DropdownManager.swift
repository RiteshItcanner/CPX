//
//  DropdownManager.swift
//  cpx
//
//  Created by Ritesh Sinha on 20/09/24.
//

import UIKit
import DropDown

class DropdownManager {

    private let monthDropDown = DropDown()
    private let yearDropDown = DropDown()

    // Configure the dropdowns
    init(monthAnchorView: UIView, yearAnchorView: UIView) {
        setupMonthDropDown(anchorView: monthAnchorView)
        setupYearDropDown(anchorView: yearAnchorView)
    }
    
    // Setup month dropdown
    private func setupMonthDropDown(anchorView: UIView) {
        monthDropDown.anchorView = anchorView
        monthDropDown.dataSource = getMonthNames()
        monthDropDown.bottomOffset = CGPoint(x: 0, y: anchorView.bounds.height)
        DropDown.appearance().backgroundColor = UIColor(named: "BgColor")
        DropDown.appearance().textColor = UIColor(named: "ThemeTextColor")!
    }

    // Setup year dropdown
    private func setupYearDropDown(anchorView: UIView) {
        yearDropDown.anchorView = anchorView
        yearDropDown.dataSource = getYearRange()
        yearDropDown.bottomOffset = CGPoint(x: 0, y: anchorView.bounds.height)
        DropDown.appearance().backgroundColor = UIColor(named: "BgColor")
        DropDown.appearance().textColor = UIColor(named: "ThemeTextColor")!
    }

    // Show month dropdown
    func showMonthDropDown(completion: @escaping (Int, String) -> Void) {
            monthDropDown.selectionAction = { (index, item) in
                print("Selected Month: \(item) at index \(index)")
                completion(index, item)  // Pass both index and item
            }
            monthDropDown.show()
        }

    // Show year dropdown
    func showYearDropDown(completion: @escaping (String) -> Void) {
        yearDropDown.selectionAction = { (index, item) in
            print("Selected Year: \(item) at index \(index)")
            completion(item)
        }
        yearDropDown.show()
    }

    // Get month names
    private func getMonthNames() -> [String] {
        let dateFormatter = DateFormatter()
        return dateFormatter.monthSymbols
    }

    // Get year range from 2000 to current year + 5 years
    private func getYearRange() -> [String] {
        let currentYear = Calendar.current.component(.year, from: Date())
        return (2000...currentYear).map { String($0) }
    }
}

