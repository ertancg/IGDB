//
//  GameDataSource.swift
//  Video Game App
//
//  Created by Ertan Can Güner on 2.05.2022.
//

import Foundation

class GameDataSource{
    
    static let shared = GameDataSource()
    var games: [Result?] = []
    let apiKey = "2c00ba57109447cfbf4d25046b0c6a27"
    let baseURL = "https://api.rawg.io/api/games"
    
    var delegate: GameDataSourceDelegate?
    var nextPage = -1
    var currentPage = 1
    var refreshing = true
    var likedGames: [Result] = []
    
    init(){
        loadGameList(page: currentPage)
    }
    
    func getGameIndex(for index: Int) -> Result?{
        if let game = games[index]{
            return game
        }else{
            return nil
        }
    }
    
    func getNumberOfGames() -> Int{
        return games.count
    }
    
    func loadGameList(page: Int){
        let urlSession = URLSession.shared
        if let url = URL(string: "\(baseURL)?key=\(apiKey)&page=\(page)") {
            currentPage = page
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let dataTask = urlSession.dataTask(with: urlRequest) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    do{
                        let gameArrayFromNetwork = try decoder.decode(Network_Data.self, from: data)
                        self.games.append(contentsOf: gameArrayFromNetwork.results!)
                    }catch let error{
                        print(error)
                    }
                    DispatchQueue.main.async {
                        self.delegate?.gameListLoaded()
                        self.refreshing.toggle()
                        self.nextPage = self.currentPage + 1
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func likeGame(for game: Result){
        self.likedGames.append(game)
    }
    
    func dislikeGame(for game: Result){
        if let index = self.likedGames.firstIndex(where: {$0.id == game.id}){
            self.likedGames.remove(at: index)
        }
    }
    
    func isLiked(for game: Result) -> Bool{
        if let index = self.likedGames.firstIndex(where: {$0.id == game.id}){
            return true
        }else{
            return false
        }
    }
}
