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
    
    //References to the objects on the view controller
    @IBOutlet weak var backdropIV: UIImageView!
    @IBOutlet weak var posterIV: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //This is the current movie we are displaying
    var movie: [String:Any]!
    
    //These are the movies similar to the movie above
    var similarMovies = [[String:Any]]()
    
    //Helper class with all the links of the api
    let links = Links()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Retrieves the title of the movie and sets it on the label
        titleLabel.text = movie["title"] as? String
        
        //Makes sure that the entire title fits on the label
        titleLabel.sizeToFit()
        
        //Retrieves the description of the movie and sets it on the label
        detailsLabel.text = movie["overview"] as? String
        
        //Makes sure that the entire description fits on the label
        detailsLabel.sizeToFit()
        
        //Assigns the release date to the label
        releaseDateLabel.text = movie["release_date"] as? String
        
        //Sets the reference of datasource to this class so it registers the methods
        collectionView.dataSource = self
        
        //Makes sure that poster path exists for the movie
        if let posterPath = movie["poster_path"] as? String
        {
            //Grabs the path and creates a new url for that poster
            let path = URL(string: links.getBaseURL() + posterPath)
            
            //Sets the image view with that poster image
            posterIV.af_setImage(withURL: path!)
        }else{
            
            //There was a problem retrieving the poster url
            print("Unable to retrieve poster path [\(movie!)]")
        }
        
        //Makes sure that the backdrop exists for the movie
        if let backdropPath = movie["backdrop_path"] as? String
        {
            //Grabs a high quality backdrop for the movie
            let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath)
            
            //Sets the backdrop image view with the backdrop iamge
            backdropIV.af_setImage(withURL: backdropUrl!)
        }else{
            
            //There was a problem retrieving the backdrop url
            print("Unable to retrieve backdrop path [\(movie!)]")
        }
        
        //Grabs the id of the current movie
        let id = movie["id"] as! Int
        
        //Sets the link needed to get similar movies to the movie above
        let url = links.getSimilar(movieID: id)
        
        //Retrieves the data from that url and assigns it to similar movies
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
                print("Error in MovieDetailsVC \n\(error)")
            }
                
            //This happens if it retrieved the data correctly
            else if let data = data {
                
                //Retrieves the entire data from the link
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                //Grabs the results section of the data
                self.similarMovies = dataDictionary["results"] as! [[String:Any]]
                
                //Reloads the table view with the newly updated data
                self.collectionView.reloadData()
            }
        }
        
        //Starts the task of retrieving the data
        task.resume()
    }
    
    //Returns the number of cells the collection view should have
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //Makes sure there are only multiples of 3 cells in the collection view
        return (similarMovies.count) - (similarMovies.count % 3)
    }
    
    //Creates the new cell for every single movie
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Creates a new cell that will be displayed on the collectionview
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreMovieCell", for: indexPath) as! MoreMovieCell
        
        //A safe heaven to make sure that index does not go over bounds
        if (similarMovies.count <= indexPath.row) {
            return cell
        }
        
        //Grabs the specific movie for the row of the cell
        let movie = similarMovies[indexPath.row]
        
        //Makes sure the path exists for that poster
        if let path = movie["poster_path"] as? String
        {
            //Creates a new url for the poster
            let posterURL = URL(string: self.links.getBaseURL() + path)
            
            //Assigns the current cell row to the movie
            cell.row = indexPath.row
            
            //Sets the imageview on the cell to be the image of the posterpath
            cell.movieImage.af_setImage(withURL: posterURL!)
        }
        
        //Returns the cell to be displayed on the colleciton view
        return cell
    }
    
    //When a movie is clicked, it brings up more details about that movie
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Grabs the cell the that was clicked
        let cell = sender as! MoreMovieCell
        
        //Grabs the destination of the view controller
        let dest = segue.destination as! MovieDetailsVC
        
        //Assigns the movie that was selected to be displayed
        dest.movie = similarMovies[cell.row]
    }
 

}
