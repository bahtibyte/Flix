//
//  MovieCell.swift
//  Flix
//
//  Created by Bahti on 2/20/19.
//  Copyright © 2019 Bahti. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    //@IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var categoryTitle: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func registerCollectionView<DataSource: UICollectionViewDataSource>(datasource: DataSource) {
        self.collectionView.dataSource = datasource;
        self.collectionView.reloadData()
    }
    
}
