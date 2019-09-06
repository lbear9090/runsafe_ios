//
//  UtilityClass.swift
//  Swift WebService
//
//  Created by Apple on 30/03/16.
//  Copyright © 2016 Lucky. All rights reserved.
//

import UIKit

@objc protocol UtilityDelegate
{
    @objc optional func gotResponse(data: AnyObject, forRequest tag: Int)
    @objc optional func failure(data: AnyObject)
    @objc optional func failure(data: AnyObject, forRequest tag: Int)
}

enum KeyType_t : Int
{
    case TYPE_INTEGER=0
    case TYPE_DATE = 1
    case TYPE_ALPHABET=2
}


class UtilityClass: NSObject,URLSessionDataDelegate,URLSessionDelegate,UtilityDelegate
{
    
    
    var delegate: UtilityDelegate?
    var receivedData:NSMutableData!
    var tagNumber:NSInteger!
    var AsynchtagNumber:NSInteger!
    
   
    
    // MARK: - WebService Call Method (Synchronous Request)
    
    func webServiceCallMethod( QueryString: String, forWebServiceCall: String, setHTTPMethod: String, withTag requestTag: Int)
    {
        tagNumber = requestTag
        
        var qryString=QueryString
        qryString = qryString.replacingOccurrences(of: "Optional", with: "")
        qryString = qryString.replacingOccurrences(of: ")", with: "")
        qryString = qryString.replacingOccurrences(of: "(", with: "")
        qryString = qryString.replacingOccurrences(of: "\n", with: "")
        qryString = qryString.replacingOccurrences(of: "\"", with: "")
        
//        let postData: NSData = qryString.dataUsingEncoding(String.Encoding.asciiString.Encoding.ascii, allowLossyConversion: true)! as NSData

        
//        let postData: NSData = qryString.dataUsingEncoding(String.Encoding.asciiString.Encoding.ascii, allowLossyConversion: true)! as NSData
//
//        let postLength: String = "\(UInt(postData.length))"
//
//        let request: NSMutableURLRequest = NSMutableURLRequest()
//        request.url = NSURL(string:forWebServiceCall)! as URL
//        request.httpMethod = setHTTPMethod
//        request.timeoutInterval=180
//        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
//        request.httpBody = postData as Data
//        let defaultConfigObject: URLSessionConfigurationURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
//        let defaultSession: URLSession = URLSessionURLSession(configuration:defaultConfigObject, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
//        let data: NSMutableData = NSMutableData()
//        receivedData = data
//        let dataTask: URLSessionDataTask = defaultSession.dataTask(with: request as URLRequest)
//        dataTask.resume()
    }
//
//    func URLSession(session: URLSession, dataTask: URLSessionDataTask, didReceiveResponse response: URLResponse, completionHandler: (URLSession.ResponseDisposition) -> Void)
//    {
//        completionHandler(URLSession.ResponseDisposition.Allow)
//    }
//
//    func URLSession(session: URLSession, dataTask: URLSessionDataTask, didReceiveData data: NSData) {
//        receivedData.append(data as Data)
//    }
//
//
    func URLSession(session: URLSession, task: URLSessionTask, didCompleteWithError error: NSError?)
    {
//        if error == nil
//        {
//            NSLog("Download is Succesfull")
//            do
//            {
//                let post:NSDictionary = try JSONSerialization.JSONObjectWithData(receivedData as Data,
//                                                                                 options:JSONSerialization.ReadingOptionsJSONSerialization.ReadingOptions.MutableContainers) as! NSDictionary
//
//                if post .isProxy()
//                {
//                    if self.responds(to: #selector(UtilityDelegate.gotResponse(_:forRequest:)))
//                    {
//                        delegate!.failure!(NSError(domain: "Error", code: 0, userInfo: nil), forRequest: tagNumber)
//                    }
//                }
//
//                if self.responds(to: #selector(UtilityDelegate.gotResponse(_:forRequest:)))
//                {
//                    delegate!.gotResponse!(data: post, forRequest: tagNumber)
//                }
//
//            }
//            catch
//            {
//                print("error trying to convert data to JSON")
//                if self.responds(to: #selector(UtilityDelegate.gotResponse(_:forRequest:)))
//                {
//                    delegate!.failure!(NSError(domain: "Error", code: 0, userInfo: nil), forRequest: tagNumber)
//                }
//                return
//            }
//        }
//        else
//        {
//            if self.responds(to: #selector(UtilityDelegate.gotResponse(_:forRequest:)))
//            {
//                delegate!.failure!(NSError(domain: "Error", code: 0, userInfo: nil), forRequest: tagNumber)
//            }
//        }
    }
    
    func gotResponse(data: AnyObject, forRequest tag: Int) {
        
    }
    func failure(data: AnyObject, forRequest tag: Int) {
        
    }
    func failure(data: AnyObject) {
        
    }
    
    // MARK: - WebService Call Method(ASynchronous Request)
    
    func asynchronousRequestCallMethod(QueryString: String, forWebServiceCall: String, setHTTPMethod: String, withTag requestTag: Int)
    {
//
//        AsynchtagNumber = requestTag
//
//        var qryString=QueryString
//        qryString = qryString.replacingOccurrences(of: "Optional", with: "")
//        qryString = qryString.replacingOccurrences(of: ")", with: "")
//        qryString = qryString.replacingOccurrences(of: "(", with: "")
//        qryString = qryString.replacingOccurrences(of: "\n", with: "")
//        qryString = qryString.replacingOccurrences(of: "\"", with: "")
//
//
//        let SessionConfiguration:URLSessionConfiguration=URLSessionConfiguration.default
//
//        let Session:URLSession=URLSession(configuration: SessionConfiguration, delegate: nil, delegateQueue: OperationQueue.mainQueue())
//
//        let url:NSURL=NSURL(string: forWebServiceCall)!
//
//        let Request:NSMutableURLRequest=NSMutableURLRequest(url: url as URL)
//
//        Request.httpMethod=setHTTPMethod
//
//        Request.timeoutInterval=180
//
//        Request.httpBody=qryString.data(using: String.Encoding.utf8)
//
//        let Task:URLSessionDataTask=Session.dataTaskWithRequest(Request as URLRequest) { (FinalData:NSData?,response:URLResponse?,error:NSError?) -> Void in
//            if (error==nil)
//            {
//                do
//                {
//                    let Json = try NSJSONSerialization.JSONObjectWithData(FinalData!, options: NSJSONReadingOptions.MutableContainers)
//
//                    if self.respondsToSelector(#selector(UtilityDelegate.gotResponse(_:forRequest:)))
//                    {
//                        self.delegate!.gotResponse!(Json, forRequest: self.AsynchtagNumber)
//                    }
//                }
//                catch
//                {
//                    if self.respondsToSelector(#selector(UtilityDelegate.gotResponse(_:forRequest:)))
//                    {
//                        self.delegate!.failure!(NSError(domain: "Error", code: 0, userInfo: nil), forRequest: self.AsynchtagNumber)
//                    }
//                }
//
//                if (FinalData != nil)
//                {
//                    let Json:NSDictionary = try!NSJSONSerialization.JSONObjectWithData(FinalData!,options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
//                    
//                    //NSLog("%@", Json)
//                    
//                    if self.respondsToSelector(#selector(UtilityDelegate.gotResponse(_:forRequest:)))
//                    {
//                        self.delegate!.gotResponse!(Json, forRequest: self.AsynchtagNumber)
//                    }
//                }
//                else
//                {
//                    if self.respondsToSelector(#selector(UtilityDelegate.gotResponse(_:forRequest:)))
//                    {
//                        self.delegate!.failure!(NSError(domain: "Error", code: 0, userInfo: nil), forRequest: self.AsynchtagNumber)
//                    }
//                }
               
//            }
//            else
//            {
//                if self.respondsToSelector(#selector(UtilityDelegate.gotResponse(_:forRequest:)))
//                {
//                    self.delegate!.failure!(NSError(domain: "Error", code: 0, userInfo: nil), forRequest: self.AsynchtagNumber)
//                }
//            }
//        }
//        Task.resume()
    }
    
    // MARK: - Upload image (ASynchronous Request)
    
    func UploadImageWebServiceCallMethod(qryString: String, UIImage img: UIImage, withImageControl imgKey: String, forWebServiceCall: String, setHTTPMethod: String, withTag requestTag: Int)
    {
//        tagNumber = requestTag;
//        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: forWebServiceCall)! as URL)
//        let imageData: NSData = UIImageJPEGRepresentation(img, 0.1)! as NSData
//        request.httpMethod = "POST"
//        request.timeoutInterval=180
//        let boundary: String = "---------------------------14737809831466499882746641449"
//        let body: NSMutableData = NSMutableData()
//
//        var arr: [AnyObject] = qryString.components(separatedBy: "&")
//
//        for i in 0 ..< arr.count {
//            var ar: [AnyObject] = arr[i].components("=") as [AnyObject]
//            body.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//            body.append("Content-Disposition: form-data; charset=UTF-8; name=\"\(ar[0])\"\r\n\r\n\(ar[1])".data(using: String.Encoding.utf8)!)
//        }
//
//        let contentType: String = "multipart/form-data; boundary=\(boundary)"
//        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
//        //   NSMutableData *body = [NSMutableData data];
//        body.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//        body.append("Content-Disposition: form-data; name=\"\(imgKey)\"; filename=\"ifile.jpg\"\r\n".data(using: String.Encoding.utf8)!)
//        body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: String.Encoding.utf8)!)
//        body.append(NSData(data: imageData as Data) as Data)
//        body.append("\r\n--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
//        // setting the body of the post to the reqeust
//        request.httpBody = body as Data
//        let postLength: String = "\(UInt(body.length))"
//        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
//
//        let SessionConfiguration:URLSessionConfiguration=URLSessionConfigurationURLSessionConfiguration.defaultSessionConfiguration()
//
//        let Session:URLSession=URLSession(configuration: SessionConfiguration, delegate: nil, delegateQueue: OperationQueue.mainQueue())
//
//        let Task:URLSessionDataTask=Session.dataTaskWithRequest(request as URLRequest) { (FinalData:NSData?,response:URLResponse?,error:NSError?) -> Void in
//            if (error==nil)
//            {
//                let Json:NSDictionary = try!NSJSONSerialization.JSONObjectWithData(FinalData!,options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
//
//              //  NSLog("%@", Json)
//
//                if self.respondsToSelector(#selector(UtilityDelegate.gotResponse(_:forRequest:)))
//                {
//                    self.delegate!.gotResponse!(Json, forRequest: self.tagNumber)
//                }
//
//            }
//            else
//            {
//                if self.respondsToSelector(#selector(UtilityDelegate.gotResponse(_:forRequest:)))
//                {
//                    self.delegate!.failure!(NSError(domain: "Error", code: 0, userInfo: nil), forRequest: self.tagNumber)
//                }
//            }
//
//        }
//        Task.resume()
        
    }
    
    // MARK: - Upload Multiple Images (ASynchronous Request)
    
    func UploadMultipleImageWebServiceCallMethod(qryString: String,FileArr arrFiles: NSArray, withImageControl imgKey: String, forWebServiceCall: String, setHTTPMethod: String, withTag requestTag: Int)
    {
//        tagNumber = requestTag
//
//        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: forWebServiceCall)! as URL)
//        request.httpMethod = "POST"
//        request.timeoutInterval=180
//        let boundary: String = "---------------------------14737809831466499882746641449"
//        // post body
//        let body: NSMutableData = NSMutableData()
//        // add params (all params are strings)
//        var arr: [AnyObject] = qryString.componentsSeparatedBy("&")
//
//        for i in 0 ..< arr.count {
//            var ar: [AnyObject] = arr[i].components("=") as [AnyObject]
//            body.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//            body.append("Content-Disposition: form-data; charset=UTF-8; name=\"\(ar[0])\"\r\n\r\n\(ar[1])".data(using: String.Encoding.utf8)!)
//        }
//        let contentType: String = "multipart/form-data; boundary=\(boundary)"
//        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
//
//        for i in 0 ..< arrFiles.count {
//            body.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//            body.appendData("Content-Disposition: form-data; name=\"\(imgKey)\"; filename=\"\(arrFiles[i]["Name"] as! String)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
//            body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: String.Encoding.utf8)!)
//            let imageData: NSData
//
//            if ((arrFiles[i]["Type"] as! String) == "image")
//            {
//                imageData=UIImageJPEGRepresentation((arrFiles.objectAtIndex(i) as AnyObject).valueForKey("File") as! UIImage,1.0)!
//            }
//            else
//            {
//                imageData = NSData(contentsOfURL: NSURL(string:(arrFiles[i]["File"] as! String))!)!
//            }
//
//            body.append(NSData(data: imageData as Data) as Data)
//            body.append("\r\n--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
//            // setting the body of the post to the reqeust
//            request.httpBody = body as Data
//
//        }
//        let postLength: String = "\(UInt(body.length))"
//        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
//
//
//        let SessionConfiguration:URLSessionConfiguration=URLSessionConfiguration.default
//
//        let Session:URLSession=URLSession(configuration: SessionConfiguration, delegate: nil, delegateQueue: OperationQueue.mainQueue())
//
//        let Task:URLSessionDataTask=Session.dataTaskWithRequest(request as URLRequest) { (FinalData:NSData?,response:URLResponse?,error:NSError?) -> Void in
//            if (error==nil)
//            {
//                let Json:NSDictionary = try!NSJSONSerialization.JSONObjectWithData(FinalData!,options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
//
//               // NSLog("%@", Json)
//
//                if self.respondsToSelector(#selector(UtilityDelegate.gotResponse(_:forRequest:)))
//                {
//                    self.delegate!.gotResponse!(Json, forRequest: self.tagNumber)
//                }
//
//            }
//            else
//            {
//                if self.respondsToSelector(#selector(UtilityDelegate.gotResponse(_:forRequest:)))
//                {
//                    self.delegate!.failure!(NSError(domain: "Error", code: 0, userInfo: nil), forRequest: self.tagNumber)
//                }
//            }
//
//        }
//        Task.resume()
        
    }
    
    // MARK: - UploadTwo Images (ASynchronous Request)
    
    func UploadTwoImageWebServiceCallMethod(qryString: String, UIImage1 img1: UIImage, UIImage2 img2: UIImage, withImageControl1 imgKey1: String, withImageControl2 imgKey2: String, forWebServiceCall: String, setHTTPMethod: String, withTag requestTag: Int)
    {
//
//        tagNumber = requestTag
//        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: forWebServiceCall)! as URL)
//
//        let imageData1: NSData = UIImageJPEGRepresentation(img1, 0.1)! as NSData
//        let imageData2: NSData = UIImageJPEGRepresentation(img2, 0.1)! as NSData
//        request.httpMethod = "POST"
//        request.timeoutInterval=180
//        let boundary: String = "---------------------------14737809831466499882746641449"
//
//        let body: NSMutableData = NSMutableData()
//
//        var arr: [AnyObject] = qryString.componentsSeparatedBy("&") as [AnyObject]
//
//        for i in 0 ..< arr.count {
//            var ar: [AnyObject] = arr[i].components("=") as [AnyObject]
//            body.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//            body.append("Content-Disposition: form-data; charset=UTF-8; name=\"\(ar[0])\"\r\n\r\n\(ar[1])".data(using: String.Encoding.utf8String.Encoding.utf8)!)
//        }
//
//        let contentType: String = "multipart/form-data; boundary=\(boundary)"
//        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
//
//        if (img1.isProxy()==false)
//        {
//            body.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//            body.append("Content-Disposition: form-data; name=\"\(imgKey1)\"; filename=\"ifile.jpg\"\r\n".data(using: String.Encoding.utf8)!)
//            body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: String.Encoding.utf8)!)
//            body.append(NSData(data:imageData1 as Data) as Data)
//        }
//        if (img2.isProxy()==false)
//        {
//            body.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//
//            body.append("Content-Disposition: form-data; name=\"\(imgKey2)\"; filename=\"ifile.jpg\"\r\n".data(using: String.Encoding.utf8)!)
//
//            body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: String.Encoding.utf8)!)
//
//            body.append(NSData(data:imageData2 as Data) as Data)
//        }
//        body.append("\r\n--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
//        request.httpBody = body as Data
//        let postLength: String = "\(UInt(body.length))"
//        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
//
//        let SessionConfiguration:URLSessionConfiguration=URLSessionConfiguration.default
//
//        let Session:URLSession=URLSession(configuration: SessionConfiguration, delegate: nil, delegateQueue: OperationQueue.mainQueue())
//
//        let Task:URLSessionDataTask=Session.dataTaskWithRequest(request as URLRequest) { (FinalData:NSData?,response:URLResponse?,error:NSError?) -> Void in
//            if (error==nil)
//            {
//                let Json:NSDictionary = try!NSJSONSerialization.JSONObjectWithData(FinalData!,options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
//
//              //  NSLog("%@", Json)
//
//                if self.respondsToSelector(#selector(UtilityDelegate.gotResponse(_:forRequest:)))
//                {
//                    self.delegate!.gotResponse!(Json, forRequest: self.tagNumber)
//                }
//
//            }
//            else
//            {
//                if self.respondsToSelector(#selector(UtilityDelegate.gotResponse(_:forRequest:)))
//                {
//                    self.delegate!.failure!(NSError(domain: "Error", code: 0, userInfo: nil), forRequest: self.tagNumber)
//                }
//            }
//        }
//        Task.resume()
        
    }
    
     // MARK: - Sort Array Of Dictionary
    
    func sortArrayofDictonary( orginalArray: NSMutableArray, withKey keyValue: String, keyType keytype: KeyType_t, ToAscending isAscending: Bool)
    {
        var keyDescriptor: NSSortDescriptor
        
        if keytype.hashValue == 0
        {
            keyDescriptor=NSSortDescriptor(key:keyValue, ascending: isAscending, comparator: { (obj1:AnyObject, obj2:AnyObject) -> ComparisonResult in
                       if CFloat(obj1 as! Float) > CFloat(obj2 as! Float)
                      {
                        return (ComparisonResult.orderedDescending)
                      }
                      if CFloat(obj1 as! Float) < CFloat(obj2 as! Float)
                      {
                        return (ComparisonResult.orderedAscending)
                      }
                return (ComparisonResult.orderedSame)
                } as! Comparator)
        }
       else if keytype.hashValue == 1
        {
            keyDescriptor=NSSortDescriptor(key: keyValue, ascending: isAscending, comparator: { (obj1: AnyObject, obj2: AnyObject) -> ComparisonResult in
                let dateFormatter: DateFormatter = DateFormatter()
                                //Set the AM and PM symbols
                                //[dateFormatter setAMSymbol:@"AM"];
                                //[dateFormatter setPMSymbol:@"PM"];
                                //Specify only 1 M for month, 1 d for day and 1 h for hour
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let d1: NSDate = dateFormatter.date(from: obj1 as! String)! as NSDate
                let d2: NSDate = dateFormatter.date(from: obj2 as! String)! as NSDate
                if d1.compare(d2 as Date) == ComparisonResult.orderedAscending
                                {
                                    return (ComparisonResult.orderedAscending)
                                }
                if d1.compare(d2 as Date) == ComparisonResult.orderedDescending {
                    return (ComparisonResult.orderedDescending)
                                }
                return (ComparisonResult.orderedSame)
                } as! Comparator as! Comparator)
        }
        else
        {
            keyDescriptor = NSSortDescriptor(key: keyValue, ascending: isAscending)
        }
        
        let sortDescriptors: NSArray = NSArray(object: keyDescriptor)
     
        let sortedArray:NSArray=NSArray(array: orginalArray.sortedArray(using: sortDescriptors as! [NSSortDescriptor]))
        
        orginalArray.removeAllObjects()
        
        for i in 0 ..< sortedArray.count
        {
            orginalArray.add(sortedArray[i])
        }
    }
}

