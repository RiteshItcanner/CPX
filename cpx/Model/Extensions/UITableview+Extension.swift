//
//  UITableview+Extension.swift
//  HealWith
//
//  Created by Nishit on 21/10/22.
//

import UIKit
extension UITableView {
    /// used to dequeue table view cell with same cell identifier
    func dequeueCell<T>(ofType type: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: T.self)) as! T
    }

    /// SwifterSwift: Register UITableViewCell with .xib file using only its corresponding class.
    ///               Assumes that the .xib filename and cell class has the same name.
    ///
    /// - Parameters:
    ///   - name: UITableViewCell type.
    ///   - bundleClass: Class in which the Bundle instance will be based on.
    func register<T: UITableViewCell>(nibWithCellClass name: T.Type, at bundleClass: AnyClass? = nil) {
        let identifier = String(describing: name)
        var bundle: Bundle?

        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }

        register(UINib(nibName: identifier, bundle: bundle), forCellReuseIdentifier: identifier)
    }
}

extension UITableView {
    func setupSeperator() {
        separatorStyle = .singleLine
        separatorInset = UIEdgeInsets(top: 0,
                                      left: 0,
                                      bottom: 0,
                                      right: 0)
    }

    func registerHeaderFooterXibs(identifiers: [String]) {
        identifiers.forEach { identifier in
            register(UINib(nibName: identifier,
                           bundle: nil),
                     forHeaderFooterViewReuseIdentifier: identifier)
        }
    }
}

extension UITableView {
    func isCellVisible(section: Int,
                       row: Int) -> Bool {
        guard let indexes = indexPathsForVisibleRows else {
            return false
        }
        return indexes.contains { $0.section == section && $0.row == row }
    }

    func registerXibs(identifiers: [String]) {
        identifiers.forEach { identifier in
            self.register(UINib(nibName: identifier,
                                bundle: nil),
                          forCellReuseIdentifier: identifier)
        }
    }
}

extension UITableView {
    func reloadSectionWithoutAnimation(_ section: Int) {
        UIView.setAnimationsEnabled(false)
        beginUpdates()
        reloadSections(IndexSet(integer: section),
                       with: .none)
        endUpdates()
    }
}
