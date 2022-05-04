//
//  CollectionViewCell.swift
//  Video Game App
//
//  Created by Ertan Can Güner on 2.05.2022.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameRatingReleaseLabel: UILabel!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }
}
