//
//  VideoController.swift
//  Hinds_Justin_DestinyApp
//
//  Created by Justin Hinds on 7/24/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit

class VideoController: UICollectionViewController {
    
    override func viewDidLoad() {
        let vidAPI = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=20&order=date&q=destiny+%2B+mesasean&type=video&key=AIzaSyDlUyfC0nn6AaaKmMR7Rt00Or3vh0x6i1s"
        let vidURL = URL(string: vidAPI)
        let request = URLRequest(url:vidURL!)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let realResponse = response as? HTTPURLResponse ,
                realResponse.statusCode == 200 else{
                    print("code not 200")
                    return
            }
            print(response)
        }) 
        
    }
}
