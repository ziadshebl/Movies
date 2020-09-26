//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by kamal badawy on 9/23/20.
//

import UIKit
import Moya
import RxCocoa
import RxSwift
import RealmSwift

class MovieDetailsViewController: UIViewController {
    
    let provider = MoyaProvider<Flickr>()
    var movie: Movie?
    var photos: BehaviorRelay<[FlickrPhoto]> = BehaviorRelay(value: [])
    let disposeBag = DisposeBag()

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieReleaseYearLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var movieRatingStarImage1: UIImageView!
    @IBOutlet weak var movieRatingStarImage2: UIImageView!
    @IBOutlet weak var movieRatingStarImage3: UIImageView!
    @IBOutlet weak var movieRatingStarImage4: UIImageView!
    @IBOutlet weak var movieRatingStarImage5: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let nib = UINib(nibName: K.MovieImagesCollectionCellNibName, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: K.MovieImagesCollectionCellIdentifier)
     
        if let currentMovie = movie {
            movieTitleLabel.text = currentMovie.title
            movieReleaseYearLabel.text = String(currentMovie.year)
            self.loadCast(cast: movie?.cast ?? List<Cast>())
            self.loadGenres(genres: movie?.genres ?? List<Genre>())
            self.adjustRatingStars(rating: movie?.rating ?? 0)
        }
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        fetchImages()
        setupCellConfiguration()
    
    }
    
    
    //A function responsibel to load the cast names from the cast array into the cast label
    func loadCast(cast: List<Cast>) {
        castLabel.text = "Cast: \(cast[0].castMember)"
        cast.forEach { (member) in
            if member.castMember != cast[0].castMember{
                castLabel.text = castLabel.text! + ", \(member.castMember)"
            }
        }
    }
    
    //A function responsibel to load the genres names from the genres array into the genres label
    func loadGenres(genres: List<Genre>) {
        genresLabel.text = "Genres: \(genres[0].genre)"
        genres.forEach { (genreItem) in
            if genreItem.genre != genres[0].genre{
                genresLabel.text = genresLabel.text! + ", \(genreItem.genre)"
            }
        }
    }
    
    //A function responsible for filling the stars according to the rating
    //Input: Movie rating as Integer
    func adjustRatingStars(rating: Int) {
        if rating > 0 {
            movieRatingStarImage1.image = UIImage(systemName: "star.fill")
        }
        if rating > 1 {
            movieRatingStarImage2.image = UIImage(systemName: "star.fill")
        }
        if rating > 2 {
            movieRatingStarImage3.image = UIImage(systemName: "star.fill")
        }
        if rating > 3 {
            movieRatingStarImage4.image = UIImage(systemName: "star.fill")
        }
        if rating > 4 {
            movieRatingStarImage5.image = UIImage(systemName: "star.fill")
        }
        
    }
}


//MARK:- A section to maniuplate the images from Flickr
extension MovieDetailsViewController {
    
    //A function responsible for requesting the images from Flickr
    func fetchImages() {
        provider.request(.search(movie?.title ?? "None")){[] result in
          switch result {
          case .success(let response):
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any]
                let photosInfo = jsonResponse?["photos"] as? [String:Any]
                let photosArray = photosInfo?["photo"] as? [[String: Any]]
                photosArray?.forEach({ (photoElement) in
                    let photo = FlickrPhoto(id: (photoElement["id"] as? String)!, owner: (photoElement["owner"] as? String)!, secret: (photoElement["secret"] as? String)!, server: (photoElement["server"] as? String)!, farm: (photoElement["farm"] as? Int)!)
                    var allLoadedPhotos = self.photos.value
                    allLoadedPhotos.append(photo)
                    self.photos.accept(allLoadedPhotos)
                  
                })
            }catch {
                print(error)
            }
            case .failure:
            print("error")
          
          }
      }
    }
    
}

//MARK: - Collection View Setup
extension MovieDetailsViewController: UICollectionViewDelegateFlowLayout{
    
    //Binding the collection view to the photos array
    func setupCellConfiguration() {
        photos.bind(to: collectionView.rx.items(cellIdentifier: K.MovieImagesCollectionCellIdentifier, cellType: MovieImagesCollectionViewCell.self)) {
            row, movie, cell in
           
                cell.configureWithImages(photo: self.photos.value[row])
           
            
        }.disposed(by: disposeBag)
 
        
    }
    
    
    //Configuring the cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width = collectionView.bounds.width
        let cellWidth = (width - 10) / 2
        return CGSize(width: cellWidth, height: cellWidth / 0.6)
    }
}

