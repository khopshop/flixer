//
//  Now PlayingViewController.swift
//  flix
//
//  Created by Angel Chara'e Mitchell on 2/6/18.
//  Copyright © 2018 Angel Chara'e Mitchell. All rights reserved.
//

import UIKit
import AlamofireImage

class Now_PlayingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var movies: [[String : Any]] = []
    var refresh: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(Now_PlayingViewController.pullToRefresh(_:)),
                          for: .valueChanged)
        tableView.insertSubview(refresh, at: 0)

        tableView.delegate = self
        tableView.dataSource = self

        fetchMovies()
    }
    
    @objc func  pullToRefresh(_ refresh: UIRefreshControl) {
        fetchMovies()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        let baseURLString = "https://image.tmdb.org/t/p/w500/"
        let posterPath = movie["poster_path"] as! String
        let posterURL = URL(string: baseURLString + posterPath)!
        
        if cell.poster != nil {
            cell.poster.af_setImage(withURL: posterURL)
        }
        
        return cell
    }
    
    func fetchMovies() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: [])
                    as! [String: Any]
                let movies = dataDictionary["results"] as! [[String : Any]]
                self.movies = movies
                
                //Reload your table view data
                self.tableView.reloadData()
                self.refresh.endRefreshing()
            }
        }
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}