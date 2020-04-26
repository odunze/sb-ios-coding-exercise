//
//  RecommendationsVC+TableView.swift
//  Recommendations
//
//  Created by Lotanna Igwe-Odunze on 4/25/20.
//  Copyright © 2020 Serial Box. All rights reserved.
//

import UIKit

extension RecommendationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if vm.shouldShowTopTen() {
                return vm.topTen.count
            } else {
                return vm.recommendations.count
            }
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RecommendationTableViewCell
        
        let recommendation = vm.getRecommendation(at: indexPath.row)

        cell.titleLabel.text = recommendation.title
        cell.taglineLabel.text = recommendation.tagline
        cell.ratingLabel.text = recommendation.rated
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let cell = cell as? RecommendationTableViewCell  {
            let recommendation = vm.getRecommendation(at: indexPath.row)
            
            DispatchQueue.main.async {
                cell.recommendationImageView?.image = self.vm.getImage(for: recommendation)
            }
        }
    }
}
