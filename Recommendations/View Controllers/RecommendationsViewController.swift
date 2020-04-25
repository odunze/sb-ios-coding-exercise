//
//  ViewController.swift
//  Recommendations
//

import UIKit
import OHHTTPStubs

class RecommendationsViewController: UIViewController {
    
    var vm: RecommendationsViewModel = RecommendationsViewModel()
        
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func topTenButtonTapped(_ sender: UIBarButtonItem) {
        vm.showTopTen.toggle()
        navigationItem.title = "Top Ten Recommendations"

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.estimatedRowHeight = 174
        tableView.rowHeight = UITableView.automaticDimension
    }
    
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
                
                self.vm.titles = json
                
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
}
