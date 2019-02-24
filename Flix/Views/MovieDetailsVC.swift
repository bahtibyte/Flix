//
//  MovieDetailsVC.swift
//  Flix
//
//  Created by Bahti on 2/22/19.
//  Copyright © 2019 Bahti. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieDetailsVC: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var backdropIV: UIImageView!
    @IBOutlet weak var posterIV: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    
    
    
    var movie: [String:Any]!
    var similarMovies = [[String:Any]]()
    let links = Links()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("At the details page, i know \(movie["title"])")
        // Do any additional setup after loading the view.
        
        //print("I am now here \(movie)")
        
        titleLabel.text = movie["title"] as? String
        titleLabel.sizeToFit()
        detailsLabel.text = movie["overview"] as? String
        detailsLabel.sizeToFit()
        
        releaseDateLabel.text = movie["release_date"] as? String
        
        collectionView.dataSource = self
        
        //let posterPath = movie["poster_path"] as! String
        
        if let posterPath = movie["poster_path"] as? String
        {
            let path = URL(string: links.getBaseURL() + posterPath)
            
            posterIV.af_setImage(withURL: path!)
        }else{
            print("Error")
        }
        
        
        if let backdropPath = movie["backdrop_path"] as? String
        {
            let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath)
            
            backdropIV.af_setImage(withURL: backdropUrl!)
        }else{
            print("ERROR")
        }
        
        let id = movie["id"] as! Int
        
        let url = links.getSimilar(movieID: id)
        
        assaignMovies(connectTo: url)
    }
    
    
    func assaignMovies(connectTo link: String){
        
        //Connects with the web and retrieves the data
        let url = URL(string: link)!
        
        //Creates a new url request to that url
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        //Creates a new session with the request
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        //Creates a new task with the session and the request
        let task = session.dataTask(with: request) { (data, response, error) in
            
            // This will run when the network request returns
            if let error = error {
                print("Error in MovieDetailsVC")
            }
                
            //This happens if it retrieved the data correctly
            else if let data = data {
                
                //Retrieves the entire data from the link
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                //Grabs the results section of the data
                self.similarMovies = dataDictionary["results"] as! [[String:Any]]
                
                print(self.similarMovies.count)
                
                //Reloads the table view with the newly updated data
                self.collectionView.reloadData()
            }
        }
        
        //Starts the task of retrieving the data
        task.resume()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreMovieCell", for: indexPath) as! MoreMovieCell
        
        if (similarMovies.count <= indexPath.row) {
            return cell
        }
        //print("S: \(similarMovies.count) R: \(indexPath.row)")
        let movie = similarMovies[indexPath.row]
        
        if let path = movie["poster_path"] as? String
        {
            //Creates a new url for the poster
            let posterURL = URL(string: self.links.getBaseURL() + path)
            
            cell.row = indexPath.row
            
            //Sets the imageview on the cell to be the image of the posterpath
            cell.movieImage.af_setImage(withURL: posterURL!)
        }
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! MoreMovieCell
        
        let dest = segue.destination as! MovieDetailsVC
        dest.movie = similarMovies[cell.row]
    }
 

}
