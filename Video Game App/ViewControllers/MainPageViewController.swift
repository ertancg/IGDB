import UIKit
//This is the Main Page View Controller for the Main Page Tab
class MainPageViewController: UIViewController {

    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var gameCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var searchResultTableView: UITableView!
    
    
    var frame = CGRect.zero
    
    let dataSource = GameDataSource.shared
    var currentPageIndex = 0
    
    //Set the visibility of some views in initial load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageControl.alpha = 0
        self.searchResultTableView.alpha = 0
        self.dataSource.mainPageDelegate = self
        self.pageControl.numberOfPages = 3
        
        scrollView.delegate = self
        
        //Setting the tab bar items
        if let tabBarItem1 = self.tabBarController?.tabBar.items?[0] {
            tabBarItem1.title = "Home"
            tabBarItem1.image = UIImage(systemName: "homekit")
            
        }
        if let tabBarItem2 = self.tabBarController?.tabBar.items?[1] {
            tabBarItem2.title = "Favorites"
            tabBarItem2.image = UIImage(systemName: "suit.hearth")
        }
        self.tabBarController?.tabBar.backgroundColor = .darkGray
    }
    
    //Everytime a letter is entered this function is called and if the query is greater than 3 words a lazy search is done to the games.
    @IBAction func searchEntered(_ sender: Any){
        if let query = self.searchBar.text{
            if(query.count >= 3){
                self.dataSource.searchGame(for: query)
                self.searchResultTableView.alpha = 1
                self.gameCollectionView.alpha = 0
            }else{
                self.searchResultTableView.alpha = 0
                self.gameCollectionView.alpha = 1
            }
        }
    }
    
    //Setting up the page view screens. Just the first three is enough.
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
    
    /*
     Prepare the data to pass it into Game Detail View. First check if the segue is coming from the search or the collection view.
     Then if the segue is coming from the search, get the data from the search results and pass it. If its coming from the collection
     view then get the data from the game list and pass it.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "TableViewSegue"){
            let cell = sender as! SearchResultCell
            if let indexPath = self.searchResultTableView.indexPath(for: cell) {
                let game = self.dataSource.getSearchedGame(for: indexPath.row)
                let gameDetailViewController = segue.destination as! GameDetailViewController
                gameDetailViewController.selectedGame = game
            }
        }
        
        if(segue.identifier == "CollectionViewSegue"){
            let cell = sender as! GameCollectionViewCell
            if let indexPath = self.gameCollectionView.indexPath(for: cell) {
                let game = self.dataSource.getGameIndex(for: indexPath.row)
                let gameDetailViewController = segue.destination as! GameDetailViewController
                gameDetailViewController.selectedGame = game
            }
        }
    }
}

//After the search is done or the games are recieved from the end point these functions are called.
extension MainPageViewController: GameMainPageDelegate{
    func searchDone() {
        self.searchResultTableView.reloadData()
    }
    
    func gameListLoaded() {
        self.gameCollectionView.reloadData()
        self.setupScreens()
        self.pageControl.alpha = 1
    }
}

//
extension MainPageViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.searchResultCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchResultCell
        if let game = dataSource.getSearchedGame(for: indexPath.row){
            if let title = game.name{
                cell.gameNameLabel.text = title
            }else{
                cell.gameNameLabel.text = "N/A"
            }
            if let imagePath = game.backgroundImage{
                if let url = URL(string: imagePath){
                    cell.gameImage.load(url: url)
                }else{
                    cell.gameImage.image = UIImage(systemName: "point.3.connected.trianglepath.dotted")
                }
            }else{
                cell.gameImage.image = UIImage(systemName: "point.3.connected.trianglepath.dotted")
            }
        }else{
            cell.gameNameLabel.text = "N/A"
            cell.gameImage.image = UIImage(systemName: "point.3.connected.trianglepath.dotted")
        }
        return cell
    }
}

extension MainPageViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.getNumberOfGames()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as! GameCollectionViewCell
        if let game = dataSource.getGameIndex(for: indexPath.row){
            if let title = game.name{
                cell.gameNameLabel.text = title
            }else{
                cell.gameNameLabel.text = "N/A"
            }
            if let rating = game.rating{
                if let release = game.released{
                    cell.gameRatingReleaseLabel.text = "\(Double(rating)) - " + release
                }else{
                    cell.gameRatingReleaseLabel.text = "\(Double(rating))"
                }
            }else{
                if let release = game.released{
                    cell.gameRatingReleaseLabel.text = "N/A - " + release
                }else{
                    cell.gameRatingReleaseLabel.text = "N/A"
                }
            }
            if let imagePath = game.backgroundImage{
                if let url = URL(string: imagePath){
                    cell.gameImage.load(url: url)
                }else{
                    cell.gameImage.image = UIImage(systemName: "point.3.connected.trianglepath.dotted")
                }
            }else{
                cell.gameImage.image = UIImage(systemName: "point.3.connected.trianglepath.dotted")
            }
        }
        return cell
    }
}

extension MainPageViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80)
    }
}

extension MainPageViewController: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        self.pageControl.currentPage = Int(pageNumber)
    }
}

//This is for loading an image from an URL
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
