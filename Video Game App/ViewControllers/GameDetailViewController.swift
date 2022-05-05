import UIKit

class GameDetailViewController: UIViewController {
    var selectedGame: Result?
    let dataSource = GameDataSource.shared
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var gameDetailsLabel: UILabel!
    @IBOutlet weak var metacriticLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var likeButtonLabel: UIButton!
    
    var liked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        likeButtonLabel.alpha = 0
        self.dataSource.detailsPageDelegate = self
        if let game = selectedGame{
            if let id = game.id{
                self.dataSource.loadGameDetails(for: id)
            }
            liked = self.dataSource.isLiked(for: game)
        }
        changeLikeButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.contentSize.height = 3000
        self.scrollView.contentSize.width = UIScreen.main.bounds.width
        self.gameDetailsLabel.numberOfLines = 0
        self.gameDetailsLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.gameDetailsLabel.frame = self.scrollView.frame
    }
    
    @IBAction func likeButton(_ sender: Any) {
        self.liked.toggle()
        changeLikeButton()
        if let game = self.selectedGame{
            if(liked){
                self.dataSource.likeGame(for: game)
            }else{
                self.dataSource.dislikeGame(for: game)
            }
        }
    }
    
    func changeLikeButton(){
        if(self.liked){
            self.likeButtonLabel.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
            self.likeButtonLabel.tintColor = .red
        }else{
            self.likeButtonLabel.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
            self.likeButtonLabel.tintColor = .black
        }
    }

}

extension GameDetailViewController: GameDetailsDelegate{
    func gameRecieved(for game: GameDetails) {
        self.likeButtonLabel.alpha = 1
        changeLikeButton()
        if let imagePath = game.backgroundImage{
            if let url = URL(string: imagePath){
                self.gameImage.load(url: url)
            }else{
                self.gameImage.image = UIImage(systemName: "point.3.connected.trianglepath.dotted")
            }
        }else{
            self.gameImage.image = UIImage(systemName: "point.3.connected.trianglepath.dotted")
        }
        if let name = game.name{
            self.gameNameLabel.text = name
        }else{
            self.gameNameLabel.text = "N/A"
        }
        if let release = game.released{
            self.releaseDateLabel.text = (release == "nil" ? "N/A" : release)
        }else{
            self.releaseDateLabel.text = "N/A"
        }
        if let meta = game.metacritic{
            self.metacriticLabel.text = "\(Int(meta))"
        }else{
            self.metacriticLabel.text = "N/A"
        }
        if let description = game.gameDetailsDescription{
            self.gameDetailsLabel.text = description.replacingOccurrences(of: "<p>", with: "")
            self.gameDetailsLabel.text = self.gameDetailsLabel.text!.replacingOccurrences(of: "</p>", with: "")
            self.gameDetailsLabel.text = self.gameDetailsLabel.text!.replacingOccurrences(of: "</br>", with: "")
        }else{
            self.gameDetailsLabel.text = "N/A"
        }
    }
}

