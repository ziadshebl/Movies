//
//  ViewController.swift
//  Movies
//
//  Created by kamal badawy on 9/22/20.
//

import UIKit

class AllMoviesViewController: UITableViewController {
    
    var allMoviesList: MovieList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.MovieCellNibName, bundle: nil), forCellReuseIdentifier: K.MovieCellIdentifier)
        
        do {
            if let localData = self.readLocalFile(forName: K.MoviesJsonFile) {
                allMoviesList = try JSONDecoder().decode(MovieList.self, from: localData)
            }
        } catch{
            print(error)
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMoviesList?.movies.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let movies = allMoviesList?.movies {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.MovieCellIdentifier, for: indexPath) as! MovieCell
            cell.movieTitleLabel.text = movies[indexPath.row].title
            cell.movieReleaseYear.text = String(movies[indexPath.row].year)
            cell.adjustRatingStars(rating: movies[indexPath.row].rating)
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: K.MovieCellIdentifier, for: indexPath) as! MovieCell
        cell.movieTitleLabel.text = "No Movies Yet"
        cell.movieReleaseYear.text = "-"
        return cell
            
    }
    
    
}



//MARK: - A section responsible for data manipulation from JSON file
extension AllMoviesViewController {
    
    //A function to read the resources from a specific json file with the name passed
    //Input: File name as String
    //Output: The data read from the file as Data
    func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"), let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        }catch {
            print(error)
        }
        return nil
    }
}

