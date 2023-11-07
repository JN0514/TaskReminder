//
//  TaskReminderWidgetBundle.swift
//  TaskReminderWidget
//
//  Created by JAYA$URYA on 07/11/23.
//

import WidgetKit
import SwiftUI

@main
struct TaskReminderWidgetBundle: WidgetBundle {
    var body: some Widget {
        TaskReminderWidget()
        TaskReminderWidgetLiveActivity()
    }
}
