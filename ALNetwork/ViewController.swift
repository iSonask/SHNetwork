//
//  ViewController.swift
//  ALNetwork
//
//  Created by Akash on 05/07/17.
//  Copyright © 2017 Akash. All rights reserved.
//

import UIKit
import SwiftHTTP

class ViewController: UIViewController {
    
    var places : [Dashboard] = []
    
    @IBOutlet var tblPlaces: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let param: APIParameters = [
        //            "function": "login",
        //            "mail_id": "mitesh@addonwebsolutions.com",
        //            "password": "12345"
        //        ]
        //
        //       SHNetwork.observePostRequest(param: param, onSuccess: { jsonDict in
        //
        //            print(jsonDict["msg"]!)
        //
        //        })
        
        let param: APIParameters = [
            "function" : "dashboard"
        ]
        SHNetwork.observeGetRequest(param: param, onSuccess: { jsonDict in
            print(jsonDict)
            
            if let jsonObjects = jsonDict["data"] as? [ [String: Any] ]{
                for jsonObject in jsonObjects{
                    if let dash = Dashboard(data: jsonObject){
                        self.places.append(dash)
                    }
                }
            }
            OperationQueue.main.addOperation {
                print(self.places[1])
                self.tblPlaces.reloadData()
            }
        })
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let img = UIImage(named: "photo")!
        // also we can pass image array
        let parameters: APIParameters = [
            "function" : "new_place",
            "title" : "ahmedabad",
            "img" : img,
            "description" : "this is test image upload through multipart form data request using SwiftHttp thanks for you concern",
            "lat" : "12.2222",
            "long" : "13.3333"
        ]
        SHNetwork.observePostRequest(param: parameters, onSuccess: { jsonDict in
            print(jsonDict)
        })
    }
    
}
extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = places[indexPath.row].title
        cell.detailTextLabel?.text = places[indexPath.row].descript
        cell.imageView?.loadImageusingCacheWithURLstring(urlString: places[indexPath.row].img!)
        return cell
    }
    
}
class Dashboard: NSObject {
    
    var img: String?
    var lat: String?
    var long: String?
    var placeId: String?
    var title: String!
    var descript: String?
    
    init?(data: [String : Any]) {
        
        if let title = data["title"] as? String,
            let img = data["img"]as? String,
            let lat = data["lat"] as? String,
            let long = data["long"] as? String,
            let placeid = data["place_id"] as? String,
            let descript = data["description"] as? String {
            self.title = title
            self.img = img
            self.lat = lat
            self.long = long
            self.placeId = placeid
            self.descript = descript
            
        }else{
            return nil
        }
    }
}

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageusingCacheWithURLstring(urlString: String)  {
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = cachedImage
            return
        }
        //New download
        URLSession.shared.dataTask(with: URL(string: urlString)!, completionHandler: { data ,response,err in
            if err != nil{
                print(err!)
                return
            }
            OperationQueue.main.addOperation {
                if let downloadedImage = UIImage(data: data!){
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = UIImage(data: data!)
                }
            }
        }).resume()
    }
}

