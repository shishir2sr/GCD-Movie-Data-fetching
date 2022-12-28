//
//  ImageViewController.swift
//  MovieFlix
//
//  Created by Yeasir Arefin Tusher on 27/12/22.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    let posterImageBaseUrl = "https://image.tmdb.org/t/p/w500"
    
    // bring from previous vc:
    var imagePath: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemTeal
        imageView.contentMode = .scaleAspectFit
        
        if let imagePath = imagePath {
            
            let queue = DispatchQueue(label: "NetworkCall")
            
            queue.async { [weak self] in
                
                self?.downloadImage(from: imagePath) { [weak self] image in
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.imageView.image = image
                    }
                }
            }
        }
    }
}

extension ImageViewController {
    // MARK: Network Call
    
    func downloadImage(from imagePath: String, completed: @escaping (UIImage?) -> Void) {
        
        guard
            let url = URL(string: posterImageBaseUrl + imagePath)
        else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard
                let data = data,
                let image = UIImage(data: data)
            else {
                completed(nil)
                return
            }
            
            completed(image)
        }
        
        task.resume()
    }
}
