//
//  SearchVC.swift
//  Flix
//
//  Created by Bahti on 2/24/19.
//  Copyright © 2019 Bahti. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, UICollectionViewDataSource, UISearchBarDelegate, UICollectionViewDelegate {
   
    //References to the collectionview and the searchbar
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //All the movies for the search query stored in this
    var movies = [[String:Any]]()
    
    //Helper class to keep track of api links
    let links = Links()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Gives the reference to datasource and delegate so they work
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.searchBar.delegate = self
    }
    
    //When a movie is clicked, it brings up more details about that movie
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Turns off the search bar when a movie is selected
        searchBar.endEditing(true)
        
        //Grabs the cell that was clicked and casts it
        let cell = sender as! SearchCell
        
        //Grabs the destination in which the cell is taking
        let dest = segue.destination as! MovieDetailsVC
        
        //Sets the movie on the destination
        dest.movie = movies[cell.row]
    }
    
    //Searches and assigns the movies from given keyword
    func search(text searchText: String) {
        
        //Replaces the spaces with valid string so the api works
        let path = searchText.replacingOccurrences(of: " ", with: "%20")
        
        //Creates the path to the api to request the data
        let pathUrl = links.getSearchURL() + path
        
        //Connects with the web and retrieves the data
        let url = URL(string: pathUrl)!
        
        //Creates a new url request to that url
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        //Creates a new session with the request
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        //Creates a new task with the session and the request
        let task = session.dataTask(with: request) { (data, response, error) in
            
            // This will run when the network request returns
            if let error = error {
                print(error)
            }
                
            //This happens if it retrieved the data correctly
            else if let data = data {
                
                //Retrieves the entire data from the link
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                //Grabs the results section of the data
                self.movies = dataDictionary["results"] as! [[String:Any]]
                
                //Reloads the table view with the newly updated data
                self.collectionView.reloadData()
            }
        }
        
        //Starts the task of retrieving the data
        task.resume()
    }
    
    //This method gets called everytime a change in the search bar happens
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        //If there are at least 3 characters, it starts searching the web for the movies
        if (searchText.count >= 3){
            
            //Calls the helper function search to search for that keyword
            search(text: searchText)
        }else if (searchText.count < 3){
            
            //Deletes all the movies
            movies = [[String:Any]]()
            
            //Removes all the cells
            self.collectionView.reloadData()
        }
        
    }
    
    //This method gets called when the search button is clicked on the keyboard
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //Closes the keyboard to make space on the ui
        searchBar.resignFirstResponder()
    }
    
    //Returns the number of cells the collection view should have
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //Makes sure there are only multiples of 3 cells
        return (movies.count) - movies.count % 3
    }
    
    //Creates the new cell for every single movie
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Creates a new cell of type SearchCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCell
        
        //A safe heaven to make sure the cells do not go out of boungs
        if (movies.count <= indexPath.row) {
            return cell
        }
        
        //Grabs the specific movie from that row
        let movie = movies[indexPath.row]
        
        //Makes sure that the poster exists for that movie
        if let path = movie["poster_path"] as? String
        {
            //Creates a new url for the poster
            let posterURL = URL(string: self.links.getBaseURL() + path)
            
            //Keeps track of what row that cell is
            cell.row = indexPath.row
            
            //Sets the imageview on the cell to be the image of the posterpath
            cell.searchImage.af_setImage(withURL: posterURL!)
        }
        
        //Returns the cell to be placed on the collection view
        return cell
    }
    

}
