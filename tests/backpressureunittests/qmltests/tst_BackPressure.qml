import QtQuick 2.0
import QtTest 1.0
import Testable 1.0
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

        function test_oneInTime() {
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

        function test_oneInTime_owner() {
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

    }
}
