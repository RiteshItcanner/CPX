//
//  PerformanceHeaderView.swift
//  cpx
//
//  Created by Ritesh Sinha on 17/09/24.
//

import UIKit

class PerformanceHeaderView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data: [Client] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    func updateData(newData: [Client]) {
        self.data = newData
        collectionView.reloadData()
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension PerformanceHeaderView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return number of items
        return 10 // Example
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompanyCollCell", for: indexPath) as! CompanyCollCell
//        cell.backgroundColor = .red // Example
        return cell
    }
}
