//
//  MovieListView.swift
//  MovieApp
//
//  Created by Julius Kiano on 3/10/17.
//  Copyright © 2017 Julius Kiano. All rights reserved.
//

import UIKit

class MovieListView: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var urlString = "http://api.androidhive.info/json/movies.json"
    
    var titlesArray = [String]()
    var ratingArray = [String]()
    var imageUrlArray = [String]()
    var yearArray = [String]()
    var genreArray = [String]()
    
    var selectedMovie = Dictionary<String,String>()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        self.downloadJsonUrl()
    }
    
    
    func downloadJsonUrl(){
        let url = NSURL(string: urlString)
        URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in
            if let jsonArray = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSArray {
                for array in jsonArray! {
                    if let movie = array as? NSDictionary {
                        
                        if let title = movie.value(forKey: "title") {
                            self.titlesArray.append(title as! String)
                        }
                        
                        if let rating = movie.value(forKey: "rating") {
                            let rate = String(format: "%.1f", rating as! Double)
                            self.ratingArray.append("\(rate)")
                        }
                        
                        if let image = movie.value(forKey: "image") {
                            self.imageUrlArray.append(image as! String)
                        }
                        
                        if let year = movie.value(forKey: "releaseYear") {
                            self.yearArray.append("\(year)")
                        }
                        
                        if let genre = movie.value(forKey: "genre") {
                            let genreArray = genre as! NSArray
                            var genreString: String = ""
                            for gen in genreArray {
                                genreString = genreString + "\(gen) "
                            }
                            print(genreString)
                            self.genreArray.append(genreString)
                        }
                        
                        OperationQueue.main.addOperation({
                            self.tableView.reloadData()
                        })
                    }
                }
            }
            
        }).resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.titleLabel.text = titlesArray[indexPath.row]
        cell.ratingLabel.text = ratingArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie["title"] = titlesArray[indexPath.row]
        selectedMovie["rating"] = ratingArray[indexPath.row]
        selectedMovie["image"] = imageUrlArray[indexPath.row]
        selectedMovie["year"] = yearArray[indexPath.row]
        selectedMovie["genre"] = genreArray[indexPath.row]
        performSegue(withIdentifier: "movieInfoView", sender: self)
    }
    
    
    
    
    
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut() // this is an instance function
        performSegue(withIdentifier: "homeView", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "movieInfoView") {
            let movieInfo = segue.destination as! MovieInfoView;
            movieInfo.selectedMovie = selectedMovie
        }
    }

    


}
