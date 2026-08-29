//
//  CategoryStore.swift
//  Kara
//
//  Created by Jessica Evangeline Winardy on 29/08/26.
//

import Foundation
import Combine

public class CategoryStore: ObservableObject {
    public static let shared = CategoryStore()
    
    @Published public private(set) var categories: [ExpenseCategory] = []
    @Published public private(set) var isLoading: Bool = false
    @Published public private(set) var errorMessage: String? = nil
    
    private init() {}
    
    @MainActor
    public func fetchCategoriesIfNeeded() async {
        guard categories.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            self.categories = try await APIService.shared.fetchExpenseCategories()
            self.isLoading = false
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
}
