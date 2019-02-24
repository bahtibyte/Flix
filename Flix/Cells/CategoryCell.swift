//
//  MovieCell.swift
//  Flix
//
//  Created by Bahti on 2/20/19.
//  Copyright © 2019 Bahti. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //Assigns the datasource to the collection view
    func registerCollectionView<DataSource: UICollectionViewDataSource>(datasource: DataSource) {
        self.collectionView.dataSource = datasource;
        self.collectionView.reloadData()
    }
    
}
