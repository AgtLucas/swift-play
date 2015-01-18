//
//  ViewController.swift
//  Corp
//
//  Created by Lucas on 1/18/15.
//  Copyright (c) 2015 AWLKA. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var appsTableView: UITableView!
    var tableData = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        
            cell.textLabel?.text = "Row #\(indexPath.row)"
            cell.detailTextLabel?.text = "Subtitle #\(indexPath.row)"
        
        return cell
    }
    
    func searchItunesFor(searchItem: String) {
        
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

                var err: NSError?

                var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary

                if (err != nil) {
                    println("JSON Error \(err!.localizedDescription)")
                }

                let results: NSArray = jsonResult["resulsts"] as NSArray

                dispatch_async(dispatch_get_main_queue(), {
                    self.tableData = results
                    self.appsTableView!.reloadData()
                })

            })

            task.resume()

        }
        
    }


}

