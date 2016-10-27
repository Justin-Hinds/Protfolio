//
//  ViewController.swift
//  Hinds_Jusin_tableView
//
//  Created by Justin Hinds on 9/29/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   private let action = "https://api.themoviedb.org/3/discover/movie?api_key=d44dd340b97e2a960511e5ea46ecfcf7&language=en-US&page=1&with_genres=28"
   private let comedies = "https://api.themoviedb.org/3/discover/movie?api_key=d44dd340b97e2a960511e5ea46ecfcf7&language=en-US&page=1&with_genres=35"
   private let imagePath = "https://image.tmdb.org/t/p/w500/"
    @IBOutlet weak var myTableView: UITableView!
    var actionArray = [Movie]()
    var comedyArray = [Movie]()
    @IBAction func backTo(segue: UIStoryboardSegue){
        
    }
    override func viewDidLoad() {
        actionMovieRequest()
        comedyMovieRequest()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func actionMovieRequest() {
        let url = NSURL(string: action)
        let request = URLRequest(url: url as! URL)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let realResponse = response as? HTTPURLResponse,
            realResponse.statusCode == 200 else{
                print("not code 200")
                return
            }
            do{
              let response = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                let info = response.object(forKey: "results") as! NSArray
                for movie in info {
                    let title = (movie as AnyObject).object(forKey: "original_title") as! String
                    let release  = (movie as AnyObject).object(forKey: "release_date") as! String
                    let posterPath = (movie as AnyObject).object(forKey: "poster_path") as! String
                    let overview = (movie as AnyObject).object(forKey: "overview") as! String
                    let popularity = (movie as AnyObject).object(forKey: "popularity") as! Int
                    let posterURL = URL(string: self.imagePath + posterPath)
                    let posterImage = UIImage(data: try! Data(contentsOf: posterURL!))
                    let newMovie = Movie(title: title, pop: popularity, poster: posterImage!, release: release, desc: overview)
                    self.actionArray.append(newMovie)
                    DispatchQueue.main.async {
                        self.myTableView.reloadData()
                    }                }
            }catch{
                print("Things did not go according to plan")
            }
            
        }
        task.resume()


    }
    func comedyMovieRequest() {
        let url = NSURL(string: comedies)
        let request = URLRequest(url: url as! URL)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let realResponse = response as? HTTPURLResponse,
                realResponse.statusCode == 200 else{
                    print("not code 200")
                    return
            }
            do{
                let response = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                let info = response.object(forKey: "results") as! NSArray
                for movie in info {
                    let title = (movie as AnyObject).object(forKey: "original_title") as! String
                    let release  = (movie as AnyObject).object(forKey: "release_date") as! String
                    let posterPath = (movie as AnyObject).object(forKey: "poster_path") as! String
                    let overview = (movie as AnyObject).object(forKey: "overview") as! String
                    let popularity = (movie as AnyObject).object(forKey: "popularity") as! Int
                    let posterURL = URL(string: self.imagePath + posterPath)
                    let posterImage = UIImage(data: try! Data(contentsOf: posterURL!))
                    let newMovie = Movie(title: title, pop: popularity, poster: posterImage!, release: release, desc: overview)
                    self.comedyArray.append(newMovie)
                    DispatchQueue.main.async {
                        self.myTableView.reloadData()
                    }
                }
                //print(info)
            }catch{
                print("Things did not go according to plan")
            }
            
        }
        task.resume()
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Comedy Movies"
        }else{
            return "Action Movies"
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return comedyArray.count
        }else{
            return actionArray.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell

        if indexPath.section == 0{
            cell.releaseLabel.text = comedyArray[indexPath.row].releaseDate
            cell.titleLabel.text = comedyArray[indexPath.row].movieTitle
            cell.postImg.image = comedyArray[indexPath.row].moviePoster
        }else{
            cell.releaseLabel.text = actionArray[indexPath.row].releaseDate
            cell.titleLabel.text = actionArray[indexPath.row].movieTitle
            cell.postImg.image = actionArray[indexPath.row].moviePoster
        }
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = myTableView.indexPathForSelectedRow
        let detail = segue.destination as! DetailViewController
        if myTableView.indexPathForSelectedRow?.section == 0{
            detail.currentMovie = comedyArray[indexPath!.row]
        }else{
            detail.currentMovie = actionArray[indexPath!.row]
        }
        
    }
}

