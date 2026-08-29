//
//  APIService.swift
//  Kara
//
//  Created by Jessica Evangeline Winardy on 29/08/26.
//

import Foundation

public class APIService {
    public static let shared = APIService()
    private init() {}
    
    private let baseURL = "https://kara-backend-khbo.onrender.com"
    
    func fetchCashFlows(shopId: UUID) async throws -> [CashFlowModel] {
        let urlString = "\(baseURL)/cashflows/\(shopId.uuidString)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorisation")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(
            httpResponse
                .statusCode) else{
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return try decoder.decode([CashFlowModel].self, from: data)
    }
    
    struct SalesNotesResponse: Decodable {
        let salesNote: SalesNote
        let salesNoteItems: [SalesNoteItem]
    }
    
    func fetchSalesNotes(shopId: UUID) async throws -> [SalesNote] {
            let urlString = "\(baseURL)/cashflow_sales_notes/\(shopId.uuidString)"
             
            guard let url = URL(string: urlString) else {
                throw URLError(.badURL)
            }
             
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
             
            let (data, response) = try await URLSession.shared.data(for: request)
             
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
             
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
             
            let results = try decoder.decode([SalesNotesResponse].self, from: data)
            
            let salesNotes = results.map { result in
                var salesNote = result.salesNote
                salesNote.items = result.salesNoteItems
                return salesNote
            }
             
            return salesNotes
        }
    
    public func fetchSalesNoteDetail(id: UUID, shopId: UUID) async throws -> SalesNote {
        let urlString = "\(baseURL)/cashflow_sales_notes/\(shopId.uuidString)/\(id.uuidString)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let result = try decoder.decode(SalesNotesResponse.self, from: data)
        
        var salesNote = result.salesNote
        salesNote.items = result.salesNoteItems
        
        return salesNote
    }
    
    public func createSalesNote(body: [String: Any]) async throws -> SalesNote {
        let urlString = "\(baseURL)/cashflow_sales_notes"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    // 👇 TAMBAHKAN BARIS INI UNTUK MELIHAT PESAN ERROR DARI SERVER DI KONSOL XCODE
                    if let errorString = String(data: data, encoding: .utf8) {
                        print("SERVER ERROR RESPONSE (-1011): \(errorString)")
                    }
                    throw URLError(.badServerResponse)
                }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let result = try decoder.decode(SalesNotesResponse.self, from: data)
        
        var salesNote = result.salesNote
        salesNote.items = result.salesNoteItems
        
        return salesNote
    }
    
    @discardableResult
    public func deleteSalesNote(id: UUID, shopId: UUID) async throws -> Bool {
        let urlString = "\(baseURL)/cashflow_sales_notes/\(shopId.uuidString)/\(id.uuidString)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return true
    }
    
    struct ExpenseResponse: Decodable {
        let expense: Expense
        let expenseItems: [ExpenseItem]
    }
    
    public func fetchExpenseDetail(id: UUID, shopId: UUID) async throws -> Expense {
        let urlString = "\(baseURL)/cashflow_expenses/\(shopId.uuidString)/\(id.uuidString)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let result = try decoder.decode(ExpenseResponse.self, from: data)
        
        var expense = result.expense
        expense.items = result.expenseItems
        
        return expense
    }
    
    public func createExpense(body: [String: Any]) async throws -> Expense {
        let urlString = "\(baseURL)/cashflow_expenses"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let result = try decoder.decode(ExpenseResponse.self, from: data)
        
        var expense = result.expense
        expense.items = result.expenseItems
        
        return expense
    }
    
    @discardableResult
    public func deleteExpense(id: UUID, shopId: UUID) async throws -> Bool {
        let urlString = "\(baseURL)/cashflow_expenses/\(shopId.uuidString)/\(id.uuidString)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return true
    }
    
    @discardableResult
    public func patchExpense(id: UUID, shopId: UUID, body: [String: Any]) async throws -> Expense {
        let urlString = "\(baseURL)/cashflow_expenses/\(shopId.uuidString)/\(id.uuidString)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH" 
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let result = try decoder.decode(ExpenseResponse.self, from: data)
        
        var expense = result.expense
        expense.items = result.expenseItems
        
        return expense
    }
    
    public func fetchExpenseCategories() async throws -> [ExpenseCategory] {
            let urlString = "\(baseURL)/expense_categories"
            guard let url = URL(string: urlString) else { throw URLError(.badURL) }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode([ExpenseCategory].self, from: data)
        }
    
    public func recordPayment(salesNoteId: UUID, shopId: UUID, paidAmount: Double, userId: UUID) async throws -> SalesNote {
            let urlString = "\(baseURL)/sales_notes/paid-amount/\(shopId.uuidString)/\(salesNoteId.uuidString)"
            guard let url = URL(string: urlString) else { throw URLError(.badURL) }
             
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
             
            let body: [String: Any] = [
                "paidAmount": paidAmount,
                "updatedBy": userId.uuidString
            ]
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
             
            let (data, response) = try await URLSession.shared.data(for: request)
             
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
             
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let result = try decoder.decode(SalesNotesResponse.self, from: data)
            var salesNote = result.salesNote
            salesNote.items = result.salesNoteItems
             
            return salesNote
        }
}
