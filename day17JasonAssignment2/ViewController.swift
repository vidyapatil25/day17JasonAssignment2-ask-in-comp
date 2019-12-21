//
//  ViewController.swift
//  day17JasonAssignment2
//
//  Created by Felix-ITS016 on 20/12/19.
//  Copyright © 2019 Felix. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let str = imageArray[indexPath.row]
        
        let url = URL (string: str)
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            DispatchQueue.main.async {
                cell.imageView?.image =  UIImage(data: data!)

            }

        }
        dataTask.resume()
        return cell
        
    }
    
    var  imageArray = [String]()
    
  
    enum  JsonErrors:String,Error
    {
        case responseError = "Response Error"
        case dataError = "Data Error"
        case ConversionError = "Conversion Error"
    }
    
    func Parsejson()
    {
        let urlString = "https://api.github.com/repositories/19436/commits"
        let url:URL = URL(string: urlString)!
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession( configuration:sessionConfiguration)
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            do
            {
                guard let  response = response else
                {
                    throw JsonErrors.responseError
                }
                guard let data = data else
                {
                    throw JsonErrors.dataError
                }
                guard let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:Any]] else
                {
                    throw JsonErrors.ConversionError
                }
                for item in array
                {
                    let authorDic = item["author"] as! [String:Any]
                    let avatar_url = authorDic["avatar_url"] as! String
                    print(avatar_url)
                    self.imageArray.append( avatar_url)
                    
                }
                if self.imageArray.count>0
                {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
            }
            catch let err
            {
                print(err)
            }
        }
        dataTask.resume()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Parsejson()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

