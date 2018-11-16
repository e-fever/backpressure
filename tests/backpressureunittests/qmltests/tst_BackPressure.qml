import QtQuick 2.0
import QtTest 1.0
import Testable 1.0
import QuickPromise 1.0
import "../../../Backpressure"

Item {
    id: window
    height: 640
    width: 480

    TestCase {
        name: "Backpressure"

        Component {
            id: creator
            Item {
            }
        }

        property alias holder: loader.item

        Loader {
            id: loader
            sourceComponent: Item {}
        }

        function init() {
            loader.active = true;
        }

        function cleanup() {
            loader.active = false;
        }

        function tick() {
            var i = 10;
            while (i--) {
                wait(0);
            }
        }

        function test_clearTimeout() {
            var called = false;
            var timerId = Backpressure.setTimeout(null, 100,function() {
                called = true;
            });

            compare(timerId !== undefined, true);
            compare(Backpressure._timers.hasOwnProperty(timerId), true);

            Backpressure.clearTimeout(timerId);
            compare(Backpressure._timers.hasOwnProperty(timerId), false);

            wait(200);
            compare(called, false);
        }

        function test_debounce() {
            var count = 0;
            var values = [];
            function callback(value) {
                count++;
                values.push(value);
            }

            var emit = Backpressure.debounce(null, 100, callback);
            emit(1);
            compare(count, 0);
            emit(2);
            compare(count, 0);

            wait(300);
            compare(count, 1);
            compare(values, [2]);
        }

        function test_debounce_owner() {
            var item = creator.createObject();

            var count = 0;
            var values = [];
            function callback(value) {
                count++;
                values.push(value);
            }

            var emit = Backpressure.debounce(item, 500, callback);
            item.destroy();

            wait(1000);
            compare(count, 0);
        }

        function test_oneInTime_without_owner_argument() {
            var count = 0;
            var values = [];
            function callback(value) {
                count++;
                values.push(value);
            }

            var emit = Backpressure.oneInTime(null,100,callback);
            emit(1);
            compare(count, 1);
            compare(values, [1]);
            emit(2);

            compare(count, 1);
            compare(values, [1]);

            wait(300);

            emit(3);
            compare(count, 2);
            compare(values, [1,3]);
        }

        function test_oneInTime_with_owner_argument() {
            var item = creator.createObject();

            var count = 0;
            var values = [];
            function callback(value) {
                count++;
                values.push(value);
            }

            var emit = Backpressure.oneInTime(item, 500, callback);
            item.destroy();

            wait(1000);
            compare(count, 0);
        }

        function test_promisedOneInTime_not_returing_a_promise() {
            var oneInTime = Backpressure.promisedOneInTime(holder, function() {
                return 1;
            });

            var actualResult;
            var promise = oneInTime();

            promise.then(function (result) {
                actualResult = result;
            });

            tick();

            compare(actualResult, 1);
        }

        function test_promisedOneInTime_return_a_promise() {

            var oneInTime = Backpressure.promisedOneInTime(holder, function() {
                return Q.promise(function(fulfill, reject) {
                    Q.setTimeout(function() {
                        fulfill(99);
                    }, 50);
                });
            });

            var actualResult = {};
            var promise = oneInTime();

            promise.then(function (result) {
                actualResult.value = result;
            });

            tryCompare(actualResult, "value", 99, 2000);
        }

        function test_promisedOneInTime_forbid_2nd_call() {

            var oneInTime = Backpressure.promisedOneInTime(holder, function(value) {
                return Q.promise(function(fulfill, reject) {
                    Q.setTimeout(function() {
                        fulfill(value);
                    }, 50);
                });
            });

            var actualResult = {};

            oneInTime(33).then(function (result) {
                actualResult.value = result;
            });

            oneInTime(44).then(function(result) {
                actualResult.value = result;
            });

            tryCompare(actualResult, "value", 33, 2000);

            wait(100);
            compare(actualResult.value, 33, 2000);
        }

    }
}
