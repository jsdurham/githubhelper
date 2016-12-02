//
//  instructorhelper.swift
//  ass5Durham
//
//  Created by Jonathan Durham on 11/11/16.
//  Copyright © 2016 Jonathan Durham. All rights reserved.
//

import Foundation
//: Playground - noun: a place where people can play


import UIKit
import Foundation

var instructors = [Instructor]()

/* JSON retrieval code */
func JSONarraytoSwiftArray(jsonArrayInput:String)->NSArray?{
    //JSON array conversion to swift array
    // A swift JSON string -> retrieved from url
    let jsonString:String = jsonArrayInput
    let jsonData:Data? = jsonString.data(using: String.Encoding.utf8) // Convert string to data object
    
    // Convert JSON String to Array
    do {
        let json:Any = try JSONSerialization.jsonObject(with: jsonData!) // serialize the JSON Data object
        let jsonArray:NSArray = json as! NSArray //Make an arrayb based on the serialized object
        return jsonArray
    } catch {
        NSLog("error in json array conversion")
        return nil
    }
}
/*
let jsonArrayAsString:String = "[\"a\", 2, true]"
JSONarraytoSwiftArray(jsonArrayInput: jsonArrayAsString)
*/

func JSONdicttoSwiftDict(jsonDictInput:String)->NSDictionary?{
    let jsonString:String = jsonDictInput
    let jsonData:Data? = jsonString.data(using: String.Encoding.utf8)
    // Convert JSON String to NSDictionary
    do {
        let json:Any = try JSONSerialization.jsonObject(with: jsonData!)
        let jsonDictionary = json as! NSDictionary
        return jsonDictionary
    } catch {
        NSLog("error in json dictionary conversion")
        return nil
    }
}

//Swift converted to JSON string
func SwiftArrayToJSON(arrayAsData:Array<Any>)->String?{
    let array = arrayAsData
    do {
        let arrayAsData: Data = try JSONSerialization.data(withJSONObject: array)
        let jsonArray: String? = String(data: arrayAsData,
                                        encoding: String.Encoding.utf8)
        return jsonArray
    } catch {
        NSLog("error")
        return nil
    }
}

/*
let array = [1,2,"cat"] as [Any]
var myJSON:String = SwiftArrayToJSON(arrayAsData: array)!
*/

func swiftToJSONString(data:Any) -> String? {
    do {
        let arrayAsData: Data = try JSONSerialization.data(withJSONObject: data)
        return String(data: arrayAsData,encoding:String.Encoding.utf8) }
    catch {
        return nil
    }
}

/*-------------Handling Homework -------------*/
//Get dictionary keys

class Instructor {
    var id:Int? = nil
    var fname:String = ""
    var lname:String = ""
    var office:String?
    var phone:String?
    var email:String?
    var rating:NSDictionary = [:]
    var ratingAverage:Float?
    var ratingTotal:Int?
    var dictFullInfo:[String:Any] = [:]
    var arrayComments:NSArray = []
    var instrDict:[String:Any] = [:]
    
    let listKeys:Array = ["id", "firstName", "lastName"]
    let instructorKeys:Array = ["id", "firstName", "lastName", "office", "phone", "email", "rating"]
    let commentKeys:Array = ["text", "date"]
    
    func prettyPrint()->String{
        let str = "\(id) \(fname) \(lname) \(office) \(phone)" +
        "\(email) \(rating) \(arrayComments.count)"
        return str
    }
    
    /*--- Initialization ---*/
    init(instArray:[String:Any]){
        instrDict = instArray
        self.id = instArray[ listKeys[0] ] as? Int
        self.fname = instArray[ listKeys[1] ] as! String
        self.lname =  instArray[ listKeys[2] ] as! String
        retrieveExtraData()
        
    }
    
    init(id_:Int, lname_:String, fname_:String) {
        self.id = id_
        self.lname = lname_
        self.fname = fname_
    }
    /*----------------HTTP requests --------------*/
    func retrieveComments(){
        if let url = URL(string: "http://bismarck.sdsu.edu/rateme/comments/\(self.id!)") {
            let session = URLSession.shared
            let task = session.dataTask(with: url, completionHandler: getInstrComments)
            task.resume()
        }
        else {
            NSLog("Unable to create URL")
        }
    }//end retrieveComments
    
    //Get email and other data
    func getInstrComments(data:Data?, response:URLResponse?, error:Error?) -> Void {
        guard error == nil else {
            NSLog("error: \(error!.localizedDescription)")
            return }
        let httpResponse = response as? HTTPURLResponse
        let status:Int = httpResponse!.statusCode
        if data != nil && (status == 200) {
            if let webPageContents = String(data: data!, encoding:String.Encoding.utf8) {
                
                arrayComments = JSONarraytoSwiftArray(jsonArrayInput: webPageContents)! //NSArray
                
            }
            else {
                NSLog("unable to convert data: getInstrComments")
                NSLog("\(data!)")
            }
            // At this point all of instructor data has been obtained.
            // pretty print instructors
        }
        //NSLog(prettyPrint())
        
    }//end getInstrComments
    
    func retrieveExtraData(){
        if let url = URL(string: "http://bismarck.sdsu.edu/rateme/instructor/\(self.id!)") {
            let session = URLSession.shared
            let task = session.dataTask(with: url, completionHandler: getFullInstrData)
            task.resume()
        }
        else {
            NSLog("Unable to create URL")
        }
    }//end retrieveFullInstrData
    
    //Get email and other data
    func getFullInstrData(data:Data?, response:URLResponse?, error:Error?) -> Void {
        guard error == nil else {
            NSLog("error: \(error!.localizedDescription)")
            return
        }
        
        let httpResponse = response as? HTTPURLResponse
        let status:Int = httpResponse!.statusCode
        
        if data != nil && (status == 200) {
            if let webPageContents = String(data: data!, encoding:String.Encoding.utf8) {
                dictFullInfo = JSONdicttoSwiftDict(jsonDictInput: webPageContents) as! [String : Any]
                self.office = dictFullInfo[instructorKeys[3]] as? String
                self.phone = dictFullInfo[instructorKeys[4]] as? String
                self.email = dictFullInfo[instructorKeys[5]] as? String
                self.rating = dictFullInfo[instructorKeys[6]] as! NSDictionary
                self.ratingAverage = self.rating["average"] as? Float
                self.ratingTotal = self.rating["totalRatings"] as? Int
                retrieveComments()
            }
            else {
                NSLog("unable to convert data to text")
                
            }
        }
    }//end getFullInstrData

} // end Instructor class














