//
//  ReadingListViewController.swift
//  Pixels News
//
//  Created by Alief Azies on 27/10/21.
//

import UIKit
import Kingfisher
import SafariServices

class ReadingListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    weak var pageControl: UIPageControl?
    
    var news: [NewsData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "NewsViewCell", bundle: nil), forCellReuseIdentifier: "news_cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadNewsData), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
        
        loadNewsData()
    }
    
    @objc func reloadNewsData() {
        loadNewsData()
        tableView.reloadData()
    }
    
    func loadNewsData() {
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.viewContext
        news = NewsData.select(context: context)
    }
    
    func deleteNews(_ news: NewsData){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.viewContext
        
        context.delete(news)
        appDelegate.saveContext()
    }
    
    func softDeleteNews(_ news: NewsData){
        news.isActive = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
    }
    
}

extension ReadingListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "news_cell", for: indexPath) as! NewsTableViewCell
        let berita = news[indexPath.row]
        
        cell.titleLabel.text = berita.title
        cell.descLabel.text = ["\(berita.published_date.string(format: "MMM d, yyyy"))", berita.section].joined(separator: " • ")
        cell.thumbImageLabel.kf.setImage(with: URL(string: berita.thumb))
        
        cell.topConstraint.constant = indexPath.row == 0 ? 20 : 10
        cell.bottomConstraint.constant = indexPath.row == news.count - 1 ? 20 : 10
        
        cell.titleLabel.alpha  = berita.isActive ? 1 : 0.5
        cell.descLabel.alpha = berita.isActive ? 1 : 0.5
        cell.thumbImageLabel.alpha = berita.isActive ? 1 : 0.5
        
        return cell
    }
}

extension ReadingListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = news[indexPath.row]
        if let url = URL(string: news.url) {
            let viewController = SFSafariViewController(url: url)
            present(viewController, animated: true, completion: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            let soft = UITableViewRowAction(style: .default, title: "Soft Delete", handler: { _, indexPath in
                let news = self.news[indexPath.row]
                self.softDeleteNews(news)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            })
            soft.backgroundColor = .purple
            
            let hard = UITableViewRowAction(style: .destructive, title: "Hard Delete", handler: { _, Index in
                    let news = self.news.remove(at: indexPath.row)
                    self.deleteNews(news)
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                })
            hard.backgroundColor = .red
            return [soft, hard]
        }
    
//    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
//        let news = news[indexPath.row]
//        return news.isActive ? "Soft Delete" : "Hard Delete"
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
//            let news = self.news[indexPath.row]
//            if news.isActive{
//                self.softDeleteNews(news)
//                self.tableView.deleteRows(at: [indexPath], with: .automatic)
//            }else{
//                self.news.remove(at: indexPath.row)
//                self.tableView.deleteRows(at: [indexPath], with: .automatic)
//                self.deleteNews(news)
//            }
//        }))
//        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
//        present(alert, animated: true, completion: nil)
//    }
}
