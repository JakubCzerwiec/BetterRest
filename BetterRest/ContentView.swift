//
//  ContentView.swift
//  BetterRest
//
//  Created by Mój Maczek on 05/10/2024.
//

import CoreML
import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
   // @State private var bedTime = calculateBedtime
    
    // this one needs to be static, otherwise it want be initilized a cannot be used in wakeUp
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var goToBed: String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTitle = "Your ideal bedtime is..."
            let goBed = sleepTime.formatted(date: .omitted, time: .shortened)
            return goBed
        } catch {
            alertTitle = "Error"
            let goBed = "Sorry, there was a problem calculating your bedtime"
            return goBed
        }
    }
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section("When do you want to wake up?") {
                    DatePicker("Please enter the time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .frame(width: 180, height: 40, alignment: .trailing)
                        .labelsHidden()
                }
                
                Section("Desired amount of sleep") {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                Section("Daily coffee intake") {
               //     Stepper("^[\(coffeAmount) cup](inflect: true)", value: $coffeAmount, in: 1...20, step: 1)
                    
                    Picker("Daily coffee intake", selection: $coffeAmount) {
                        ForEach(1 ..< 21) {
                            Text("^[\($0) cup](inflect: true)")
                        }
                    }
                }
                Section("Your ideal bedtime is...") {
                    Text(goToBed)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .frame(width: 200, height: 60, alignment: .trailing)
                }
            }

            
            .navigationTitle("BetterRest")
//            .toolbar {
//                Button("Calculate", action: calculateBedTime)
//            }
//            .alert(alertTitle, isPresented: $showingAlert) {
//                Button("OK") {}
//            } message: {
//                Text(alertMessage)
//            }
        }
    }

//    func calculateBedTime() {
//        do {
//            let config = MLModelConfiguration()
//            let model = try SleepCalculator(configuration: config)
//            
//            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
//            let hour = (components.hour ?? 0) * 60 * 60
//            let minute = (components.minute ?? 0) * 60
//            
//            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeAmount))
//            
//            let sleepTime = wakeUp - prediction.actualSleep
//            
//            alertTitle = "Your ideal bedtime is..."
//            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
//        } catch {
//            alertTitle = "Error"
//            alertMessage = "Sorry, there was a problem calculating your bedtime"
//        }
//        
//        showingAlert = true
//    }
    
    
}

#Preview {
    ContentView()
}
