import Foundation

class GameDataSource{
    
    static let shared = GameDataSource()
    var games: [Result?] = []
    let apiKey = "2c00ba57109447cfbf4d25046b0c6a27"
    let baseURL = "https://api.rawg.io/api/games"
    
    var mainPageDelegate: GameMainPageDelegate?
    var detailsPageDelegate: GameDetailsDelegate?
    
    var currentPage = 1
    
    var likedGames: [Result] = []
    var gameDetails: GameDetails?
    
    var searchedGames: [Result?] = []
    var refreshing = false
    
    init(){
        loadGameList(page: currentPage)
    }
    
    func getGameIndex(for index: Int) -> Result?{
        let ratio = Double(index) / Double(games.count)
        if(ratio > 0.5){
            lowListWarning()
        }
        if let game = games[index]{
            return game
        }else{
            return nil
        }
    }
    
    func getNumberOfGames() -> Int{
        return games.count
    }
    
    func searchGame(for query: String){
        self.searchedGames = self.games.filter{ elm in
            if let name = elm?.name?.lowercased(){
                if(name.contains(query.lowercased())){
                    return true
                }else{
                    return false
                }
            }else{
                return false
            }
        }
        self.mainPageDelegate?.searchDone()
    }
    
    func searchResultCount() -> Int{
        return self.searchedGames.count
    }
    
    func getSearchedGame(for index: Int) -> Result?{
        if let game = self.searchedGames[index]{
            return game
        }else{
            return nil
        }
    }
    func lowListWarning(){
        if(!refreshing){
            loadGameList(page: self.currentPage + 1)
            self.refreshing = true
        }
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
                        self.mainPageDelegate?.gameListLoaded()
                        print("Recieved Page \(self.currentPage)")
                        self.refreshing = false
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func loadGameDetails(for id: Int){
        let urlSession = URLSession.shared
        if let url = URL(string: "\(baseURL)/\(id)?key=\(apiKey)") {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let dataTask = urlSession.dataTask(with: urlRequest) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    do{
                        self.gameDetails = try decoder.decode(GameDetails.self, from: data)
                    }catch let error{
                        print(error)
                    }
                    DispatchQueue.main.async{
                        self.detailsPageDelegate?.gameRecieved(for: self.gameDetails!)
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
        if let index = self.likedGames.firstIndex(where: {$0.name == game.name}){
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
    
    func getNumberOfLiked() -> Int{
        return self.likedGames.count
    }
    
    func getLikedGame(for index: Int) -> Result?{
        return self.likedGames[index]
    }
}
