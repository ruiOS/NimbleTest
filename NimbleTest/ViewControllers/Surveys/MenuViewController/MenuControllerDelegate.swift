//
//  MenuControllerDelegate.swift
//  NimbleTest
//
//  Created by rupesh on 24/03/22.
//

import Foundation

/// Delegates to interact with Menu Controller actions
protocol MenuControllerDelegate{
    /// Calls when user selects cell
    /// - Parameter cell: cell the user selected
    func userDidSelectCell(cell: MenuControllerViewModel.MenuControllerCellType)
}
