//
//  MoviesVC.swift
//  Flix
//
//  Created by Bahti on 2/20/19.
//  Copyright © 2019 Bahti. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviesVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    //Array of all the genres available
    var genres = [Genre]()
    var links = Links()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Required to make the table view work
        tableView.dataSource = self
        tableView.delegate = self
        
        //Adding 2 genres
        assaignMovies(connectTo: links.getUpComingURL(), genreType: "Up Coming", index: 0)
        assaignMovies(connectTo: links.getPopularURL(), genreType: "Popular", index: 1)
        
        //Populating all the genres available
        populateGenres()
    }
    
    func assaignMovies(connectTo link: String, genreType type: String, index n: Int){
        
        //Creates a new Genre specified for the link
        genres.append(Genre(genre: type, genreIndex: n))
        
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
                print("Error retrieving data from \(link)\n\(error.localizedDescription)")
            }
            
            //This happens if it retrieved the data correctly
            else if let data = data {
                
                //Retrieves the entire data from the link
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                //Grabs the results section of the data
                let movies = dataDictionary["results"] as! [[String:Any]]
                
                //Assaigns the movies to the genre given
                self.genres[n].assignMovies(listOfMovies: movies)
                
                //Reloads the table view with the newly updated data
                self.tableView.reloadData()
            }
        }
        
        //Starts the task of retrieving the data
        task.resume()
    }
    
    
    func populateGenres() {
        
        //Connects with the web to retrieve all the genres
        let url = URL(string: links.getAllGenreURL())!
        
        //Creates a new url request to that url
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        //Creates a new session with the request
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        //Creates a new task with the session and the request
        let task = session.dataTask(with: request) { (data, response, error) in
            
            //This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            }
            
            //This happens if it retrieved the data correctly
            else if let data = data {
                
                //Retrieves the entire data for the link
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                //Grabs all the possible genres
                let gens = dataDictionary["genres"] as! [[String:Any]]
                
                //Loops through all the genres
                for i in 0 ... (gens.count - 1) {
                    
                    //Grabs the specific genre
                    let specificGenre = gens[i]
                    
                    //Grabs the id which will be used later on
                    let id = specificGenre["id"] as! Int
                    
                    //Grabs the name of the genre to show on the table view
                    let name = specificGenre["name"] as! String
                    
                    //Creates a new link to connect to get more info on that genre
                    let link = self.links.getSpecificGenreURL() + String(id)
                    
                    //Creates a new genre and assigns the movies to that genre
                    self.assaignMovies(connectTo: link, genreType: name, index: i + 2)
                }
                
                //Reloads the table view with all the categories
                self.tableView.reloadData()
            }
        }
        
        //Starts the task of retrieving the data
        task.resume()
    }
    
    //Overridable method ~ Required ~ Returns the number of rows the tableview should have
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.genres.count
    }
    
    //Overrideable method ~ Required ~ Creates a new cell for each row in the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Creates a new cell of type CategoryCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        
        //Sends the reference to this object so collection view loads
        cell.registerCollectionView(datasource: self)
        
        //Assigns the row index to the collection view
        cell.collectionView.tag = indexPath.row
        
        //Sets the genre title on the table view
        cell.categoryTitle.text = self.genres[indexPath.row].getGenre()
        
        //Makes sure there is no grey selection style when clicked
        cell.selectionStyle = .none
        
        //Resets the cell to start at the very beginning
        cell.collectionView?.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: false)
        
        //Returns the cell to be set on the row
        return cell
    }
    
    //Overrideable method ~ Required ~ Returns the number of columns the row has
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.genres[collectionView.tag].getMovies().count
    }
    
    //Overrideable method ~ Required ~ Creates a new movie for each column on the collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Creates a new cell of type MovieCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        //Retrieves all the movies on the genre at index of the tableview
        let movies = self.genres[collectionView.tag].getMovies()
        
        //Grabs the current movie on the column
        let movie = movies[indexPath.row]
        
        cell.row = collectionView.tag
        cell.col = indexPath.row
        
        //Makes sure the path for the poster exists and does not fail
        if let path = movie["poster_path"] as? String
        {
            //Creates a new url for the poster
            let posterURL = URL(string: self.links.getBaseURL() + path)
            
            //Sets the imageview on the cell to be the image of the posterpath
            cell.image.af_setImage(withURL: posterURL!)
        }
        
        //Returns the cell for that column
        return cell
    }
    
    override func prepare(for seque: UIStoryboardSegue, sender: Any?) {
        
        let cell = sender as! MovieCell
        
        let genreIndex = cell.row!
        let movieIndex = cell.col!
        
        print("You selected \(genres[genreIndex].getGenre()) genre and movie \((genres[genreIndex].getMovies()[movieIndex])["title"]!)")
    }
}
