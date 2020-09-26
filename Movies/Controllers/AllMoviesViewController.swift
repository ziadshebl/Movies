//
//  ViewController.swift
//  Movies
//
//  Created by kamal badawy on 9/22/20.
//

import UIKit
import RxCocoa
import RxSwift
import RealmSwift


class AllMoviesViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
   
    let realm = try! Realm()
    
    //lazy var moviesList: Results<Movie>  = {self.realm.objects(Movie.self)} ()
    
    
    var allMoviesList: BehaviorRelay<[Movie]> = BehaviorRelay(value: [])
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.register(UINib(nibName: K.MovieCellNibName, bundle: nil), forCellReuseIdentifier: K.MovieCellIdentifier)
        
        loadData()
        setupCellConfiguration()
        setupCellTapHandling()
        
        

    }
    
    
    //This function is responsible for deciding wether to load the data from the json file or the cached data and load it
    func loadData (){
        //Reading the JSON file and filling the allMoviesList array with the movies
        do {
            let moviesSaved = realm.objects(Movie.self)
            if moviesSaved.count == 0 {
                print("JSON Loaded")
            if let localData = self.readLocalFile(forName: K.MoviesJsonFile) {
                let allMovies = try JSONDecoder().decode(MovieList.self, from: localData)

                allMovies.movies.forEach { (movie) in
                    do {
                        try self.realm.write {
                            let newMovie = Movie()
                            newMovie.title = movie.title
                            newMovie.rating = movie.rating
                            newMovie.year = movie.year
                            movie.cast.forEach { (castMember) in
                                let newCastMember = Cast()
                                newCastMember.castMember = castMember
                                newMovie.cast.append(newCastMember)
                            }
                            movie.genres.forEach { (genre) in
                                let newGenre = Genre()
                                newGenre.genre = genre
                                newMovie.genres.append(newGenre)
                            }
                            realm.add(newMovie)
                            var currentMovieList = allMoviesList.value
                            currentMovieList.append(newMovie)
                            allMoviesList.accept(currentMovieList)
                        }
                    }catch {
                        print("Error", error)
                    }
                }
           }
            }else {
                print("Cache Loaded")
            moviesSaved.forEach { (movie) in
                var currentMovies = allMoviesList.value
                currentMovies.append(movie)
                allMoviesList.accept(currentMovies)
            }
        }
        } catch {
            print(error)
        }
    }
    
}

//MARK: - Rx Setup
private extension AllMoviesViewController {
    
    //Binding the table view to the allMoviesList array
    func setupCellConfiguration() {
        allMoviesList.bind(to: tableView.rx.items( cellIdentifier: K.MovieCellIdentifier, cellType: MovieCell.self)) {
            row, movie, cell in cell.configureWithMovie(movie: movie)
        }.disposed(by: disposeBag)
    }
    
    //A function responsible for handling the tapping event of the cell by navigating to the details screen
    func setupCellTapHandling(){
        tableView.rx.modelSelected(Movie.self).subscribe(onNext: {
            [unowned self] movie in

            performSegue(withIdentifier: K.GoToDetailsSegueIdentifier, sender: self)
            if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
            }
        
        }).disposed(by: disposeBag)
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

//MARK: - A section responsible for handling the segue
extension AllMoviesViewController {
    
    //Preparing the next destination by passing the movie to be displayed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? MovieDetailsViewController{
            let indexPath = tableView.indexPathForSelectedRow!
            destinationVC.movie = allMoviesList.value[indexPath.row]
        }
    }
}

