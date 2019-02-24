//
//  SearchVC.swift
//  Flix
//
//  Created by Bahti on 2/24/19.
//  Copyright © 2019 Bahti. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, UICollectionViewDataSource, UISearchBarDelegate, UICollectionViewDelegate {
   

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies = [[String:Any]]()
    let links = Links()
    
    var finishedLastSearch = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.searchBar.delegate = self
        
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped))
        //collectionView.addGestureRecognizer(tapGesture)
        
         //self.searchBar.showsCancelButton = true
        
        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let cell = sender as! SearchCell
        
        let dest = segue.destination as! MovieDetailsVC
        dest.movie = movies[cell.row]
    }
 
    /*
    @objc func tapped() {
        self.searchBar.endEditing(true)
        print("TAPPING")
    }*/
    
    func search(text searchText: String) {
        
        finishedLastSearch = false
        
        let path = searchText.replacingOccurrences(of: " ", with: "%20")
        
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
                print("Error in MovieDetailsVC")
            }
                
                //This happens if it retrieved the data correctly
            else if let data = data {
                
                //Retrieves the entire data from the link
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                //Grabs the results section of the data
                self.movies = dataDictionary["results"] as! [[String:Any]]
                
                print(self.movies.count)
                
                //finishedLastSearch = true
                
                //Reloads the table view with the newly updated data
                self.collectionView.reloadData()
            }
        }
        
        //Starts the task of retrieving the data
        task.resume()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        if (searchText.count >= 3){
            search(text: searchText)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (movies.count) - movies.count % 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCell
        
        if (movies.count <= indexPath.row) {
            return cell
        }
        //print("S: \(similarMovies.count) R: \(indexPath.row)")
        let movie = movies[indexPath.row]
        
        if let path = movie["poster_path"] as? String
        {
            //Creates a new url for the poster
            let posterURL = URL(string: self.links.getBaseURL() + path)
            
            cell.row = indexPath.row
            
            //Sets the imageview on the cell to be the image of the posterpath
            cell.searchImage.af_setImage(withURL: posterURL!)
        }
        
        return cell
    }
    

}
