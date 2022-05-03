//
//  ViewController.swift
//  Video Game App
//
//  Created by Ertan Can Güner on 2.05.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var gameCollectionView: UICollectionView!
    @IBOutlet weak var pageImageView: UIView!
    
    let dataSource = GameDataSource.shared
    var currentPageIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource.delegate = self
        // Do any additional setup after loading the view.
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let cell = sender as! GameCollectionViewCell
        if let indexPath = self.gameCollectionView.indexPath(for: cell) {
            let game = dataSource.getGameIndex(for: indexPath.row)
            let gameDetailViewController = segue.destination as! GameDetailViewController
            gameDetailViewController.selectedGame = game
        }
    }
}
extension ViewController: GameDataSourceDelegate{
    func gameListLoaded() {
        self.gameCollectionView.reloadData()
        print("data recieved")
    }
}
extension ViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.getNumberOfGames()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as! GameCollectionViewCell
        let game = dataSource.getGameIndex(for: indexPath.row)
        cell.gameNameLabel.text = game?.name
        cell.gameRatingReleaseLabel.text = "\(Double((game?.rating)!)) - " + (game?.released)!
        cell.gameImage.load(url: URL(string: (game?.backgroundImage)!)!)
        return cell
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
