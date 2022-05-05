import UIKit

class FavoritesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let dataSource = GameDataSource.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! FavoritesTableViewCell
        if let indexPath = self.tableView.indexPath(for: cell) {
            let game = dataSource.getLikedGame(for: indexPath.row)
            let gameDetailViewController = segue.destination as! GameDetailViewController
            gameDetailViewController.selectedGame = game
        }
    }
}

extension FavoritesViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.getNumberOfLiked()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! FavoritesTableViewCell
        if let game = dataSource.getLikedGame(for: indexPath.row){
            if let name = game.name{
                cell.gameNameLabel.text = name
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
        }
        return cell
    }
}
