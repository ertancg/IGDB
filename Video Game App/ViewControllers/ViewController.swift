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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var frame = CGRect.zero
    
    let dataSource = GameDataSource.shared
    var currentPageIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageControl.alpha = 0
        self.dataSource.mainPageDelegate = self
        self.pageControl.numberOfPages = 3
        
        scrollView.delegate = self
        
        if let tabBarItem1 = self.tabBarController?.tabBar.items?[0] {
            tabBarItem1.title = "Home"
            tabBarItem1.image = UIImage(systemName: "homekit")
            
        }
        if let tabBarItem2 = self.tabBarController?.tabBar.items?[1] {
            tabBarItem2.title = "Favorites"
            tabBarItem2.image = UIImage(systemName: "suit.hearth")
        }
        self.tabBarController?.tabBar.backgroundColor = .darkGray
        // Do any additional setup after loading the view.
    }
    
    func setupScreens() {
        for index in 0..<3 {
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            
            let imgView = UIImageView(frame: frame)
            imgView.load(url: URL(string: (self.dataSource.games[index]?.backgroundImage!)!)!)

            self.scrollView.addSubview(imgView)
        }
        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(3)), height: scrollView.frame.size.height)
        scrollView.delegate = self
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
extension ViewController: GameMainPageDelegate{
    func gameListLoaded() {
        self.gameCollectionView.reloadData()
        self.setupScreens()
        self.pageControl.alpha = 1
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

extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80)
    }
}

extension ViewController: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        self.pageControl.currentPage = Int(pageNumber)
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
