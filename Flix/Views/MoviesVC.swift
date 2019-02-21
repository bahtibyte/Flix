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
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var movies = [[String:Any]]()
    
    var genres = [Genre]()
    var links = Links()
    
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Required to make the table view work
        tableView.dataSource = self
        tableView.delegate = self
        
        genres.append(Genre(genre: "Up Coming", genreIndex: 0, genreID: 0))
        genres.append(Genre(genre: "Popular", genreIndex: 1, genreID: 0))
        
        assaignMovies(connectTo: links.getUpComingURL(), index: 0)
        assaignMovies(connectTo: links.getPopularURL(), index: 1)
        
        
        populateGenres()
        //assaignMovies(connectTo: links.getUpComingURL(), string: "Up Coming", num: 0)
        //assaignMovies(connectTo: links.getPopularURL(), string: "Popular", num: 0)
       
    }
    
    func assaignMovies(connectTo link: String, index n: Int){
        
        let url = URL(string: link)!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Error retrieving data from \(link)\n\(error.localizedDescription)")
            }else if let data = data {
                
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let movies = dataDictionary["results"] as! [[String:Any]]
                print (movies.count)
                self.genres[n].assignMovies(listOfMovies: movies)
                
                print("Index \(n) Genre \(self.genres[n].getGenre())")
                for i in 0 ... (movies.count - 1) {
                    print("    \(i): \(self.genres[n].getMovies()[i]["title"]!)")
                }
                print("")
                
                //gen.assignMovies(listOfMovies: dataDictionary["results"] as! [[String:Any]])
                
                //self.genres.append(gen)
                
                //count++
                
                self.tableView.reloadData()
            }
        }
        
        task.resume()
    }
    
    func populateGenres() {
        // Do any additional setup after loading the view.
        let url = URL(string: links.getAllGenreURL())!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                let gens = dataDictionary["genres"] as! [[String:Any]]
                
                for i in 0 ... (gens.count - 1) {
                    
                    let specificGenre = gens[i]
                    
                    let id = specificGenre["id"] as! Int
                    
                    self.genres.append(Genre(genre: specificGenre["name"] as! String, genreIndex: (i + 2), genreID: id))
                    
                    self.assaignMovies(connectTo: self.links.getSpecificGenreURL() + String(id), index: (i + 2))
                    
                    self.tableView.reloadData()
                }
                
                //print("Size of genre \(self.genres.count)")
                //for i in 0 ... 20 {
                //    print("Genre: \(self.genres[i].getGenre()) [\(i)] has \(self.genres[i].getMovies().count) movies")
                //}
            }
        }
        
        task.resume()
    }
    
    //Overridable method ~ Required
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.genres.count
    }
    
    //Overrideable method ~ Required
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        
        cell.registerCollectionView(datasource: self)
        cell.collectionView.tag = indexPath.row
        cell.categoryTitle.text = self.genres[indexPath.row].getGenre()
        
        //cell.collectionView?.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: false)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("PLEASE WORK")
        return self.genres[collectionView.tag].getMovies().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movies = self.genres[collectionView.tag].getMovies()
        
        let movie = movies[indexPath.row]
        
        let posterPath = movie["poster_path"] as! String
        
        let posterURL = URL(string: self.links.getBaseURL() + posterPath)
        
        
        //print("Row: \(collectionView.tag) Col: \(indexPath.row) Movie: \(movie["title"]!)")
        
        cell.image.af_setImage(withURL: posterURL!)
        
        
        return cell
    }
}
