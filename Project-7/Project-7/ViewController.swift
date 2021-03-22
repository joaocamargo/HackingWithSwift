//
//  ViewController.swift
//  Project-7
//
//  Created by joao camargo on 21/03/21.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {
    
    var petitions = [Petition]()
    var allPetitions = [Petition]()
    lazy var searchBar:UISearchBar = UISearchBar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var urlString: String // "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        configureSearchBar()
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        }
        else{
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                // we're OK to parse!
                parse(json: data)
                return
            }
        }
        showError()
    }
    
    
    func configureSearchBar(){
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "Connection error", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data){
        let  decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
            allPetitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = petitions[indexPath.row].title
        cell.detailTextLabel?.text = petitions[indexPath.row].body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String)
    {
        if textSearched.isEmpty {
            petitions = allPetitions
        } else {
            petitions = allPetitions.filter { ($0.body.lowercased().contains(textSearched.lowercased())) ||
                                              ($0.title.lowercased().contains(textSearched.lowercased()))
            }
        }
        tableView.reloadData()
    }
    
    
}

