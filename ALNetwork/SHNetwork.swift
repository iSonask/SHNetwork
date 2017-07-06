//
//  ALNetwork.swift
//  ALNetwork
//
//  Created by Akash on 05/07/17.
//  Copyright © 2017 Akash. All rights reserved.
//

import Foundation
import SwiftHTTP

public typealias APIParameters = [String: Any]
public typealias JSONResponse = [String: Any]

class SHNetwork{
    
    class func observePostRequest(param: APIParameters,onSuccess:@escaping((JSONResponse) -> Void)){
        let header = ["X-Auth":"WKx0V4aULbHT8gf6i4fgDA&gws"]
        do {
            
            let opt = try HTTP.POST("http://addonwebsolutions.net/mychatapp/mahesh_test/objects.php", parameters: generateParameters(param), headers: header, requestSerializer: HTTPParameterSerializer()) // http parametr or it can be jsonparameterserializer
            // for json
        //            let opt = try HTTP.GET("http://addonwebsolutions.net/mychatapp/mahesh_test/objects.php", parameters: generateParameters(param), headers: header, requestSerializer: JSONParameterSerializer())
            opt.start { response in
                //do things...
                
                let response = response.data.toDict
                onSuccess(response!)
            }
            
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    class func observeGetRequest(param: APIParameters,onSuccess:@escaping((JSONResponse) -> Void)){
        let header = ["X-Auth":"WKx0V4aULbHT8gf6i4fgDA&gws"]
        do {
            // for http param
            let opt = try HTTP.GET("http://addonwebsolutions.net/mychatapp/mahesh_test/objects.php", parameters: generateParameters(param), headers: header, requestSerializer: HTTPParameterSerializer()) // http parametr or it can be jsonparameterserializer
            // for json
            //            let opt = try HTTP.GET("http://addonwebsolutions.net/mychatapp/mahesh_test/objects.php", parameters: generateParameters(param), headers: header, requestSerializer: JSONParameterSerializer())
            opt.start { response in
                //do things...
                
                let response = response.data.toDict
                onSuccess(response!)
            }
            
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
    private static func generateParameters(_ param: APIParameters? ) -> APIParameters? {
        
        guard param != nil else {
            return nil
        }
        
        var parameters: APIParameters = [:]
        
        for (key,value) in param! {
            
            if let image = value as? UIImage {
                
                if let data =  UIImagePNGRepresentation(image){
                    parameters[key] = Upload(data: data, fileName: String(format: "%@.png", key), mimeType: "image/png")
                }
                
            }else if let images = value as? [UIImage] {
                
                var uploads: [Upload] = []
                
                for i in 0..<images.count {
                    if let data =  UIImagePNGRepresentation(images[i]){
                        uploads.append(Upload(data: data, fileName: String(format:"%@-%zd.png",key,i), mimeType: "image/png"))
                    }
                }
                
                parameters[key] = uploads
            }else{
                parameters[key] = value
            }
            
        }
        
        return parameters
    }
}
extension Data {
    
    public var toDict : [String: Any]! {
        do{
            let json = try JSONSerialization.jsonObject(with: self, options: [])
            return json as! [String : Any]
        } catch{
            return nil
        }
    }
}


extension Dictionary where Key == String, Value == Any {
    
    func stringValue(_ key: String) -> String? {
        return self[key] as? String
    }
    
    subscript(string key: Key) -> String? {
        return self[key] as? String
    }
}
