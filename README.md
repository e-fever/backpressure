Backpressure
============

Backpressure happens on a stream of data where you are not fast enough to process. 
This library is designed to provide a few mechanism to handle it.

Installation
============

    qpm install net.efever.backpressure
    
    
API
===

```
import Backpressure 1.0
```


**Backpressure.oneInTime(owner, duration, callback)**

It will create a wrapper function of the callback. Whatever you have invoked the wrapper function, it will execute the callback immediately. Then it will be blocked within duration period. It could prevent to process the same event twice within the duration period.

Example:
```

Item {
  id : item
  property var processClick : Backpressure.oneInTime(item, 500, function(value) { /* Callback */ });

  MouseArea {
    onClicked: {
       proessClick(value);
    }
  }

}
```

If the owner is destroyed, the callback will be executed 


**Backpressure.debounce(owner, duration, callback)**

If will create a wrapper function of the callback. Whatever you have invoked the wrapper function, it won't execute the callback until the duration period finished. If user invoked the wrapper function again within the period, then the previous call will be dropped, and the timer is restarted.

It will guarantee only the last function call and parameter will be passed to the callback.

Reference: [ReactiveX - Debounce operator](http://reactivex.io/documentation/operators/debounce.html)
