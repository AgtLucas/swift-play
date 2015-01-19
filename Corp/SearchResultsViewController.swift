//
//  ViewController.swift
//  Corp
//
//  Created by Lucas on 1/18/15.
//  Copyright (c) 2015 AWLKA. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var appsTableView: UITableView?
    var tableData = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchItunesFor("Iron Maiden")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")

        let rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        
        cell.textLabel?.text = rowData["trackMame"] as? String

        let urlString: NSString = rowData["artworkUrl60"] as NSString
        let imgURL: NSURL? = NSURL(string: urlString)

        let imgData = NSData(contentsOfURL: imgURL!)
        cell.imageView?.image = UIImage(data: imgData!)

//        let trackPrice: NSString = rowData["trackPrice"] as NSString
//
//        cell.detailTextLabel?.text = trackPrice

        return cell
    }
    
    func searchItunesFor(searchTerm: String) {
        
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)

        if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {

            let urlPath = "http://itunes.apple.com/search?term=\(escapedSearchTerm)&media=music"
            let url = NSURL(string: urlPath)
            let session = NSURLSession.sharedSession()

            let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
                println("Task Completed!")

                if (error != nil) {
                    println(error.localizedDescription)
                }

                var 😡: NSError?

                var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &😡) as NSDictionary

                if (😡 != nil) {
                    println("JSON Error \(😡!.localizedDescription)")
                }

                let results: NSArray = jsonResult["results"] as NSArray

                dispatch_async(dispatch_get_main_queue(), {
                    self.tableData = results
                    self.appsTableView!.reloadData()
                })

            })

            task.resume()

        }
        
    }


}

