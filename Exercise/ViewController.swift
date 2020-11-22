//
//  ViewController.swift
//  Exercise
//
//  Created by Matheus Ruschel on 2020-11-21.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var tableView: UITableView = {
        var tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        return tableView
    }()
    
    
    var networking: Networking!
    var stories: [News] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StoryTableViewCell.self, forCellReuseIdentifier: "StoryTableViewCell")
        
        tableView.snp.makeConstraints {
            $0.trailing.leading.top.bottom.equalTo(view)
        }
        
        networking = Networking(baseUrl: hackerNewsBaseUrl)
        
        networking.fetchNews(completion: { result in
            
            switch result {
            case .success(let newsArray):
                self.stories = newsArray
            case .failure(let error):
                print(error)
            }
        })
    }

}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StoryTableViewCell", for: indexPath) as? StoryTableViewCell else {
            return UITableViewCell()
        }
        
        let story = stories[indexPath.row]
        
        cell.titleLabel.text = story.title ?? ""
        cell.descriptionLabel.text = story.by ?? ""
        
        return cell
    }
    
    
    
    
    
}

