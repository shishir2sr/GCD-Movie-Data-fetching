import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let themoviedbURL = "https://api.themoviedb.org/3/search/movie?api_key=38e61227f85671163c275f9bd95a8803&query=$search"
    
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Super Movies"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            
            self?.getMovies(for: "marvel") { [weak self] result in
                switch result {
                    
                case .success(let movies):
                    self?.movies = movies
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell") as! MovieTableViewCell
        
        let movie = movies[indexPath.row]
        
        cell.configure(title: movie.title,
                       description: movie.overview)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let imageVC = storyboard.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        imageVC.imagePath = movies[indexPath.row].posterPath
        self.navigationController?.pushViewController(imageVC, animated: true)
    }
}

extension ViewController {
    // MARK: Network Call
    
    func getMovies(for query: String, completed: @escaping (Result<[Movie], CustomError>) -> Void) {
        
        let urlString = themoviedbURL
            .replacingOccurrences(of: "$search", with: query)
            .replacingOccurrences(of: " ", with: "%20")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard
            let url = URL(string: urlString)
        else {
            completed(.failure(.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ =  error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200
            else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard
                let data = data
            else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(MovieModel.self, from: data)
                
                completed(.success(decodedResponse.results))
                
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
}

enum CustomError: Error {
    case invalidURL
    case unableToComplete
    case invalidResponse
    case invalidData
}
