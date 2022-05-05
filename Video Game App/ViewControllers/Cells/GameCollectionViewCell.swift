import UIKit
//This is for the Collection View in MainPage View
class GameCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameRatingReleaseLabel: UILabel!
    
    override func awakeFromNib() {
            super.awakeFromNib()
    }
}
