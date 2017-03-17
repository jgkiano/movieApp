//
//  MovieInfoView.swift
//  MovieApp
//
//  Created by Julius Kiano on 3/13/17.
//  Copyright © 2017 Julius Kiano. All rights reserved.
//

import UIKit

import AVKit

import AVFoundation

import FBSDKShareKit

class MovieInfoView: UIViewController {
    
    var selectedMovie = Dictionary<String,String>()

    @IBOutlet weak var movieTitleLbl: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var posterImage: UIImageView!
    
    let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let checkedUrl = URL(string: selectedMovie["image"]!) {
            posterImage.contentMode = .scaleAspectFit
            downloadImage(url: checkedUrl)
            movieTitleLbl.text = selectedMovie["title"]
            ratingLabel.text = selectedMovie["rating"]
            yearLabel.text = selectedMovie["year"]
            genreLabel.text = selectedMovie["genre"]
        }

    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                self.posterImage.image = UIImage(data: data)
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    @IBAction func logOutPress(_ sender: UIButton) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut() // this is an instance function
    }

    @IBAction func playTrailerPressed(_ sender: UIButton) {
        //the api doesn't give me trailers :(
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
        
        
        
    }
    
    @IBAction func sharePosterPressed(_ sender: UIButton) {
        if((FBSDKAccessToken.current()) != nil){
            let photo : FBSDKSharePhoto = FBSDKSharePhoto()
            photo.image = posterImage.image
            photo.isUserGenerated = false
            photo.caption = "Movie Shared using MovieApp: Must watch " + movieTitleLbl.text!
            let content : FBSDKSharePhotoContent = FBSDKSharePhotoContent()
            content.photos = [photo]
            FBSDKShareAPI.share(with: content, delegate: nil)
            alert()
        }
    }
    
    @IBAction func shareTrailerPress(_ sender: Any) {
        
        let video : FBSDKShareVideo = FBSDKShareVideo()
        video.videoURL = videoURL
        let content : FBSDKShareVideoContent = FBSDKShareVideoContent()
        content.video = video
        FBSDKShareAPI.share(with: content, delegate: nil)
        alert()
        
    }
    
    func alert() {
        let alert = UIAlertController(title: "Sharing is caring", message: "Thank you for sharing " + movieTitleLbl.text! + " on Facebook. Hope you get many likes", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
}
