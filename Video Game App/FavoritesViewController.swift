//
//  FavoritesViewController.swift
//  Video Game App
//
//  Created by Ertan Can Güner on 4.05.2022.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let dataSource = GameDataSource.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
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
        let game = dataSource.getLikedGame(for: indexPath.row)
        cell.gameNameLabel.text = game?.name
        cell.gameImage.load(url: URL(string: (game?.backgroundImage)!)!)
        return cell
    }
    
    
}
