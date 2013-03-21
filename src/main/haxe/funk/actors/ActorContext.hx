package funk.actors;

import funk.actors.ActorRefProvider;

using funk.types.Option;
using funk.collections.immutable.List;

interface ActorContext extends ActorRefFactory {

    function self() : ActorRef;

    function sender() : ActorRef;
}

class ActorContextInjector {

    private static var _contexts : List<ActorContext> = Nil;

    private static var _currentContext : Option<ActorContext> = None;

    public static function pushContext(context : ActorContext) : Void {
        _currentContext = Some(context);
        _contexts = _contexts.prepend(context);
    }

    public static function popContext() : Void {
        _contexts = _contexts.tail();
        _currentContext = _contexts.headOption();
    }

    inline public static function currentContext() : Option<ActorContext> return _currentContext;
}
