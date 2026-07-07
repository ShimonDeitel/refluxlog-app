import XCTest
@testable import RefluxLog

@MainActor
final class RefluxLogTests: XCTestCase {
    func testSeedDataLoaded() {
        let store = Store()
        XCTAssertFalse(store.entries.isEmpty)
    }

    func testAddEntry() {
        let store = Store()
        let before = store.entries.count
        store.add(title: "Test", metric: 5, tag: "Coffee")
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testAddRespectsFreeLimit() {
        let store = Store()
        store.entries = []
        for i in 0..<Store.freeLimit {
            store.add(title: "E\(i)", metric: 1, tag: "Coffee")
        }
        let result = store.add(title: "Over", metric: 1, tag: "Coffee")
        XCTAssertFalse(result)
        XCTAssertEqual(store.entries.count, Store.freeLimit)
    }

    func testProBypassesLimit() {
        let store = Store()
        store.entries = []
        store.isPro = true
        for i in 0..<(Store.freeLimit + 3) {
            store.add(title: "E\(i)", metric: 1, tag: "Coffee")
        }
        XCTAssertEqual(store.entries.count, Store.freeLimit + 3)
    }

    func testDeleteEntry() {
        let store = Store()
        store.entries = []
        store.add(title: "ToDelete", metric: 1, tag: "Coffee")
        let entry = store.entries[0]
        store.delete(entry)
        XCTAssertTrue(store.entries.isEmpty)
    }

    func testDeleteAtOffsets() {
        let store = Store()
        store.entries = []
        store.add(title: "A", metric: 1, tag: "Coffee")
        store.add(title: "B", metric: 2, tag: "Coffee")
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.entries.count, 1)
    }

    func testUpdateEntry() {
        let store = Store()
        store.entries = []
        store.add(title: "Orig", metric: 1, tag: "Coffee")
        var entry = store.entries[0]
        entry.title = "Updated"
        store.update(entry)
        XCTAssertEqual(store.entries[0].title, "Updated")
    }

    func testCanAddMoreReflectsLimit() {
        let store = Store()
        store.entries = []
        XCTAssertTrue(store.canAddMore)
    }
}
