//
//  TabViewController.swift
//  HackerNews
//
//  Created by Aleksandr Svetilov on 01.11.2020.
//

import Tabman
import Pageboy

class TabViewController: TabmanViewController, PageboyViewControllerDataSource, TMBarDataSource {

    private var viewControllers = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self

        // Create bar
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap // Customize
        bar.layout.contentMode = .fit

        // Add to view
        
        addBar(bar.systemBar(), dataSource: self, at: .top)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = storyboard.instantiateViewController(withIdentifier: "frontPage")
        let vc2 = storyboard.instantiateViewController(withIdentifier: "latestStory")
        self.viewControllers = [vc1, vc2]
        self.reloadData()
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        nil
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        guard let title = viewControllers[index].title else { return TMBarItem(title: "none") }
        return TMBarItem(title: title)
    }
}
