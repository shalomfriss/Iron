//
//  FeedView.swift
//  Sunrise Fit
//
//  Created by Karim Abou Zeid on 19.06.19.
//  Copyright © 2019 Karim Abou Zeid Software. All rights reserved.
//

import SwiftUI
import CoreData
import Combine

struct FeedView : View {
    var pinnedCharts = UserDefaults.standard.pinnedCharts()

    var body: some View {
        return NavigationView {
            List {
                Section {
                    ActivityChartViewCell()
                    FeedSummaryView()
                        .frame(height: 145)
                }
                
                Section {
                    ForEach(pinnedCharts) { chart in
                        PinnedChartViewCell(pinnedChart: chart)
                    }
                    PresentationButton(destination:
                        // TODO: present actual view to choose exercise
                        Text("Placeholder")
                    ) {
                        Text("Add Widget")
                    }
                }
            }
            .listStyle(.grouped)
            .navigationBarTitle(Text("Feed"))
        }
    }
}

#if DEBUG
struct FeedView_Previews : PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
#endif
