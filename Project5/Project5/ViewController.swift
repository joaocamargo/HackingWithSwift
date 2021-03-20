//
//  ViewController.swift
//  Project5
//
//  Created by joao camargo on 20/03/21.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWord = try? String(contentsOf: startWordsURL) {
                allWords = startWord.components(separatedBy: "\n")
            }
            
            if allWords.isEmpty {
                allWords = ["silkworm"]
            }
            
            startGame()
            
        }
    }
    
    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc func promptForAnswer(){
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
              
        let submitAction = UIAlertAction(title: "submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else {return}
            self?.submit(answer)
         }
        
        ac.addAction(submitAction)
        present(ac,animated: true)
    }
    
    func submit(_ answer: String) {
        
        let errorTitle: String
        let errorMessage: String
        
        if answer.count == 0 {
            errorTitle = "Not a word"
            errorMessage = ""
            return
        }
        
        let lowerAnser = answer.lowercased()
        
        if isPossible(word: lowerAnser) {
            if isOriginal(word: lowerAnser) {
                if isReal(word: lowerAnser){
                    usedWords.insert(answer, at: 0)
                    
                    let indexPath  = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    return
                } else {
                    print("not real")
                    errorTitle = "Not a recognized word"
                    errorMessage = "make it better"
                }
            } else {
                errorTitle = "Word already in use"
                errorMessage = "Be original"
               print("not original")
            }
        } else {
            errorTitle = "Word not possible"
            errorMessage = "you cant spell that word from \(title?.lowercased())"
            print("not possible")
        }
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else {return false}
        for letter in word {
            if let position = tempWord.firstIndex(of: letter){
                tempWord.remove(at: position)
                print(tempWord)
            } else {
                return false
            }
            
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelRange.location == NSNotFound
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.map{ $0.lowercased()}.contains(word)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
}

