import SwiftUI

public struct IncomeFormView: View {
    @StateObject public var viewModel = AddIncomeViewModel()
    @Environment(\.dismiss) private var dismiss
    
    public init() {}
    
    public var body: some View {

    }
}

#Preview {
    IncomeFormView()
}
