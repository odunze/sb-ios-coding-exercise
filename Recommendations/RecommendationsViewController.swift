//
//  ViewController.swift
//  Recommendations
//

import UIKit
import OHHTTPStubs

struct Recommendation: Codable {
    var imageURL: String
    var title: String
    var tagline: String
    var rating: Float?
    var isReleased: Bool

    enum CodingKeys: String, CodingKey {
        case imageURL = "image"
        case title
        case tagline
        case rating
        case isReleased = "is_released"
    }
}

struct Titles: Codable {
    let titles: [Recommendation]
    let skipped: [String]
    let titlesOwned: [String]

    enum CodingKeys: String, CodingKey {
        case titles
        case skipped
        case titlesOwned = "titles_owned"
    }
}


class RecommendationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var vm: RecommendationsViewModel = RecommendationsViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    var recommendations = [Recommendation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ---------------------------------------------------
        // -------- <DO NOT MODIFY INSIDE THIS BLOCK> --------
        // stub the network response with our local ratings.json file
        let stub = Stub()
        stub.registerStub()
        // -------- </DO NOT MODIFY INSIDE THIS BLOCK> -------
        // ---------------------------------------------------
        
        tableView.register(UINib(nibName: "RecommendationTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        // NOTE: please maintain the stubbed url we use here and the usage of
        // a URLSession dataTask to ensure our stubbed response continues to
        // work; however, feel free to reorganize/rewrite/refactor as needed
        guard let url = URL(string: Stub.stubbedURL_doNotChange) else { fatalError() }
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)

        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let receivedData = data else { return }
            
            // TASK: This feels gross and smells. Can this json parsing be made more robust and extensible?
            do {
                
                let jsonDecoder = JSONDecoder()
                let json = try jsonDecoder.decode(Titles.self, from: receivedData)
                
                self.recommendations = json.titles
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            catch {
                fatalError("Error parsing stubbed json data: \(error)")
            }
        });

        task.resume()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RecommendationTableViewCell
        
        let recommendation = recommendations[indexPath.row]

        cell.titleLabel.text = recommendation.title
        cell.taglineLabel.text = recommendation.tagline
        cell.ratingLabel.text = "Rating: \(recommendation.rating)"
        
        if let url = URL(string: recommendation.imageURL) {
            let data = try? Data(contentsOf: url)

            if let imageData = data {
                let image = UIImage(data: imageData)
                cell.recommendationImageView?.image = image
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if vm.showTopTen() {
            return vm.topTen.count
        } else {
            return recommendations.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
}

class RecommendationsViewModel {
    
    private var shouldShowTopTen: Bool = false
    
    var topTen: [Recommendation] = []
    
    func showTopTen() -> Bool {
        return shouldShowTopTen
    }
}
