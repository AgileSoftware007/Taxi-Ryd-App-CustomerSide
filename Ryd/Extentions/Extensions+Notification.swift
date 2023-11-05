//  Extensions+ Notification.swift
//  WePrep

import Foundation
extension Notification.Name {
    static let showDriverCar = Notification.Name("showDriverCar")
    static let removeCar = Notification.Name("removeCar")
    static let carLists = Notification.Name("getCarlist")
    static let showFindRideCars = Notification.Name("showFindRideCars")
    static let acceptRide = Notification.Name("acceptRide")
    static let declineRide = Notification.Name("declineRide")
    static let outSideDriver = Notification.Name("outSideDriver")
    static let showndRideCars = Notification.Name("showndRideCars")
    static let cancelRyd = Notification.Name("cancelRyd")
    static let updateDriverLocation = Notification.Name("updateDriverLocation")
    static let startDestination = Notification.Name("startDestination")
    static let endDestination = Notification.Name("endDestination")
    static let endTrip = Notification.Name("endTrip")
    static let startWaiting = Notification.Name("startWaiting")
    static let endWaiting = Notification.Name("endWaiting")
    static let messageReceived = Notification.Name("messageReceived")
}
