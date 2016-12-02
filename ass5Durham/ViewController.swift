//
//  ViewController.swift
//  ass5Durham
//
//  Created by Jonathan Durham on 11/11/16.
//  Copyright © 2016 Jonathan Durham. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableData:Array<String>?

    
    @IBOutlet weak var instrTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        instrbuilder()
        
        instrTableView.delegate = self
        instrTableView.dataSource = self
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog(String(instructors.count))
        return instructors.count
    }
    
  
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "instrCell"
        var cell = instrTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
 
        if (cell == nil ) {
            cell = UITableViewCell(style: .subtitle,
                                   reuseIdentifier: cellIdentifier)
        }
        
        let celltext = instructors[indexPath.row].fname + " " + instructors[indexPath.row].lname
        /* //Figure out why this didn't work
        var detailcelltext =  " Average Rating: " + String(instructors[indexPath.row].ratingAverage!)
        detailcelltext +=  " Total Ratings: " + String(instructors[indexPath.row].ratingTotal!)
        */
        
        cell.textLabel?.text = celltext
        //cell.textLabel?.text = tableData![indexPath.row]
        return cell
    }
    
/*    func tableView(tableView: UITableView,
                   willSelectRowAtIndexPath indexPath: IndexPath) -> IndexPath? {
        return indexPath.row == 0 ? nil : indexPath
    }
*/
    //Provided by book - handles row selection with alert
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let rowValue = instructors[indexPath.row]
        //THIS THE SEGWAY POINT
 
    }
    
    //Get an NSArray of Instructor's id's First and Last Names
    func getInstrData(data:Data?, response:URLResponse?, error:Error?) -> Void {
        guard error == nil else {
            NSLog("error: \(error!.localizedDescription)")
            return }
        let httpResponse = response as? HTTPURLResponse
        let status:Int = httpResponse!.statusCode
        if data != nil && (status == 200) {
            if let webPageContents = String(data: data!, encoding:String.Encoding.utf8) {
                //Where the majic happens
                for i in JSONarraytoSwiftArray(jsonArrayInput: webPageContents)!{
                    instructors.append( Instructor(instArray: i as! [String : Any]) )
                }
            }
            else {
                NSLog("unable to convert data to text")
            }
            // At this point all of instructor data has been obtained.
            NSLog(String(instructors.count))
            instrTableView.reloadData()
        }
    }
    
    //kicks off building instructor array.
    func instrbuilder(){
        if let url = URL(string: "http://bismarck.sdsu.edu/rateme/list") {
            let session = URLSession.shared
            let task = session.dataTask(with: url, completionHandler: getInstrData)
            task.resume()
        }
        else {
            NSLog("Unable to create URL")
        }
    }

    
    
}
