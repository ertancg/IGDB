//
//  GameDetailViewController.swift
//  Video Game App
//
//  Created by Ertan Can Güner on 4.05.2022.
//

import UIKit

class GameDetailViewController: UIViewController {
    var selectedGame: Result?
    let dataSource = GameDataSource.shared
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var metacriticLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    
    @IBOutlet weak var likeButtonLabel: UIButton!
    
    var liked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gameImage.load(url: URL(string: (self.selectedGame?.backgroundImage)!)!)
        self.gameNameLabel.text = self.selectedGame?.name
        self.releaseDateLabel.text = "\(Double((self.selectedGame?.released)!))"
        self.metacriticLabel.text = "\(Int((self.selectedGame?.metacritic)!))"
        self.descriptionLabel.text = self.selectedGame?.released
        liked = self.dataSource.isLiked(for: selectedGame!)
        changeLikeButton()
    }
    
    @IBAction func likeButton(_ sender: Any) {
        self.liked.toggle()
        changeLikeButton()
        if(liked){
            self.dataSource.likeGame(for: self.selectedGame!)
        }else{
            self.dataSource.dislikeGame(for: self.selectedGame!)
        }
    }
    
    func changeLikeButton(){
        if(liked){
            self.likeButtonLabel.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
            self.likeButtonLabel.tintColor = .red
        }else{
            self.likeButtonLabel.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
            self.likeButtonLabel.tintColor = .black
        }
    }

}

