//
//  MovieDetailsVC.swift
//  Flix
//
//  Created by Bahti on 2/22/19.
//  Copyright © 2019 Bahti. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieDetailsVC: UIViewController {
    
    @IBOutlet weak var backdropIV: UIImageView!
    @IBOutlet weak var posterIV: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    
    
    
    
    
    
    var movie: [String:Any]!
    let links = Links()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("At the details page, i know \(movie["title"])")
        // Do any additional setup after loading the view.
        
        titleLabel.text = movie["title"] as? String
        titleLabel.sizeToFit()
        detailsLabel.text = movie["overview"] as? String
        detailsLabel.sizeToFit()
        
        releaseDateLabel.text = movie["release_date"] as? String
        
        //let posterPath = movie["poster_path"] as! String
        
        if let posterPath = movie["poster_path"] as? String
        {
            let path = URL(string: links.getBaseURL() + posterPath)
            
            posterIV.af_setImage(withURL: path!)
        }else{
            print("Error")
        }
        
        //let path = URL(string: links.getBaseURL() + posterPath)
        
        //posterIV.af_setImage(withURL: path!)
        
        if let backdropPath = movie["backdrop_path"] as? String
        {
            let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath)
            
            backdropIV.af_setImage(withURL: backdropUrl!)
        }else{
            print("ERROR")
        }
        
        //let backdropPath = movie["backdrop_path"] as! String
        
        //let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath)
        
        //backdropIV.af_setImage(withURL: backdropUrl!)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
