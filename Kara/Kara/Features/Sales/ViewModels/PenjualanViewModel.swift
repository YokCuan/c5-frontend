//
//  PenjualanViewModel.swift
//  Kara
//
//  Created by Jessica Evangeline Winardy on 02/09/26.
//

import Foundation
import Combine

@MainActor
public class PenjualanViewModel: ObservableObject {
    @Published public var salesNotes: [SalesNote] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil
    
    private var fetchTask: Task<Void, Never>?

    public func loadSalesNotes(shopId: UUID) async {
        fetchTask?.cancel()
        
        fetchTask = Task {
            if salesNotes.isEmpty {
                isLoading = true
            }
            errorMessage = nil
             
            do {
                let fetchedData = try await APIService.shared.fetchSalesNotes(shopId: shopId)
                print(fetchedData)
                
                if Task.isCancelled { return }
                
                self.salesNotes = fetchedData
                self.isLoading = false
                
                self.handleFetchedSalesNotes(fetchedData)
                
            } catch {
                if Task.isCancelled { return }
                
                self.isLoading = false
                
                print("DETAIL DECODE ERROR: \(error)")
                
                let errorString = error.localizedDescription.lowercased()
                
                if error is CancellationError || errorString.contains("cancel") || (error as NSError).code == -999 {
                    return
                }
                
                self.errorMessage = "Gagal memuat penjualan: \(error.localizedDescription)"
            }
        }
        
        _ = await fetchTask?.result
    }
    
    public func handleFetchedSalesNotes(_ notes: [SalesNote]){
        for note in notes{
            scheduleDueNotification(for: note)
        }
    }
}
