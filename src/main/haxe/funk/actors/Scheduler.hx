package funk.actors;

using funk.actors.dispatch.MessageDispatcher;
using funk.types.Function0;
using funk.reactives.Process;

typedef Cancellable = {

    function cancel() : Void;

    function isCancelled() : Bool;
}

typedef Scheduler = {

    function schedule<T>(reciever : ActorRef, message : T) : Cancellable;

    function scheduleOnce<T>(reciever : ActorRef, message : T) : Cancellable;
}

class DefaultScheduler {

    private var _dispatcher : Function0<MessageDispatcher>;

    public function new(dispatcher : Function0<MessageDispatcher>) {
        _dispatcher = dispatcher;
    }

    public function schedule<T>(reciever : ActorRef, message : T) : Cancellable {
        var task = Process.start(function() {
            var dispatcher = _dispatcher();
            dispatcher.execute(this);
        }, 1);

        var cancelled = false;

        return {
            cancel: function() return task.foreach(function(value) { value.stop(); cancelled = true; }),
            isCancelled: function() return cancelled
        };
    }

    public function scheduleOnce<T>(reciever : ActorRef, message : T) : Cancellable {
        var task = Process.start(function() {
            var dispatcher = _dispatcher();
            dispatcher.execute(this);
        }, 1);

        var cancelled = false;

        if (task.isDefined()) {
            task.stop();
            cancelled = true;
        }

        return {
            cancel: function() return task.foreach(function(value) { value.stop(); cancelled = true; }),
            isCancelled: function() return cancelled
        };
    }
}