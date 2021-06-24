//
//  AppCell.swift
//
//  Created by Ashish on 20/08/20.
//  Copyright © 2020 Ashish. All rights reserved.
//

import Foundation
import UIKit

/// MARK: - This protocol is used to allows cell to be dequeued with strong type
public protocol DequeuableProtocol: class {
  
  /// Return the nib name in which the dequeuable resource is located
  /// You must implement it if your cell is located in a separate xib file
  /// (not for storyboard).
  /// In this case you should call `table.register(CellClass.self)` before
  /// using it in your code.
  /// Default implementation returns the name of the class itself.
  static var dequeueNibName: String { get }
  
  /// This is the identifier used to queue/dequeue the cell.
  /// You don't need to override it; default implementation return the name
  /// of the cell class itself as identifier.
  static var dequeueIdentifier: String { get }
}

// MARK: - Default implementation of the protocol
extension DequeuableProtocol where Self: UIView {
  
  /// Return the same name of the class with module name as prefix ('MyApp.MyCell')
  public static var dequeueIdentifier: String {
    return NSStringFromClass(self).components(separatedBy: ".").last!
  }
  
  /// Return the name of the nib, it return the same name of the cell class itself
  public static var dequeueNibName: String {
    return NSStringFromClass(self).components(separatedBy: ".").last!
  }
}


// MARK: - Table View Registration and Dequeue
public extension UITableView {
  /// Register a cell from external xib into a table instance.
  ///
  /// - Parameter _: cell class
   func register<T: UITableViewCell>(_: T.Type) {
    let bundle = Bundle(for: T.self)
    let nib = UINib(nibName: T.dequeueNibName, bundle: bundle)
    self.register(nib, forCellReuseIdentifier: T.dequeueIdentifier)
  }
  
  /// Dequeue a cell instance strongly typed.
  ///
  /// - Parameter indexPath: index path
  /// - Returns: instance
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withIdentifier: T.dequeueIdentifier, for: indexPath) as? T else {
      fatalError("Cannot dequeue: \(T.self) with identifier: \(T.dequeueIdentifier)")
    }
    return cell
  }
}

// MARK: - Collection View Registration and Dequequ
public extension UICollectionView {
  /// Register a cell from external xib into a collection instance.
  ///
  /// - Parameter _: cell class
    func registerCell<T: UICollectionViewCell>(_: T.Type) {
    let bundle = Bundle(for: T.self)
    let nib = UINib(nibName: T.dequeueNibName, bundle: bundle)
    self.register(nib, forCellWithReuseIdentifier: T.dequeueIdentifier)
  }
  
  /// Dequequ a cell instance strongly typed.
  ///
  /// - Parameter indexpath: index path
  /// - Returns: instance
   func dequequReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withReuseIdentifier: T.dequeueIdentifier, for: indexPath) as? T else {
      fatalError("Cannot dequequ: \(T.self) with identifier: \(T.dequeueIdentifier)")
    }
    return cell
  }
  
}

extension UICollectionViewCell: DequeuableProtocol {}
extension UITableViewCell: DequeuableProtocol {}

